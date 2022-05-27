import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/providers/animales_provider.dart';
import 'package:aministrador_app_v1/src/providers/formularios_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SolicitudesRechazadasPage extends StatefulWidget {
  const SolicitudesRechazadasPage({Key? key}) : super(key: key);

  @override
  State<SolicitudesRechazadasPage> createState() =>
      _SolicitudesRechazadasPageState();
}

class _SolicitudesRechazadasPageState extends State<SolicitudesRechazadasPage> {
  final formKey = GlobalKey<FormState>();
  FormulariosProvider formulariosProvider = new FormulariosProvider();
  AnimalesProvider animalesProvider = new AnimalesProvider();

  //List<Future<FormulariosModel>> formulario = [];
  List<FormulariosModel> formularios = [];
  List<Future<FormulariosModel>> listaF = [];
  FirebaseStorage storage = FirebaseStorage.instance;
  AnimalModel animal = new AnimalModel();
  DatosPersonalesModel datosC = new DatosPersonalesModel();

  @override
  void initState() {
    super.initState();
    showCitas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(223, 221, 248, 153),
      appBar: AppBar(
        title: Text('SOLICITUDES RECHAZADAS'),
        backgroundColor: Colors.green,
      ),
      drawer: MenuWidget(),
      body: SingleChildScrollView(
        child: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/fondoanimales.jpg"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   "SOLICITUDES RECHAZADAS",
                //   style: const TextStyle(
                //       fontWeight: FontWeight.bold, fontSize: 20),
                // ),
                Padding(padding: EdgeInsets.only(bottom: 12.0)),
                _verListado()
              ],
            ),
          ),
        ),
      ),
    );
  }

  showCitas() async {
    listaF = await formulariosProvider.cargarInfoR();
    for (var yy in listaF) {
      FormulariosModel form = await yy;
      setState(() {
        formularios.add(form);
      });
    }
  }

  Widget _verListado() {
    return Column(
      children: [
        SizedBox(
          height: 800,
          child: ListView.builder(
            itemCount: formularios.length,
            itemBuilder: (context, i) => _crearItem(context, formularios[i]),
          ),
        ),
      ],
    );
  }

  Widget _crearItem(BuildContext context, FormulariosModel formulario) {
    return ListTile(
      title: Column(
        children: [
          //Divider(color: Colors.purple),
          Card(
            child: Container(
              height: 100,
              color: Colors.white,
              child: Row(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Expanded(
                        child: Image.asset("assets/pet.jpg"),
                        flex: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: ListTile(
                              title: Text('${formulario.animal!.nombre}'),
                              subtitle: Text(
                                  "Adoptante: " + '${formulario.nombreClient}'),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: Text("VER INFO"),
                                  onPressed: () async {
                                    datosC =
                                        await formulariosProvider.cargarDPId(
                                            formulario.id,
                                            formulario.idDatosPersonales);
                                    animal = await animalesProvider
                                        .cargarAnimalId(formulario.idAnimal);

                                    Navigator.pushReplacementNamed(
                                        context, 'verSolicitudRechazada',
                                        arguments: {
                                          'datosper': datosC,
                                          'formulario': formulario,
                                          'animal': animal
                                        });
                                  },
                                ),
                                SizedBox(
                                  width: 8,
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
