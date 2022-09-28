import 'dart:io';

import 'package:aministrador_app_v1/src/models/citas_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/providers/citas_provider.dart';
import 'package:aministrador_app_v1/src/providers/horarios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class VerCitasRegistradas extends StatefulWidget {
  //const VerCitasAtendidas({Key? key}) : super(key: key);

  @override
  _VerCitasRegistradasState createState() => _VerCitasRegistradasState();
}

class _VerCitasRegistradasState extends State<VerCitasRegistradas> {
  CitasModel citas = new CitasModel();

  final citasProvider = new CitasProvider();
  final horariosProvider = new HorariosProvider();
  final userProvider = new UsuarioProvider();
  File? foto;
  final formKey = GlobalKey<FormState>();
  bool _checkbox = false;

  @override
  Widget build(BuildContext context) {
    final Object? citasData = ModalRoute.of(context)!.settings.arguments;
    if (citasData != null) {
      citas = citasData as CitasModel;
      print(citas.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Datos de la cita"),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _crearNombreClient(),
                _crearTelfClient(),
                Divider(),
                Text(
                  "Posible adoptante para:",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Divider(),
                _mostrarFoto(),
                // Divider(),
                _mostrarNombreAn(),
                Divider(),
                _crearEstadoCita(),
                Text("Cita Atendida"),
                _crearBoton(),

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

  Widget _crearNombreClient() {
    return TextFormField(
      readOnly: true,
      initialValue: citas.nombreClient,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombre',
        //labelStyle: ,
        //border: BorderRadius(BorderRadius.circular(2.0)),
        icon: Icon(
          Icons.person,
          color: Colors.green,
        ),
      ),
      //onSaved: (value) => animal.nombre = value!,
      //},
    );
  }

  Widget _crearTelfClient() {
    return TextFormField(
      readOnly: true,
      initialValue: citas.telfClient,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Teléfono',
          icon: Icon(
            Icons.call,
            color: Colors.green,
          )),
      //onSaved: (value) => animal.nombre = value!,
      //},
    );
  }

  Widget _mostrarNombreAn() {
    return TextFormField(
      readOnly: true,
      initialValue: citas.animal!.nombre,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Nombre',
          icon: Icon(
            Icons.pets,
            color: Colors.green,
          )),
      //onSaved: (value) => animal.nombre = value!,
      //},
    );
  }

  Widget _mostrarFoto() {
    if (citas.animal!.fotoUrl != '') {
      return FadeInImage(
        image: NetworkImage(citas.animal!.fotoUrl),
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

  Widget _crearEstadoCita() {
    return Checkbox(
      value: _checkbox,
      onChanged: (value) {
        setState(() {
          _checkbox = !_checkbox;
          if (_checkbox == true) {
            citasProvider.editarEstadoCita(citas);
          }
        });
      },
    );
    //Text('I am true now');
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
        onPressed: () {
          horariosProvider.editarDisponibleCita(citas.horario!);
          Navigator.pushNamed(context, 'bienvenida');
        }
        // onPressed: () {
        //   print(animal.id);
        // },
        );
  }
}
