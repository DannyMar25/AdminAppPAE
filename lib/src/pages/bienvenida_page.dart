import 'package:aministrador_app_v1/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:aministrador_app_v1/src/providers/animales_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BienvenidaPage extends StatelessWidget {
  //const HomePage({Key? key}) : super(key: key);

  //static final String routeName = 'home';
  final prefs = new PreferenciasUsuario();
  //late AnimalesProvider animal = new AnimalesProvider();
  //final databaseRef = FirebaseDatabase._instance_.reference();

  void setGPS(int getData, String id) {
    //ProductoModel producto;
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    DatabaseReference prodRef = ref.child("gps");
    DatabaseReference urlRef = prodRef.child("Test");
    urlRef.update({"GetDataGPS": getData, "id": id});
  }

  @override
  Widget build(BuildContext context) {
    //prefs.ultimaPagina = HomePage.routeName;
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferencias de usuario'),
        //backgroundColor: (prefs.colorSecundario) ? Colors.teal : Colors.blue,
      ),
      drawer: MenuWidget(),
      body: Center(
        child: Text('BIENVENID@'),
      ),
      floatingActionButton: _crearBoton(context),
    );
  }

  _crearBoton(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return Colors.deepPurple;
        }),
      ),
      label: Text('Activar ubicacion'),
      icon: Icon(Icons.save),
      autofocus: true,
      onPressed: () => setGPS(1, "65iRhtvZxeKT9DUb8aUu"),
    );
  }
}
