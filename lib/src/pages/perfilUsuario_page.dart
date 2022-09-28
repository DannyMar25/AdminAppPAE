import 'dart:async';

import 'package:aministrador_app_v1/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PerfilUsuarioPage extends StatefulWidget {
  const PerfilUsuarioPage({Key? key}) : super(key: key);

  @override
  State<PerfilUsuarioPage> createState() => _PerfilUsuarioPageState();
}

class _PerfilUsuarioPageState extends State<PerfilUsuarioPage> {
  late String passActual;
  late String passNew;
  PreferenciasUsuario prefs = PreferenciasUsuario();
  @override
  initState() {
    FirebaseAuth.instance.userChanges().listen((event) {
      print(FirebaseAuth.instance.currentUser);

      print(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CAMBIO DE CONTRASENA'),
      ),
      body: Column(
        children: [
          TextFormField(
            //maxLines: 6,
            //initialValue: animal.caracteristicas,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Actual',
              labelStyle: TextStyle(fontSize: 16, color: Colors.black),
            ),
            //onSaved: (s) => animal.caracteristicas = s!,
            onChanged: (s) {
              setState(() {
                passActual = s;
              });
            },
          ),
          TextFormField(
            //maxLines: 6,
            //initialValue: animal.caracteristicas,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Características',
              labelStyle: TextStyle(fontSize: 16, color: Colors.black),
            ),
            //onSaved: (s) => animal.caracteristicas = s!,
            onChanged: (s) {
              setState(() {
                passNew = s;
              });
            },
          ),
          TextButton(
              onPressed: () {
                _changePassword(passActual, passNew);
              },
              child: Text('CAMBIAR'))
        ],
      ),
    );
  }

  Future<bool> _changePassword(
      String currentPassword, String newPassword) async {
    bool success = false;

    //Create an instance of the current user.
    var user = FirebaseAuth.instance.currentUser;

    //Must re-authenticate user before updating the password. Otherwise it may fail or user get signed out.

    final cred = EmailAuthProvider.credential(
        email: prefs.email, password: currentPassword);
    await user!.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(newPassword).then((_) {
        success = true;
        //usersRef.doc(uid).update({"password": newPassword});
      }).catchError((error) {
        print(error);
      });
    }).catchError((err) {
      print(err);
    });

    return success;
  }
}
