import 'dart:convert';

//import 'package:firebase_core/firebase_core.dart';
import 'package:aministrador_app_v1/src/models/usuarios_model.dart';
import 'package:aministrador_app_v1/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  final String _firebaseToken = 'AIzaSyCKF3vYr8Kn-6RQTrhiqc1IcEp1bC8HfWU';
  final _prefs = new PreferenciasUsuario();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference refUser =
      FirebaseFirestore.instance.collection('usuarios');

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

      return {
        'ok': true,
        'token': decodedResp['idToken'],
        'uid': decodedResp['localId']
      };
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
    print(decodedResp['localId']);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return {
        'ok': true,
        'token': decodedResp['idToken'],
        'uid': decodedResp['localId']
      };
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

  Future<bool> crearUsuario(
    UsuariosModel usuario,
  ) async {
    try {
      // print("este esadkjljdkjadkjskadjlkjsdljasdljasdj");
      await refUser.doc(usuario.id).set(usuario.toJson());
      //await refUser.doc(usuariosAdd.id).update({"idUs": usuariosAdd.id});
      return true;
    } catch (e) {
      return false;
    }
  }

  //cerrar sesion
  void signOut() async {
    _prefs.removeEmail();
    await _auth.signOut();
    return;
  }

  Future<dynamic> obtenerUsuario(String uid) async {
    try {
      final user = await refUser.doc(uid).get();
      return user.data() as dynamic;
    } catch (e) {
      return false;
    }
  }

  Future<List<Future<UsuariosModel>>> verificar(String correo) async {
    var documents = await refUser.where('email', isEqualTo: correo).get();
    //citas.addAll
    var s = (documents.docs.map((e) async {
      //var data = e.data() as Map<String, dynamic>;
      var user = UsuariosModel.fromJson({
        "id": e.id,
        "email": e["email"],
        "nombre": e["nombre"],
        "rol": e["rol"],
      });
      return user;
    }));
    return s.toList();
  }
}
