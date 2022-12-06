import 'package:aministrador_app_v1/src/models/donaciones_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/providers/donaciones_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class VerDonacionesOut1Page extends StatefulWidget {
  VerDonacionesOut1Page({Key? key}) : super(key: key);

  @override
  _VerDonacionesOut1PageState createState() => _VerDonacionesOut1PageState();
}

class _VerDonacionesOut1PageState extends State<VerDonacionesOut1Page> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final donacionesProvider = new DonacionesProvider();
  final userProvider = new UsuarioProvider();
  DonacionesModel donaciones = new DonacionesModel();
  final List<String> _items =
      ['Alimento', 'Medicina', 'Insumos Higiénicos', 'Otros'].toList();
  String? _selection;
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
        title: Text('Registro de donaciones'),
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
                      _buildChild(),
                      Divider(),
                      _crearDescripcion(),
                      Divider(),
                      _crearFecha(),
                      Divider(),
                      //_crearBoton(),
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
      enabled: false,
      initialValue: donaciones.tipo,
      readOnly: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Tipo de Donación:',
          labelStyle: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildChild() {
    if (donaciones.tipo == 'Alimento') {
      return _crearPeso();
    } //else {
    return Text('');
  }

  Widget _crearPeso() {
    //if (_selection == 'Alimento') {
    return TextFormField(
      enabled: false,
      initialValue: donaciones.peso.toString(),
      readOnly: true,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Ingrese Peso (Kg.):',
        labelStyle: TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
    //}
  }

  Widget _crearDescripcion() {
    return TextFormField(
      enabled: false,
      initialValue: donaciones.descripcion,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Descripción:',
          labelStyle: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
      onChanged: (s) {
        setState(() {
          donaciones.descripcion = s;
        });
      },
    );
  }

  Widget _crearFecha() {
    return TextFormField(
      enabled: false,
      initialValue: donaciones.fechaIngreso,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Fecha de registro:',
          labelStyle: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
      onChanged: (s) {
        setState(() {
          donaciones.descripcion = s;
        });
      },
    );
  }

  Widget _crearUnidades() {
    return TextFormField(
      enabled: false,
      initialValue: donaciones.cantidad.toString(),
      //readOnly: false,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          labelText: 'Cantidad (Unidades):',
          labelStyle: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
      onChanged: (s) {
        setState(() {
          donaciones.cantidad = int.parse(s);
        });
      },
    );
  }
}
