import 'dart:io';

import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_domicilio_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_relacionAnimal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_situacionFam_model.dart';
import 'package:aministrador_app_v1/src/providers/formularios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class SolicitudesMainPage extends StatefulWidget {
  const SolicitudesMainPage({Key? key}) : super(key: key);

  @override
  State<SolicitudesMainPage> createState() => _SolicitudesMainPageState();
}

class _SolicitudesMainPageState extends State<SolicitudesMainPage> {
  FormulariosProvider formulariosProvider = new FormulariosProvider();
  FormulariosModel formularios = new FormulariosModel();
  DatosPersonalesModel datosC = new DatosPersonalesModel();
  SitFamiliarModel situacionF = new SitFamiliarModel();
  DomicilioModel domicilio = new DomicilioModel();
  RelacionAnimalesModel relacionA = new RelacionAnimalesModel();
  final userProvider = new UsuarioProvider();
  File? foto;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Object? formulariosData = ModalRoute.of(context)!.settings.arguments;
    if (formulariosData != null) {
      formularios = formulariosData as FormulariosModel;
      print(formularios.id);
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(248, 234, 235, 233),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Datos de la solicitud"),
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
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/fondoanimales.jpg"),
          //     fit: BoxFit.cover,
          //   ),
          //),
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Posible adoptante para:",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Padding(padding: EdgeInsets.only(bottom: 12.0)),
                //Divider(),
                _mostrarFoto(),
                // Divider(),
                _mostrarNombreAn(),
                Divider(
                  color: Colors.transparent,
                ),

                _mostrarFecha(),
                Divider(
                  color: Colors.transparent,
                ),
                // _crearEstadoCita(),
                //Text("Cita Atendida"),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.0),
                              child: _botonDatosPer(),
                            ),
                            Text('Datos personales'),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.0),
                              child: _botonSituacionFam(),
                            ),
                            Text('Situacion familiar')
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.0),
                              child: _botonDomicilio(),
                            ),
                            Text('Domicilio')
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.0),
                              child: _botonRelacionAnim(),
                            ),
                            Text('Relacion con animales')
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                //_botonPDF(),
                Divider(
                  color: Colors.transparent,
                ),
                Padding(padding: EdgeInsets.only(bottom: 12.0)),

                _crearBotonPDF(),
                Divider(
                  color: Colors.transparent,
                ),
                Padding(padding: EdgeInsets.only(bottom: 12.0)),
                _crearBotonObservaciones()
                //_crearBoton(),

                // _crearDisponible(),
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
        Navigator.pushNamed(context, 'soporte');
        break;
      case 2:
        userProvider.signOut();
        Navigator.pushNamed(context, 'login');
    }
  }

  showCitas1() async {
    datosC = await formulariosProvider.cargarDPId(
        formularios.id, formularios.idDatosPersonales);
    //setState(() {
    return datosC;
  }

  Widget _mostrarFecha() {
    return TextFormField(
      readOnly: true,
      initialValue: formularios.fechaIngreso,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Fecha de solicitud:',
        //labelStyle: ,
        //border: BorderRadius(BorderRadius.circular(2.0)),
        icon: Icon(
          Icons.date_range_outlined,
          color: Colors.purple,
        ),
      ),
      //onSaved: (value) => animal.nombre = value!,
      //},
    );
  }

  Widget _crearNombreClient() {
    return TextFormField(
      readOnly: true,
      initialValue: formularios.nombreClient,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombre',
        //labelStyle: ,
        //border: BorderRadius(BorderRadius.circular(2.0)),
        icon: Icon(
          Icons.person,
          color: Colors.purple,
        ),
      ),
      //onSaved: (value) => animal.nombre = value!,
      //},
    );
  }

  Widget _mostrarNombreAn() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        textAlign: TextAlign.center,
        readOnly: true,
        initialValue: formularios.animal!.nombre,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: InputBorder.none,
          //labelText: 'Nombre Mascota:',
          //icon: Icon(
          //  Icons.pets,
          //  color: Colors.purple,
          // )
        ),
        //onSaved: (value) => animal.nombre = value!,
        //},
      ),
    );
  }

  Widget _mostrarFoto() {
    if (formularios.animal!.fotoUrl != '') {
      return FadeInImage(
        image: NetworkImage(formularios.animal!.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300,
        fit: BoxFit.contain,
      );
    } else {
      if (foto != null) {
        return Image.file(
          foto!,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset(foto?.path ?? 'assets/no-image.png');
    }
  }

  Widget _botonDatosPer() {
    //var idForm = formularios.id;
    //var idD = formularios.idDatosPersonales;
    //FormulariosModel form1 = formularios;
    return Ink(
        decoration: BoxDecoration(
            //backgroundBlendMode: ,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.purple[600],
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: Icon(
            Icons.person,
          ),
          iconSize: 100,
          color: Colors.purple[300],
          onPressed: () async {
            // Navigator.pushNamed(context, 'datosPersonales',
            //     arguments: [idForm, idD]);
            datosC = await formulariosProvider.cargarDPId(
                formularios.id, formularios.idDatosPersonales);
            situacionF = await formulariosProvider.cargarSFId(
                formularios.id, formularios.idSituacionFam);
            domicilio = await formulariosProvider.cargarDomId(
                formularios.id, formularios.idDomicilio);
            relacionA = await formulariosProvider.cargarRAId(
                formularios.id, formularios.idRelacionAn);
            Navigator.pushNamed(context, 'datosPersonales', arguments: {
              'datosper': datosC,
              'sitfam': situacionF,
              'domicilio': domicilio,
              'formulario': formularios,
              'relacionAn': relacionA
            });
          },
        ));
  }

  Widget _botonSituacionFam() {
    return Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Color.fromARGB(255, 92, 216, 97),
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: Icon(
            Icons.people,
          ),
          iconSize: 100,
          color: Colors.orange[300],
          onPressed: () async {
            situacionF = await formulariosProvider.cargarSFId(
                formularios.id, formularios.idSituacionFam);
            domicilio = await formulariosProvider.cargarDomId(
                formularios.id, formularios.idDomicilio);
            relacionA = await formulariosProvider.cargarRAId(
                formularios.id, formularios.idRelacionAn);

            Navigator.pushNamed(context, 'situacionFam', arguments: {
              'datosper': datosC,
              'situacionF': situacionF,
              'domicilio': domicilio,
              'relacionAn': relacionA,
              'formulario': formularios
            });
          },
        ));
  }

  Widget _botonDomicilio() {
    return Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.blueGrey[200],
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: Icon(
            Icons.house,
          ),
          iconSize: 100,
          color: Colors.blueGrey[700],
          onPressed: () async {
            domicilio = await formulariosProvider.cargarDomId(
                formularios.id, formularios.idDomicilio);
            relacionA = await formulariosProvider.cargarRAId(
                formularios.id, formularios.idRelacionAn);

            Navigator.pushNamed(context, 'domicilio', arguments: {
              'domicilio': domicilio,
              'relacionAn': relacionA,
              'formulario': formularios
            });
          },
        ));
  }

  Widget _botonRelacionAnim() {
    return Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.lightBlue[300],
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: Icon(
            Icons.pets,
          ),
          iconSize: 100,
          color: Colors.blueAccent,
          onPressed: () async {
            relacionA = await formulariosProvider.cargarRAId(
                formularios.id, formularios.idRelacionAn);

            Navigator.pushNamed(context, 'relacionAnim', arguments: {
              'relacionAn': relacionA,
              'formulario': formularios
            });
          },
        ));
  }

  Widget _botonPDF() {
    return Ink(
        decoration: BoxDecoration(
            //backgroundBlendMode: ,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.purple[600],
            boxShadow: [
              BoxShadow(
                  color: Colors.purple,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: Icon(
            Icons.picture_as_pdf,
          ),
          iconSize: 100,
          color: Colors.purple[300],
          onPressed: () async {
            // Navigator.pushNamed(context, 'datosPersonales',
            //     arguments: [idForm, idD]);
            datosC = await formulariosProvider.cargarDPId(
                formularios.id, formularios.idDatosPersonales);
            situacionF = await formulariosProvider.cargarSFId(
                formularios.id, formularios.idSituacionFam);
            domicilio = await formulariosProvider.cargarDomId(
                formularios.id, formularios.idDomicilio);
            relacionA = await formulariosProvider.cargarRAId(
                formularios.id, formularios.idRelacionAn);
            Navigator.pushNamed(context, 'crearPDF', arguments: {
              'datosper': datosC,
              'sitfam': situacionF,
              'domicilio': domicilio,
              'formulario': formularios,
              'relacionAn': relacionA
            });
          },
        ));
  }

  Widget _crearBotonPDF() {
    return ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            return Colors.green;
          }),
        ),
        label: Text(
          'Generar PDF',
          style: TextStyle(fontSize: 17),
        ),
        icon: Icon(
          Icons.picture_as_pdf,
          size: 40,
        ),
        autofocus: true,
        onPressed: () async {
          datosC = await formulariosProvider.cargarDPId(
              formularios.id, formularios.idDatosPersonales);
          situacionF = await formulariosProvider.cargarSFId(
              formularios.id, formularios.idSituacionFam);
          domicilio = await formulariosProvider.cargarDomId(
              formularios.id, formularios.idDomicilio);
          relacionA = await formulariosProvider.cargarRAId(
              formularios.id, formularios.idRelacionAn);
          Navigator.pushNamed(context, 'crearPDF', arguments: {
            'datosper': datosC,
            'sitfam': situacionF,
            'domicilio': domicilio,
            'formulario': formularios,
            'relacionAn': relacionA
          });
        });
  }

  Widget _crearBotonObservaciones() {
    return ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            return Colors.green;
          }),
        ),
        label: Text(
          'Respuesta y observaciones',
          style: TextStyle(fontSize: 17),
        ),
        icon: Icon(
          Icons.question_answer,
          size: 40,
        ),
        autofocus: true,
        onPressed: () async {
          // datosC = await formulariosProvider.cargarDPId(
          //     formularios.id, formularios.idDatosPersonales);
          // situacionF = await formulariosProvider.cargarSFId(
          //     formularios.id, formularios.idSituacionFam);
          // domicilio = await formulariosProvider.cargarDomId(
          //     formularios.id, formularios.idDomicilio);
          // relacionA = await formulariosProvider.cargarRAId(
          //     formularios.id, formularios.idRelacionAn);
          Navigator.pushNamed(context, 'observacionSolicitud',
              arguments: formularios
              //'datosper': datosC,
              // 'sitfam': situacionF,
              //'domicilio': domicilio,
              //'formulario': formularios,
              //'relacionAn': relacionA
              );
        });
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            return Colors.deepPurple;
          }),
        ),
        label: Text('Guardar'),
        icon: Icon(Icons.save),
        autofocus: true,
        onPressed: () {
          Navigator.pushNamed(context, 'bienvenida');
        }
        // onPressed: () {
        //   print(animal.id);
        // },
        );
  }
}
