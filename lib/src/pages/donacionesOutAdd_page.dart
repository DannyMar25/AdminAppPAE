import 'package:aministrador_app_v1/src/models/donaciones_model.dart';
import 'package:aministrador_app_v1/src/providers/donaciones_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
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
  final List<String> _items =
      ['Alimento', 'Medicina', 'Insumos Higienicos', 'Otros'].toList();
  String? _selection;
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
        title: Text('Anadir donacion saliente'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: Icon(Icons.manage_accounts),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      child: Text("Informacion"),
                      value: 0,
                    ),
                    PopupMenuItem<int>(
                      child: Text("Ayuda"),
                      value: 1,
                    ),
                    PopupMenuItem<int>(
                      child: Text("Cerrar Sesion"),
                      value: 2,
                    )
                  ]),
          // Builder(builder: (BuildContext context) {
          //   return TextButton(
          //     style: ButtonStyle(
          //       foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          //     ),
          //     onPressed: () async {
          //       userProvider.signOut();
          //       Navigator.pushNamed(context, 'login');
          //     },
          //     child: Text('Sign Out'),
          //   );
          // }),
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
          labelText: 'Tipo de Donacion:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      onChanged: (s) {
        s = donaciones.tipo;
        setState(() {
          donaciones.tipo = s;
        });
      },
    );
  }

  // Widget _buildChild() {
  //   if (_selection == 'Alimento') {
  //     return _crearPeso();
  //   } //else {
  //   //   if (_selection == 'Otros') {
  //   //     return _crearDonacion();
  //   //   }
  //   // }
  //   return Text('');
  // }

  // Widget _crearPeso() {
  //   //if (_selection == 'Alimento') {
  //   return TextFormField(
  //     initialValue: donaciones.peso.toString(),
  //     readOnly: true,
  //     textCapitalization: TextCapitalization.sentences,
  //     keyboardType: TextInputType.numberWithOptions(decimal: true),
  //     decoration: InputDecoration(
  //       labelText: 'Peso (Kg.):',
  //       labelStyle: TextStyle(fontSize: 16, color: Colors.black),
  //     ),
  //     onChanged: (s) {
  //       setState(() {
  //         donaciones.peso = double.parse(s);
  //       });
  //     },
  //   );
  //   //}
  // }

  Widget _crearDescripcion() {
    return TextFormField(
      initialValue: donaciones.descripcion,
      readOnly: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Descripcion:',
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
      //onChanged: ,
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return Colors.deepPurple;
        }),
      ),
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      autofocus: true,
      //onPressed: (_guardando) ? null : _submit,
      onPressed: () {
        _submit();
      },
    );
  }

  void _submit() async {
    print(int.tryParse(cantidadOut.text));
    int? cantidadAdd = int.tryParse(cantidadOut.text);
    //   if (donaciones.id == "") {
    //     donaciones.estadoDonacion = 'Saliente';
    //     donacionesProvider.crearDonacion(donaciones);
    //   } else {
    //     donaciones.estadoDonacion = 'Saliente';
    //     donacionesProvider.editarDonacion(donaciones);
    //   }
    //   //mostrarSnackbar('Registro guardado');
    //   Navigator.pushNamed(context, 'verDonacionesInAdd');
    // }

    if (donaciones.cantidad == 1) {
      donaciones.estadoDonacion = 'Saliente';
      donaciones.cantidad = cantidadAdd!;
      donacionesProvider.crearDonacion(donaciones);
      donacionesProvider.borrarDonacion(donaciones.id);
      Navigator.pushNamed(context, 'verDonacionesOutAdd');
    }
    if (donaciones.cantidad == int.tryParse(cantidadOut.text)) {
      donaciones.estadoDonacion = 'Saliente';
      donaciones.cantidad = int.tryParse(cantidadOut.text)!;
      donacionesProvider.crearDonacion(donaciones);
      donacionesProvider.borrarDonacion(donaciones.id);
      Navigator.pushNamed(context, 'verDonacionesOutAdd');
    } else {
      int cantidadAdd1 = donaciones.cantidad - int.tryParse(cantidadOut.text)!;
      donaciones.estadoDonacion = 'Saliente';
      donaciones.cantidad = int.tryParse(cantidadOut.text)!;
      donacionesProvider.editarCantidad(donaciones, cantidadAdd1);
      donacionesProvider.crearDonacion(donaciones);
      Navigator.pushNamed(context, 'verDonacionesOutAdd');

      //donacionesProvider.eliminar(donaciones.id);
    }
  }
}
