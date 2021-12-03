import 'package:aministrador_app_v1/src/models/citas_model.dart';
import 'package:aministrador_app_v1/src/providers/animales_provider.dart';
import 'package:aministrador_app_v1/src/providers/citas_provider.dart';
import 'package:aministrador_app_v1/src/providers/horarios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class VerCitasAtendidasPage extends StatefulWidget {
  VerCitasAtendidasPage({Key? key}) : super(key: key);

  @override
  _VerCitasAtendidasPageState createState() => _VerCitasAtendidasPageState();
}

class _VerCitasAtendidasPageState extends State<VerCitasAtendidasPage> {
  List<CitasModel> citasA = [];
  List<Future<CitasModel>> listaC = [];
  final formKey = GlobalKey<FormState>();
  final citasProvider = new CitasProvider();
  final horariosProvider = new HorariosProvider();
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
        title: Text('Citas Atendidas'),
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
    listaC = await citasProvider.cargarCitasAtendidas();
    for (var yy in listaC) {
      CitasModel cit = await yy;
      setState(() {
        citasA.add(cit);
      });
    }
  }

  Widget _verListado() {
    return Column(
      children: [
        SizedBox(
          height: 800,
          child: ListView.builder(
            itemCount: citasA.length,
            itemBuilder: (context, i) => _crearItem(context, citasA[i]),
          ),
        ),
      ],
    );
  }

  Widget _crearItem(BuildContext context, CitasModel cita) {
    String fecha = cita.horario!.dia;
    String hora = cita.horario!.hora;

    return ListTile(
      title: Column(
        children: [
          Divider(color: Colors.purple),
          Text("Nombre del cliente: " + '${cita.nombreClient}'),
          // Text("Posible a doptante para: " '${cita.animal!.nombre}'),
          Text("Fecha de la cita: " + fecha),
          Text("Hora de la cita: " + hora),
          Divider(color: Colors.purple)
        ],
      ),
      //subtitle: Text('${horario}'),
      //onTap: () => Navigator.pushNamed(context, 'verCitasR', arguments: cita),
    );
  }
}
