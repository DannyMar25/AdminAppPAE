import 'dart:io';

import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SolicitudAprobadaMainPage extends StatefulWidget {
  //const SeguimientoPage({Key? key}) : super(key: key);

  @override
  State<SolicitudAprobadaMainPage> createState() =>
      _SolicitudAprobadaMainPageState();
}

class _SolicitudAprobadaMainPageState extends State<SolicitudAprobadaMainPage> {
  final formKey = GlobalKey<FormState>();
  FirebaseStorage storage = FirebaseStorage.instance;
  AnimalModel animal = new AnimalModel();
  File? foto;
  DatosPersonalesModel datosA = new DatosPersonalesModel();
  FormulariosModel formularios = new FormulariosModel();

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    //if (dat == arg['datosper']) {
    datosA = arg['datosper'] as DatosPersonalesModel;
    print(datosA.id);
    formularios = arg['formulario'] as FormulariosModel;
    animal = arg['animal'] as AnimalModel;
    return Scaffold(
        backgroundColor: Color.fromARGB(223, 221, 248, 153),
        appBar: AppBar(
          title: Text('Datos de mascota adoptada'),
          backgroundColor: Colors.green,
        ),
        drawer: MenuWidget(),
        body: Stack(
          alignment: Alignment.center,
          children: [
            //Background(),
            //_verGaleria(context),
            //Text('Hola'),
            SingleChildScrollView(
              child: Container(
                //color: Colors.lightGreenAccent,
                //padding: new EdgeInsets.only(top: 230.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Informacion de la mascota adoptada',
                            style: TextStyle(
                              fontSize: 28,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = Colors.blueAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Divider(
                            color: Colors.transparent,
                          ),
                          _mostrarFoto(),
                          Divider(
                            color: Colors.white,
                          ),
                          Row(
                            children: [
                              Text(
                                'Nombre: ',
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                '${animal.nombre}                                ',
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                'Edad: ',
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                '${animal.edad}      ',
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                'Raza: ',
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                '${animal.raza}',
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.transparent,
                          ),
                          Row(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Color: ',
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                '${animal.color}               ',
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                'Tamaño: ',
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                '${animal.tamanio}      ',
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                'Sexo: ',
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                '${animal.sexo}',
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Divider(),
                          Divider(
                            color: Colors.white,
                          ),
                          Text(
                            'Informacion del adoptante',
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
                                'Direccion: ',
                                textAlign: TextAlign.center,
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
                                'Telefono: ',
                                textAlign: TextAlign.center,
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
