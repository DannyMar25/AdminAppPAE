import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/models/registro_desparasitaciones_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/providers/formularios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';

import 'package:flutter/material.dart';

class VerRegistroDespPage extends StatefulWidget {
  const VerRegistroDespPage({Key? key}) : super(key: key);

  @override
  State<VerRegistroDespPage> createState() => _VerRegistroDespPageState();
}

class _VerRegistroDespPageState extends State<VerRegistroDespPage> {
  final formKey = GlobalKey<FormState>();
  FormulariosProvider formulariosProvider = new FormulariosProvider();
  AnimalModel animal = new AnimalModel();
  FormulariosModel formularios = new FormulariosModel();
  DatosPersonalesModel datosA = new DatosPersonalesModel();

  List<RegistroDesparasitacionModel> desparasitaciones = [];
  List<Future<RegistroDesparasitacionModel>> listaD = [];
  final userProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    datosA = arg['datosper'] as DatosPersonalesModel;
    formularios = arg['formulario'] as FormulariosModel;
    animal = arg['animal'] as AnimalModel;
    return Scaffold(
        //backgroundColor: Color.fromARGB(223, 211, 212, 207),
        backgroundColor: Color.fromARGB(255, 236, 234, 219),
        appBar: AppBar(
          title: Text('Lista de desparasitaciones'),
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
        drawer: _menuWidget(),
        body: Stack(
          children: [
            //Background(),
            SingleChildScrollView(
                child: Container(
                    //color: Colors.lightGreenAccent,
                    padding: new EdgeInsets.only(top: 10.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Registros',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: Color.fromARGB(255, 243, 165, 9),
                              ),
                              textAlign: TextAlign.start,
                            ),
                            _crearListado()
                          ],
                        ))))
          ],
        ));
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

  Widget _crearListado() {
    return FutureBuilder(
        future: formulariosProvider.cargarRegDesp(formularios.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<RegistroDesparasitacionModel>> snapshot) {
          if (snapshot.hasData) {
            final desp = snapshot.data;
            return Column(
              children: [
                SizedBox(
                  height: 650,
                  child: ListView.builder(
                    itemCount: desp!.length,
                    itemBuilder: (context, i) => _crearItem(context, desp[i]),
                  ),
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(
      BuildContext context, RegistroDesparasitacionModel desparasitacion) {
    return ListTile(
        title: Column(
          children: [
            SizedBox(
              height: 245.0,
              width: 620.0,
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white)),
                color: Color.fromARGB(255, 243, 243, 230),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.all(1.0)),
                    ColoredBox(
                      color: Color.fromARGB(255, 51, 178, 213),
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 15)),
                          SizedBox(
                              height: 50.0,
                              width: 140.0,
                              child: Center(
                                child: Text(
                                  'Fecha consulta',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                              height: 50.0,
                              width: 180.0,
                              child: Center(
                                child: Text(
                                  'Producto',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 50.0,
                          width: 140.0,
                          child: Center(
                            child: Text(
                              desparasitacion.fecha,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 50.0,
                            width: 180.0,
                            child: Center(
                              child: Text(
                                desparasitacion.nombreProducto,
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ],
                    ),
                    ColoredBox(
                      //color: Color.fromARGB(255, 33, 168, 39),
                      color: Color.fromARGB(255, 51, 178, 213),
                      child: Row(
                        children: [
                          SizedBox(
                              height: 50.0,
                              width: 130.0,
                              child: Center(
                                child: Text(
                                  'Peso (Kg.)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          SizedBox(
                              height: 50.0,
                              width: 190.0,
                              child: Center(
                                child: Text(
                                  'Próxima desparacitación',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                            height: 50.0,
                            width: 130.0,
                            child: Center(
                              child: Text(
                                desparasitacion.pesoActual.toString(),
                                textAlign: TextAlign.center,
                              ),
                            )),
                        SizedBox(
                            height: 50.0,
                            width: 190.0,
                            child: Center(
                              child: Text(
                                desparasitacion.fechaProxDesparasitacion,
                                textAlign: TextAlign.center,
                              ),
                            ))
                      ],
                    )
                  ],
                ),
                elevation: 8,
                shadowColor: Color.fromARGB(255, 19, 154, 156),
                margin: EdgeInsets.all(20),
              ),
            ),
          ],
        ),
        onTap: () async {});
  }

  Widget _menuWidget() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/pet-care.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.green,
            ),
            title: Text('Inicio'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushNamed(context, 'bienvenida');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.list,
              color: Colors.green,
            ),
            title: Text('Lista de adopciones'),
            onTap: () => Navigator.pushNamed(context, 'seguimientoPrincipal'),
          ),
          ListTile(
            leading: Icon(
              Icons.manage_search_rounded,
              color: Colors.green,
            ),
            title: Text('Seguimiento de mascota'),
            onTap: () => Navigator.pushNamed(context, 'seguimientoInfo',
                arguments: {
                  'datosper': datosA,
                  'formulario': formularios,
                  'animal': animal
                }),
          ),
          ListTile(
            leading: Icon(
              Icons.vaccines,
              color: Colors.green,
            ),
            title: Text('Vacunas'),
            onTap: () => Navigator.pushNamed(context, 'verRegistroVacunas',
                arguments: {
                  'datosper': datosA,
                  'formulario': formularios,
                  'animal': animal
                }),
          ),
          ListTile(
            leading: Icon(Icons.medication_liquid_rounded, color: Colors.green),
            title: Text('Desparasitaciones'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushNamed(context, 'verRegistroDesp', arguments: {
                'datosper': datosA,
                'formulario': formularios,
                'animal': animal
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.photo, color: Colors.green),
            title: Text('Fotos'),
            onTap: () {
              Navigator.pushNamed(context, 'verEvidenciaP1', arguments: {
                'datosper': datosA,
                'formulario': formularios,
                'animal': animal
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.picture_as_pdf, color: Colors.green),
            title: Text('Documentos'),
            onTap: () {
              Navigator.pushNamed(context, 'verEvidenciaP2', arguments: {
                'datosper': datosA,
                'formulario': formularios,
                'animal': animal
              });
            },
          ),
        ],
      ),
    );
  }
}
