import 'package:aministrador_app_v1/src/models/donaciones_model.dart';
import 'package:aministrador_app_v1/src/providers/donaciones_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/utils/utils.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
//import 'package:aministrador_app_v1/src/utils/utils.dart' as utils;
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
  // final List<String> _items =
  //     ['Alimento', 'Medicina', 'Insumos Higiénicos', 'Otros'].toList();
  // String? _selection;
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
        title: Text('Anadir donación saliente'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: Icon(Icons.manage_accounts),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      child: Text("Información"),
                      value: 0,
                    ),
                    PopupMenuItem<int>(
                      child: Text("Ayuda"),
                      value: 1,
                    ),
                    PopupMenuItem<int>(
                      child: Text("Cerrar Sesión"),
                      value: 2,
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
                        'Donaciones',
                        style: TextStyle(
                          fontSize: 33,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.blueGrey[300]!,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Divider(),

                      Divider(),
                      _crearTipoDonacion(),
                      Divider(),
                      _crearUnidades(),
                      Divider(),
                      _crearCantidadDonar(),
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
        break;
      case 1:
        Navigator.pushNamed(context, 'soporte');
        break;
      case 2:
        userProvider.signOut();
        Navigator.pushNamed(context, 'login');
    }
  }

  Widget _crearTipoDonacion() {
    return TextFormField(
      initialValue: donaciones.tipo,
      readOnly: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Tipo de Donación:',
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
    return NumberInputPrefabbed.squaredButtons(
      controller: cantidadOut,
      min: 1,
      max: donaciones.cantidad,
      initialValue: 1,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Ingresa una cantidad valida';
        } else if (int.parse(value) < 1 ||
            int.parse(value) > donaciones.cantidad) {
          return 'Ingrese cantidad dentro del rango';
        } else {
          return null;
        }
      },
      //onChanged: ,
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
            content: Text('Información ingresada correctamente'),
          );
          _submit();
        } else {
          mostrarAlerta(context,
              'Asegurate de que todos los campos esten llenos y que los valores ingresados sean correctos.');
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
