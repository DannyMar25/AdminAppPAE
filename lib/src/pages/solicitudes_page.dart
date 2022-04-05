import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:flutter/material.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/providers/animales_provider.dart';
import 'package:aministrador_app_v1/src/providers/formularios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';

class SolicitudesPage extends StatefulWidget {
  const SolicitudesPage({Key? key}) : super(key: key);

  @override
  State<SolicitudesPage> createState() => _SolicitudesPageState();
}

class _SolicitudesPageState extends State<SolicitudesPage> {
  List<FormulariosModel> formularioA = [];
  List<Future<FormulariosModel>> formularioC = [];
  DatosPersonalesModel datosC = new DatosPersonalesModel();
  final formKey = GlobalKey<FormState>();
  final formulariosProvider = new FormulariosProvider();
  //final horariosProvider = new HorariosProvider();
  final animalesProvider = new AnimalesProvider();
  final userProvider = new UsuarioProvider();

  @override
  void initState() {
    super.initState();
    showCitas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitudes'),
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
        ],
      ),
      drawer: MenuWidget(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _verListado(),
                // _crearBoton(),
              ],
            ),
          ),
        ),
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

  showCitas() async {
    formularioC = await formulariosProvider.cargarFormularios();
    for (var yy in formularioC) {
      FormulariosModel form = await yy;
      setState(() {
        formularioA.add(form);
      });
    }
  }

  Widget _verListado() {
    return Column(
      children: [
        SizedBox(
          height: 800,
          child: ListView.builder(
            itemCount: formularioA.length,
            itemBuilder: (context, i) => _crearItem(context, formularioA[i]),
          ),
        ),
      ],
    );
  }

  Widget _crearItem(BuildContext context, FormulariosModel formulario) {
    //String fecha = cita.horario!.dia;
    //String hora = cita.horario!.hora;

    return ListTile(
      title: Column(
        children: [
          Divider(color: Colors.purple),
          Text("Fecha de solicitud: " + '${formulario.fechaIngreso}'),
          Text("Nombre del cliente: " + '${formulario.nombreClient}'),
          Text("Identificacion: " + '${formulario.identificacion}'),
          Text("Posible a doptante para: " '${formulario.animal!.nombre}'),
          //Text("Fecha de la cita: " + fecha),
          //Text("Hora de la cita: " + hora),
          Divider(color: Colors.purple)
        ],
      ),
      //subtitle: Text('${horario}'),
      onTap: () => Navigator.pushNamed(context, 'verSolicitudesMain',
          arguments: formulario),
    );
  }
}
