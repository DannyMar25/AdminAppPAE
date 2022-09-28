import 'dart:io';

import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_domicilio_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_relacionAnimal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_situacionFam_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/providers/animales_provider.dart';
import 'package:aministrador_app_v1/src/providers/formularios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/utils/utils.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class ObservacionFinalPage extends StatefulWidget {
  const ObservacionFinalPage({Key? key}) : super(key: key);

  @override
  State<ObservacionFinalPage> createState() => _ObservacionFinalPageState();
}

class _ObservacionFinalPageState extends State<ObservacionFinalPage> {
  FormulariosProvider formulariosProvider = new FormulariosProvider();
  FormulariosModel formularios = new FormulariosModel();
  DatosPersonalesModel datosC = new DatosPersonalesModel();
  SitFamiliarModel situacionF = new SitFamiliarModel();
  DomicilioModel domicilio = new DomicilioModel();
  RelacionAnimalesModel relacionA = new RelacionAnimalesModel();
  final userProvider = new UsuarioProvider();
  final animalProvider = new AnimalesProvider();
  File? foto;
  final formKey = GlobalKey<FormState>();
  bool isChecked = false;
  bool isChecked1 = false;
  String estado = '';
  String estadoAn = '';
  String fechaRespuesta = '';
  String observacion = '';
  //bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    final Object? formulariosData = ModalRoute.of(context)!.settings.arguments;
    if (formulariosData != null) {
      formularios = formulariosData as FormulariosModel;
      print(formularios.id);
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(223, 248, 248, 245),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Respuesta y observaciones"),
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
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/fondoanimales.jpg"),
          //     fit: BoxFit.cover,
          //   ),
          //),
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              _mostrarEstado(),
              Divider(),
              Text(
                'Cambiar estado de la solicitud revisada.',
                style: TextStyle(
                  fontSize: 18,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2
                    ..color = Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(
                  children: [Text('Aprobado'), _crearCheckBox1()],
                ),
                Row(
                  children: [Text('Negado'), _crearCheckBox2()],
                ),
              ]),
              Padding(padding: EdgeInsets.only(bottom: 15.0)),
              _crearObservacion(),
              Padding(padding: EdgeInsets.only(bottom: 30.0)),
              _crearFechaResp(),
              Padding(padding: EdgeInsets.only(bottom: 15.0)),
              _crearBoton(),
              Padding(padding: EdgeInsets.only(bottom: 515.0)),
            ]),
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

  Widget _crearObservacion() {
    return TextFormField(
        maxLines: 4,
        readOnly: false,
        //initialValue: formularios.observacion,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Observaciones:',
          //labelStyle: ,
          //border: BorderRadius(BorderRadius.circular(2.0)),
          icon: Icon(
            Icons.edit_outlined,
            color: Colors.green,
          ),
        ),
        validator: (value) {
          if (value!.length < 3 && value.length > 0) {
            return 'Ingrese observación';
          } else if (value.isEmpty) {
            return 'Llena este campo por favor';
          } else {
            return null;
          }
        },
        onChanged: (s) {
          setState(() {
            //formularios.observacion = s;
            observacion = s;
          });
        });
  }

  Widget _crearFechaResp() {
    return TextFormField(
        maxLines: 1,
        readOnly: false,
        initialValue: DateTime.now().toString(),
        // initialValue: DateTime.now().year.toString() +
        //     '-' +
        //     DateTime.now().month.toString() +
        //     '-' +
        //     DateTime.now().day.toString(),
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: 'Fecha de respuesta:',
          //labelStyle: ,
          //border: BorderRadius(BorderRadius.circular(2.0)),
          icon: Icon(
            Icons.date_range_outlined,
            color: Colors.green,
          ),
        ),
        onChanged: (s) {
          setState(() {
            fechaRespuesta = s;
          });
        });
  }

  Widget _mostrarEstado() {
    return TextFormField(
      readOnly: true,
      initialValue: formularios.estado,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Estado de la solicitud:',
        //labelStyle: ,
        //border: BorderRadius(BorderRadius.circular(2.0)),
        icon: Icon(
          Icons.info,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _crearCheckBox1() {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blueGrey;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        if (isChecked1 == true) {
          return null;
        } else {
          setState(() {
            isChecked = value!;
            //domicilio.planMudanza = "Si";
            estado = "Aprobado";
            estadoAn = "Adoptado";
            animalProvider.editarEstado(formularios.animal!, estadoAn);
          });
        }
      },
    );
  }

  Widget _crearCheckBox2() {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blueGrey;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked1,
      onChanged: (bool? value) {
        if (isChecked == true) {
          return null;
        } else {
          setState(() {
            isChecked1 = value!;
            estado = "Negado";
            estadoAn = "En Adopción";
            animalProvider.editarEstado(formularios.animal!, estadoAn);
          });
        }
      },
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return Colors.green;
        }),
      ),
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      autofocus: true,
      //onPressed: (_guardando) ? null : _submit,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          if (isChecked == false && isChecked1 == false) {
            mostrarAlerta(context,
                'Debe seleccionar una de las opciones de Aprobado o Negado.');
          } else {
            SnackBar(
              content: Text('Información ingresada correctamente.'),
            );

            _submit();
            mostrarAlertaOk(
                context, 'Información actualizada con éxito.', 'solicitudes');
          }
          SnackBar(
            content: Text('Información ingresada correctamente.'),
          );
        } else {
          mostrarAlerta(
              context, 'Asegúrate de que todos los campos estén llenos.');
        }
      },
    );
  }

  void _submit() async {
    var fechaResp = DateTime.now().year.toString() +
        '-' +
        DateTime.now().month.toString() +
        '-' +
        DateTime.now().day.toString();
    formulariosProvider.editarEstado(formularios, estado);
    formulariosProvider.editarObservacion(formularios, observacion);
    formulariosProvider.editarFechaRespuesta(formularios, fechaResp);
    //Navigator.pushNamed(context, 'solicitudes');
  }
}
