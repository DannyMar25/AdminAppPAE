import 'dart:io';

import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SolicitudRechazadaMainPage extends StatefulWidget {
  //const SeguimientoPage({Key? key}) : super(key: key);

  @override
  State<SolicitudRechazadaMainPage> createState() =>
      _SolicitudRechazadaMainPageState();
}

class _SolicitudRechazadaMainPageState
    extends State<SolicitudRechazadaMainPage> {
  final formKey = GlobalKey<FormState>();
  FirebaseStorage storage = FirebaseStorage.instance;
  AnimalModel animal = new AnimalModel();
  File? foto;
  DatosPersonalesModel datosA = new DatosPersonalesModel();
  FormulariosModel formularios = new FormulariosModel();
  final userProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    //if (dat == arg['datosper']) {
    datosA = arg['datosper'] as DatosPersonalesModel;
    print(datosA.id);
    formularios = arg['formulario'] as FormulariosModel;
    animal = arg['animal'] as AnimalModel;
    return Scaffold(
        //backgroundColor: Color.fromARGB(223, 221, 248, 153),
        backgroundColor: Color.fromARGB(223, 245, 247, 240),
        appBar: AppBar(
          title: Text('Datos adoptante rechazado'),
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
        body: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Container(
                //color: Colors.lightGreenAccent,
                padding: new EdgeInsets.only(top: 5.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Información de la mascota',
                            style: TextStyle(
                              fontSize: 28,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = Colors.blueAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Divider(color: Colors.transparent),
                          _mostrarFoto(),
                          Divider(
                            color: Colors.transparent,
                          ),
                          Text(
                            'Observación: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                                text: formularios.observacion,
                                style: TextStyle(color: Colors.black)),
                          ),
                          Divider(),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Nombre: ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${animal.nombre}                                ',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Etapa de vida: ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${animal.etapaVida}      ',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Raza: ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${animal.raza}',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Text(
                                  'Color: ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${animal.color}               ',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Tamaño: ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${animal.tamanio}      ',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Sexo: ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${animal.sexo}',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Divider(
                            color: Colors.white,
                          ),
                          Text(
                            'Información del posible adoptante',
                            style: TextStyle(
                              fontSize: 28,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = Colors.blueAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Divider(),
                          Divider(
                            color: Colors.white,
                          ),
                          Row(
                            children: [
                              Text(
                                'Nombre: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${datosA.nombreCom}  ',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: [
                              Text(
                                'Dirección: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${datosA.direccion}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: [
                              Text(
                                'Teléfono: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${datosA.telfCel}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: [
                              Text(
                                'Correo: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${datosA.email}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                      //_crearBoton(context),
                    ],
                  ),
                ),
              ),
            )
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
        Navigator.pushNamed(context, 'login');
    }
  }

  Widget _mostrarFoto() {
    if (animal.fotoUrl != '') {
      return FadeInImage(
        image: NetworkImage(animal.fotoUrl),
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
}
