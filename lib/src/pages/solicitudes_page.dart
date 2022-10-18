import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
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
  AnimalModel animal = new AnimalModel();
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
        title: Text('Solicitudes pendientes'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: Icon(Icons.manage_accounts),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                //comprobarSolicitudes()
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

  showCitas() async {
    formularioC = await formulariosProvider.cargarFormularios();
    for (var yy in formularioC) {
      FormulariosModel form = await yy;
      setState(() {
        formularioA.add(form);
      });
    }
  }

  comprobarSolicitudes() {
    if (formularioA.length == 0) {
      return Column(children: [
        AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 45,
              ),
              Text('Información'),
            ],
          ),
          content: Text('No se ha encotrado ninguna solicitud pendiente.'),
          actions: [
            TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pushNamed(context, 'home');
                })
          ],
        )
      ]);
    } else {
      return _verListado();
    }
  }

  Widget _verListado() {
    return Column(
      children: [
        SizedBox(
          height: 680,
          child: ListView.builder(
            itemCount: formularioA.length,
            itemBuilder: (context, i) => _crearItem(context, formularioA[i]),
          ),
        ),
      ],
    );
  }

  Widget _crearItem(BuildContext context, FormulariosModel formulario) {
    DateTime fechaIngresoT = DateTime.parse(formulario.fechaIngreso);
    String fechaIn = fechaIngresoT.year.toString() +
        '-' +
        fechaIngresoT.month.toString() +
        '-' +
        fechaIngresoT.day.toString();
    return ListTile(
      title: Column(
        children: [
          //Divider(color: Colors.purple),
          Card(
            child: Container(
              height: 170,
              color: Colors.white,
              child: Row(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 0.1),
                      child: Expanded(
                        child: Image.asset(
                          "assets/pet.jpg",
                          height: 130,
                        ),
                        flex: 5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 20,
                            child: ListTile(
                              title: Text(
                                  "Cliente: " + '${formulario.nombreClient}'),
                              subtitle: Column(
                                children: [
                                  Text("Fecha de solicitud:" + '$fechaIn'),
                                  Text("Posible adoptante para: " +
                                      '${formulario.animal!.nombre}'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: Text("VER INFO"),
                                  onPressed: () => Navigator.pushNamed(
                                      context, 'verSolicitudesMain',
                                      arguments: formulario),
                                  //
                                ),
                                SizedBox(
                                  width: 5, //8
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    flex: 8,
                  ),
                ],
              ),
            ),
            elevation: 8,
            margin: EdgeInsets.all(10),
          ),
          // Divider(color: Colors.purple)
        ],
      ),
    );
  }
}
