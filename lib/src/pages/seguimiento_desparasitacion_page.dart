import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/models/registro_desparasitaciones_model.dart';
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
        backgroundColor: Color.fromARGB(223, 211, 212, 207),
        appBar: AppBar(
          title: Text('Registros de desparasitacion'),
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
                              'Registro de desparasitacion',
                              style: TextStyle(
                                fontSize: 28,
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
        break;
      case 1:
        Navigator.pushNamed(context, 'soporte');
        break;
      case 2:
        userProvider.signOut();
        Navigator.pushNamed(context, 'login');
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
                  height: 700,
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
            Divider(color: Colors.transparent),
            DataTable(
              headingRowColor: MaterialStateColor.resolveWith(
                (states) => Color.fromARGB(255, 120, 110, 148),
              ),
              dataRowColor: MaterialStateColor.resolveWith(
                  (states) => Color.fromARGB(255, 146, 155, 185)),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                border: Border.all(width: 1, color: Colors.white),
              ),
              sortColumnIndex: 1,
              sortAscending: false,
              columns: [
                DataColumn(label: Text("Fecha consulta")),
                DataColumn(label: Text("Producto")),
              ],
              rows: [
                DataRow(selected: true, cells: [
                  DataCell(Container(
                    child: Text('${desparasitacion.fecha}'),
                    width: 137,
                  )),
                  DataCell(Container(
                    child: Text('${desparasitacion.nombreProducto}'),
                    width: 137,
                  )),
                ]),
              ],
            ),
            DataTable(
              headingRowColor: MaterialStateColor.resolveWith(
                (states) => Color.fromARGB(255, 120, 111, 143),
              ),
              dataRowColor: MaterialStateColor.resolveWith(
                  (states) => Color.fromARGB(255, 146, 155, 185)),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                border: Border.all(width: 1, color: Colors.white),
              ),
              //sortColumnIndex: 1,
              //sortAscending: false,
              columns: [
                //DataColumn(label: Text("Peso(Kg)"), numeric: true),
                DataColumn(label: Text("Peso(Kg)")),
                DataColumn(label: Text("Proxima desparacitacion")),
              ],
              rows: [
                DataRow(selected: true, cells: [
                  DataCell(Container(
                    child: Text('${desparasitacion.pesoActual}'),
                    width: 90,
                  )),
                  DataCell(Container(
                    child: Text('${desparasitacion.fechaProxDesparasitacion}'),
                    width: 90,
                  )),
                ]),
              ],
            ),
            Divider(color: Colors.transparent)
          ],
        ),
        //subtitle: Text('${horario}'),
        onTap: () async {
          // datosA = await formulariosProvider.cargarDPId(
          //     formulario.id, formulario.idDatosPersonales);
          // animal = await animalesProvider.cargarAnimalId(formulario.idAnimal);

          // Navigator.pushNamed(context, 'seguimientoMain', arguments: {
          //   'datosper': datosA,
          //   'formulario': formulario,
          //   'animal': animal
          // });
        });
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
              Icons.pages,
              color: Colors.green,
            ),
            title: Text('Ir a Seguimiento Principal'),
            onTap: () => Navigator.pushReplacementNamed(
                context, 'seguimientoInfo', arguments: {
              'datosper': datosA,
              'formulario': formularios,
              'animal': animal
            }),
          ),
          ListTile(
            leading: Icon(
              Icons.check,
              color: Colors.green,
            ),
            title: Text('Ver Registros Vacunas'),
            onTap: () => Navigator.pushReplacementNamed(
                context, 'verRegistroVacunas', arguments: {
              'datosper': datosA,
              'formulario': formularios,
              'animal': animal
            }),
          ),
          ListTile(
            leading: Icon(Icons.check, color: Colors.green),
            title: Text('Ver Registro Desparasitacion'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'verRegistroDesp',
                  arguments: {
                    'datosper': datosA,
                    'formulario': formularios,
                    'animal': animal
                  });
            },
          ),
          ListTile(
            leading: Icon(Icons.check, color: Colors.green),
            title: Text('Ver Fotos'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'verEvidenciaP1',
                  arguments: {
                    'datosper': datosA,
                    'formulario': formularios,
                    'animal': animal
                  });
            },
          ),
          ListTile(
            leading: Icon(Icons.check, color: Colors.green),
            title: Text('Ver Archivos'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'verEvidenciaP2',
                  arguments: {
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
