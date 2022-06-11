import 'package:aministrador_app_v1/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BienvenidaPage extends StatelessWidget {
  //const HomePage({Key? key}) : super(key: key);

  //static final String routeName = 'home';
  final userProvider = new UsuarioProvider();
  final prefs = new PreferenciasUsuario();
  //late AnimalesProvider animal = new AnimalesProvider();
  //final databaseRef = FirebaseDatabase._instance_.reference();

  void setGPS(int getData, String id) {
    //ProductoModel producto;
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseReference prodRef = ref.child("gps");
    DatabaseReference urlRef = prodRef.child("Test");
    urlRef.update({"GetDataGPS": getData, "id": id});
  }

  @override
  Widget build(BuildContext context) {
    //prefs.ultimaPagina = HomePage.routeName;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagina principal'),
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
          // Builder(builder: (BuildContext context) {
          //   return TextButton(
          //     style: ButtonStyle(
          //       foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          //     ),
          //     onPressed: () async {
          //       userProvider.signOut();
          //       Navigator.pushNamed(context, 'login');
          //     },
          //     child: Text('Sign Out'),
          //   );
          // }),
        ],
        //backgroundColor: (prefs.colorSecundario) ? Colors.teal : Colors.blue,
      ),
      drawer: MenuWidget(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bienvenida.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            //Text(udn.toString()),
            // _verUsuario(),
            Divider(
              color: Colors.transparent,
            ),
            Divider(
              color: Colors.transparent,
            ),
            Center(
              child: Text(
                'BIENVENID@',
                style: TextStyle(
                  fontSize: 33,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4
                    ..color = Color.fromARGB(204, 160, 236, 61),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      //floatingActionButton: _crearBoton(context),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        //Navigator.pushReplacementNamed(context, 'perfilUser');
        break;
      case 1:
        Navigator.pushNamed(context, 'soporte');
        break;
      case 2:
        userProvider.signOut();
        Navigator.pushNamed(context, 'login');
    }
  }

  _verUsuario() {
    //FirebaseAuth.instance.currentUser;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    print('displayName: $user.displayName');
    //var user = FirebaseAuth.instance.currentUser;
    //print(user!.displayName);
    var nom = user!.displayName;

    return Text(nom.toString());
  }

  // _crearBoton(BuildContext context) {
  //   return ElevatedButton.icon(
  //     style: ButtonStyle(
  //       backgroundColor:
  //           MaterialStateProperty.resolveWith((Set<MaterialState> states) {
  //         return Colors.green;
  //       }),
  //     ),
  //     label: Text('Activar ubicacion'),
  //     icon: Icon(Icons.save),
  //     autofocus: true,
  //     onPressed: () => setGPS(1, "65iRhtvZxeKT9DUb8aUu"),
  //   );
  // }
}
