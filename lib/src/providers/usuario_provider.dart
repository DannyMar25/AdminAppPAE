import 'dart:convert';

//import 'package:firebase_core/firebase_core.dart';
import 'package:aministrador_app_v1/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  final String _firebaseToken = 'AIzaSyCKF3vYr8Kn-6RQTrhiqc1IcEp1bC8HfWU';
  final _prefs = new PreferenciasUsuario();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
        Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken'),
        body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    //print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];

      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password, String name) async {
    final authData = {
      'email': email,
      'password': password,
      'displayName': name,
      'returnSecureToken': true
    };

    final resp = await http.post(
        Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken'),
        body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    //print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }
//final FirebaseAuth _auth = FirebaseAuth.instance;

//register with email & password & save username instantly
  Future registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      user!.updateDisplayName(name); //added this line
      //return _user(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  // Future createUserWithEmailAndPassword(
  //     String email, String password, String name) async {
  //   try {
  //     UserCredential userCredential = await _auth
  //         .createUserWithEmailAndPassword(email: email, password: password);

  //     userCredential.user!.updateDisplayName(name).then((_) {
  //       //print(userCredential.user.displayName);
  //       User? user = userCredential.user;
  //       db.setProfileonRegistration(user!.uid, name);
  //       return _userFromFireBase(userCredential.user);
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       print('The password provided is too weak.');
  //       return null;
  //     } else if (e.code == 'email-already-in-use') {
  //       print('The account already exists for that email.');
  //       return null;
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  //cerrar sesion
  void signOut() async {
    await _auth.signOut();
    return;
  }
}
