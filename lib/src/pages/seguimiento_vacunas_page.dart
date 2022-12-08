import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/models/registro_vacunas_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/providers/formularios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:flutter/material.dart';

class VerRegistroVacunasPage extends StatefulWidget {
  const VerRegistroVacunasPage({Key? key}) : super(key: key);

  @override
  State<VerRegistroVacunasPage> createState() => _VerRegistroVacunasPageState();
}

class _VerRegistroVacunasPageState extends State<VerRegistroVacunasPage> {
  final formKey = GlobalKey<FormState>();
  FormulariosProvider formulariosProvider = new FormulariosProvider();
  AnimalModel animal = new AnimalModel();
  FormulariosModel formularios = new FormulariosModel();
  DatosPersonalesModel datosA = new DatosPersonalesModel();
  final userProvider = new UsuarioProvider();

  List<RegistroVacunasModel> vacunas = [];
  List<Future<RegistroVacunasModel>> listaV = [];

  @override
  void initState() {
    // _selection = _items.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    datosA = arg['datosper'] as DatosPersonalesModel;
    formularios = arg['formulario'] as FormulariosModel;
    animal = arg['animal'] as AnimalModel;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 236, 234, 219),
        appBar: AppBar(
          title: Text('Lista de vacunas'),
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
        body: Stack(children: [
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
        ]));
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
        future: formulariosProvider.cargarVacunas(formularios.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<RegistroVacunasModel>> snapshot) {
          if (snapshot.hasData) {
            final vacunas = snapshot.data;
            return Column(
              children: [
                SizedBox(
                  height: 650,
                  child: ListView.builder(
                    itemCount: vacunas!.length,
                    itemBuilder: (context, i) =>
                        _crearItem(context, vacunas[i]),
                  ),
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(BuildContext context, RegistroVacunasModel vacuna) {
    return ListTile(
        title: Column(children: [
          SizedBox(
            height: 245.0,
            width: 650.0,
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
                            width: 125.0,
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
                            width: 70.0,
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
                            width: 125.0,
                            child: Center(
                              child: Text(
                                'Próxima vacuna',
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
                          width: 125.0,
                          child: Center(
                              child: Center(
                                  child: Text(
                            vacuna.fechaConsulta,
                            textAlign: TextAlign.center,
                          )))),
                      SizedBox(
                          height: 50.0,
                          width: 70.0,
                          child: Center(
                            child: Text(
                              vacuna.pesoActual.toString(),
                              textAlign: TextAlign.center,
                            ),
                          )),
                      SizedBox(
                          height: 50.0,
                          width: 125.0,
                          child: Center(
                              child: Text(
                            vacuna.fechaProximaVacuna,
                            textAlign: TextAlign.center,
                          )))
                    ],
                  ),
                  ColoredBox(
                    color: Color.fromARGB(255, 51, 178, 213),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 50.0,
                            width: 160.0,
                            child: Center(
                              child: Text(
                                'Vacuna laboratorio',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        SizedBox(
                            height: 50.0,
                            width: 160.0,
                            child: Center(
                              child: Text(
                                'Veterinario responsable',
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
                          width: 160.0,
                          child: Center(
                              child: Text(
                            vacuna.tipoVacuna,
                            textAlign: TextAlign.center,
                          ))),
                      SizedBox(
                          height: 50.0,
                          width: 160.0,
                          child: Center(
                            child: Text(
                              vacuna.veterinarioResp,
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
        ]),
        //subtitle: Text('${horario}'),
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
            leading:
                Icon(Icons.medication_liquid_outlined, color: Colors.green),
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
              Navigator.pop(context);
              Navigator.pushNamed(context, 'verEvidenciaP1', arguments: {
                'datosper': datosA,
                'formulario': formularios,
                'animal': animal
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.picture_as_pdf_outlined, color: Colors.green),
            title: Text('Documentos'),
            onTap: () {
              Navigator.pop(context);
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
