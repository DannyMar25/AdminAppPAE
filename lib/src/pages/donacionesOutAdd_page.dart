import 'package:aministrador_app_v1/src/models/donaciones_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/providers/donaciones_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/utils/utils.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class IngresoDonacionesOutAddPage extends StatefulWidget {
  IngresoDonacionesOutAddPage({Key? key}) : super(key: key);

  @override
  _IngresoDonacionesOutAddPageState createState() =>
      _IngresoDonacionesOutAddPageState();
}

class _IngresoDonacionesOutAddPageState
    extends State<IngresoDonacionesOutAddPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final donacionesProvider = new DonacionesProvider();
  final userProvider = new UsuarioProvider();
  DonacionesModel donaciones = new DonacionesModel();
  TextEditingController cantidadOut = new TextEditingController();
  @override
  void initState() {
    // _selection = _items.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Object? donacData = ModalRoute.of(context)!.settings.arguments;
    if (donacData != null) {
      donaciones = donacData as DonacionesModel;
      print(donaciones.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar donación saliente'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: Icon(Icons.account_circle),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      child: Text("Soporte"),
                      value: 0,
                    ),
                    PopupMenuItem<int>(
                      child: Text("Cerrar Sesión"),
                      value: 1,
                    )
                  ]),
        ],
      ),
      drawer: MenuWidget(),
      body: Stack(
        children: [
          //Background(),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text(
                        'Datos de donación saliente',
                        style: TextStyle(
                          fontSize: 30,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.blueGrey[300]!,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(
                        color: Colors.transparent,
                      ),

                      const Divider(
                        color: Colors.transparent,
                      ),
                      _crearTipoDonacion(),
                      Divider(),
                      _crearUnidades(),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cantidad por retirar: \n(unidades)'),
                          _crearCantidadDonar()
                        ],
                      ),
                      // _crearCantidadDonar(),
                      //_buildChild(),
                      Divider(),
                      _crearDescripcion(),
                      Divider(),
                      _crearBoton(),
                      // _crearCantidad(),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.pushNamed(context, 'soporte');
        break;
      case 1:
        userProvider.signOut();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      //Navigator.pushNamed(context, 'login');
    }
  }

  Widget _crearTipoDonacion() {
    return TextFormField(
      initialValue: donaciones.tipo,
      readOnly: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Tipo de Donación:  ',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      onChanged: (s) {
        s = donaciones.tipo;
        setState(() {
          donaciones.tipo = s;
        });
      },
    );
  }

  Widget _crearDescripcion() {
    return TextFormField(
      initialValue: donaciones.descripcion,
      readOnly: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Descripción:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      onChanged: (s) {
        setState(() {
          donaciones.descripcion = s;
        });
      },
    );
  }

  Widget _crearUnidades() {
    return TextFormField(
      initialValue: donaciones.cantidad.toString(),
      readOnly: true,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          labelText: 'Cantidad:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      onChanged: (s) {
        setState(() {
          //donaciones.cantidad = int.parse(s);
        });
      },
    );
  }

  Widget _crearCantidadDonar() {
    return SizedBox(
      width: 200, //240
      child: NumberInputPrefabbed.squaredButtons(
        //scaleWidth: 0.3,
        style: TextStyle(fontSize: 18),
        controller: cantidadOut,
        min: 1,
        max: donaciones.cantidad,
        initialValue: 1,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Ingresa una cantidad válida';
          } else if (int.parse(value) < 1 ||
              int.parse(value) > donaciones.cantidad) {
            return 'Ingrese cantidad dentro del rango';
          } else {
            return null;
          }
        },
        //onChanged: ,
      ),
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return Colors.green;
        }),
      ),
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      autofocus: true,
      //onPressed: (_guardando) ? null : _submit,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          // Si el formulario es válido, queremos mostrar un Snackbar
          SnackBar(
            content: Text('Información ingresada correctamente.'),
          );
          _submit();
        } else {
          mostrarAlerta(context,
              'Asegúrate de que todos los campos estén llenos y que los valores ingresados sean correctos.');
        }
      },
    );
  }

  void _submit() async {
    print(int.tryParse(cantidadOut.text));
    int? cantidadAdd = int.tryParse(cantidadOut.text);

    if (donaciones.cantidad == 1) {
      donaciones.fechaIngreso = DateTime.now().year.toString() +
          '-' +
          DateTime.now().month.toString() +
          '-' +
          DateTime.now().day.toString();
      donaciones.estadoDonacion = 'Saliente';
      donaciones.cantidad = cantidadAdd!;
      donacionesProvider.crearDonacion(donaciones);
      donacionesProvider.borrarDonacion(donaciones.id);
      Navigator.pushNamed(context, 'verDonacionesOutAdd');
    }
    if (donaciones.cantidad == int.tryParse(cantidadOut.text)) {
      donaciones.fechaIngreso = DateTime.now().year.toString() +
          '-' +
          DateTime.now().month.toString() +
          '-' +
          DateTime.now().day.toString();
      donaciones.estadoDonacion = 'Saliente';
      donaciones.cantidad = int.tryParse(cantidadOut.text)!;
      donacionesProvider.crearDonacion(donaciones);
      donacionesProvider.borrarDonacion(donaciones.id);
      Navigator.pushNamed(context, 'verDonacionesOutAdd');
    } else {
      int cantidadAdd1 = donaciones.cantidad - int.tryParse(cantidadOut.text)!;
      donaciones.fechaIngreso = DateTime.now().year.toString() +
          '-' +
          DateTime.now().month.toString() +
          '-' +
          DateTime.now().day.toString();
      donaciones.estadoDonacion = 'Saliente';
      donaciones.cantidad = int.tryParse(cantidadOut.text)!;
      donacionesProvider.editarCantidad(donaciones, cantidadAdd1);
      donacionesProvider.crearDonacion(donaciones);
      Navigator.pushNamed(context, 'verDonacionesOutAdd');

      //donacionesProvider.eliminar(donaciones.id);
    }
  }
}
