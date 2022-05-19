import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/models/registro_vacunas_model.dart';
import 'package:aministrador_app_v1/src/providers/formularios_provider.dart';
import 'package:aministrador_app_v1/src/widgets/background.dart';
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
        appBar: AppBar(
          title: Text('Registros'),
          backgroundColor: Colors.green,
        ),
        drawer: _menuWidget(),
        body: Stack(children: [
          Background(),
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
                            'Registro de vacunas',
                            style: TextStyle(
                              fontSize: 28,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = Colors.orange[100]!,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          _crearListado()
                        ],
                      ))))
        ]));
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
                  height: 700,
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
        title: Column(
          children: [
            Divider(color: Colors.purple),
            DataTable(
              columns: [
                DataColumn(label: Text("Fecha")),
                DataColumn(label: Text("Peso(Kg)")),
                DataColumn(label: Text("Proxima vacuna")),
              ],
              rows: [
                DataRow(selected: true, cells: [
                  DataCell(Text('${vacuna.fechaConsulta}')),
                  DataCell(Text('${vacuna.pesoActual}')),
                  DataCell(Text('${vacuna.fechaProximaVacuna}')),
                ]),
              ],
            ),
            DataTable(
              columns: [
                DataColumn(label: Text("Vacuna Laboratorio")),
                DataColumn(label: Text("Veterinario ")),
              ],
              rows: [
                DataRow(selected: true, cells: [
                  DataCell(Text('${vacuna.tipoVacuna}')),
                  DataCell(Text('${vacuna.veterinarioResp}')),
                ]),
              ],
            ),
            Divider(color: Colors.purple)
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
              Navigator.pop(context);
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
              Navigator.pop(context);
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
