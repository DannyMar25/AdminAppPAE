import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/models/evidencia_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/models/registro_desparasitaciones_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/providers/formularios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:flutter/material.dart';

class VerEvidenciaFotosPage extends StatefulWidget {
  const VerEvidenciaFotosPage({Key? key}) : super(key: key);

  @override
  State<VerEvidenciaFotosPage> createState() => _VerEvidenciaFotosPageState();
}

class _VerEvidenciaFotosPageState extends State<VerEvidenciaFotosPage> {
  final formKey = GlobalKey<FormState>();
  FormulariosProvider formulariosProvider = new FormulariosProvider();
  AnimalModel animal = new AnimalModel();
  FormulariosModel formularios = new FormulariosModel();
  DatosPersonalesModel datosA = new DatosPersonalesModel();
  EvidenciasModel evidenciaF = new EvidenciasModel();

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
        backgroundColor: Color.fromARGB(255, 239, 243, 243),
        appBar: AppBar(
          title: Text('Evidencias'),
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
                              'Fotos recibidas',
                              style: TextStyle(
                                fontSize: 25,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 2
                                  ..color = Colors.blueGrey,
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
        future: formulariosProvider.cargarEvidenciaF(formularios.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<EvidenciasModel>> snapshot) {
          if (snapshot.hasData) {
            final evidF = snapshot.data;
            return Column(
              children: [
                SizedBox(
                  height: 660,
                  child: ListView.builder(
                    itemCount: evidF!.length,
                    itemBuilder: (context, i) => _crearItem(context, evidF[i]),
                  ),
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(BuildContext context, EvidenciasModel evidencia) {
    DateTime fechaIngresoT = DateTime.parse(evidencia.fecha);
    String fechaIn = fechaIngresoT.year.toString() +
        '-' +
        fechaIngresoT.month.toString() +
        '-' +
        fechaIngresoT.day.toString();
    if (evidencia.fotoUrl != "") {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(20),
        child: ListTile(
            title: Column(children: [
              FadeInImage(
                image: NetworkImage(evidencia.fotoUrl),
                placeholder: AssetImage('assets/cat_1.gif'),
                height: 280.0,
                //width: 400,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              ListTile(
                title: Text(
                  fechaIn,
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
            onTap: () async {
              Navigator.pushNamed(context, 'verFotoEvidencia',
                  arguments: evidencia);
            }),
        shadowColor: Colors.green,
      );
    } else {
      return SizedBox();
    }
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
            leading: Icon(Icons.picture_as_pdf_rounded, color: Colors.green),
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
