import 'dart:async';

import 'package:aministrador_app_v1/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class PerfilUsuarioPage extends StatefulWidget {
  const PerfilUsuarioPage({Key? key}) : super(key: key);

  @override
  State<PerfilUsuarioPage> createState() => _PerfilUsuarioPageState();
}

class _PerfilUsuarioPageState extends State<PerfilUsuarioPage> {
  late String passActual;
  final formKey = GlobalKey<FormState>();
  //late String passNew;
  PreferenciasUsuario prefs = PreferenciasUsuario();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late bool _passwordVisible;
  late bool _passwordVisible1;
  late bool _passwordVisible2;
  TextEditingController passNew = new TextEditingController();
  TextEditingController passConfirm = new TextEditingController();

  @override
  initState() {
    _passwordVisible = false;
    _passwordVisible1 = false;
    _passwordVisible2 = false;
    FirebaseAuth.instance.userChanges().listen((event) {
      print(FirebaseAuth.instance.currentUser);

      print(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    String nombre = prefs.nombre.toString();
    String nombreS = nombre.split(' ')[0];
    return Scaffold(
      appBar: AppBar(
        title: Text('Restablecer contraseña'),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 20)),
            CircleAvatar(
              backgroundImage: AssetImage('assets/admin.jpg'),
              radius: 50,
              foregroundColor: Colors.black,
            ),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            Text(
              'Hola ' + nombreS,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            Center(
              child: SizedBox(
                width: 350,
                child: TextFormField(
                  obscureText: !_passwordVisible,
                  style: TextStyle(
                    fontSize: 20,
                    //color: Colors.,
                    //fontWeight: FontWeight.w600,
                  ),
                  validator: (val) {
                    if (val!.isEmpty) return 'Vacío';
                    if (val.length < 8)
                      return 'Contraseña mayor o igual a 8 caracteres.';
                    return null;
                  },
                  onChanged: (s) {
                    setState(() {
                      passActual = s;
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),

                    focusColor: Colors.white,
                    //add prefix icon
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.green,
                    labelText: 'Contraseña actual',
                    //lable style
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            Center(
              child: SizedBox(
                width: 350,
                child: TextFormField(
                  controller: passNew,
                  obscureText: !_passwordVisible1,
                  style: TextStyle(
                    fontSize: 20,
                    //color: Colors.blue,
                    //fontWeight: FontWeight.w600,
                  ),
                  validator: (val) {
                    if (val!.isEmpty) return 'Vacío';
                    if (val.length < 8)
                      return 'Contraseña mayor o igual a 8 caracteres.';
                    return null;
                  },
                  onSaved: (s) {
                    setState(() {
                      passNew = s as TextEditingController;
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible1
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible1 = !_passwordVisible1;
                        });
                      },
                    ),
                    focusColor: Colors.white,
                    //add prefix icon
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.green,
                    labelText: 'Nueva contraseña',
                    //lable style
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            Center(
              child: SizedBox(
                width: 350,
                child: TextFormField(
                  controller: passConfirm,
                  obscureText: !_passwordVisible2,
                  style: TextStyle(
                    fontSize: 20,
                    //color: Colors.blue,
                    //fontWeight: FontWeight.w600,
                  ),
                  validator: (val) {
                    if (val!.isEmpty) return 'Vacío';
                    if (val.length < 8)
                      return 'Contraseña mayor o igual a 8 caracteres.';
                    if (val != passNew.text) return 'No coincide';
                    return null;
                  },
                  onSaved: (s) {
                    setState(() {
                      passConfirm = s as TextEditingController;
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible2
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible2 = !_passwordVisible2;
                        });
                      },
                    ),
                    focusColor: Colors.white,
                    //add prefix icon
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.green, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.green,
                    labelText: 'Confirmar contraseña',
                    //lable style
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) {
                  return Colors.green;
                }),
              ),
              label: Text('Actualizar'),
              icon: Icon(Icons.update),
              autofocus: true,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _changePassword(passActual, passNew.text);
                  SnackBar(
                    content: Text('Información ingresada correctamente.'),
                  );
                  mostrarAlertaOk1(context, 'Contraseña actualizada con éxito.',
                      'login', 'Información');
                  //_changePassword(passActual, passNew.text);
                } else {
                  mostrarAlerta(context,
                      'Asegúrate de haber ingresado correctamente la contraseña.');
                }
              },
            ),
            // TextButton(
            //     onPressed: () {
            //       _changePassword(passActual, passNew);
            //     },
            //     child: Text('CAMBIAR'))
          ],
        ),
      ),
    );
  }

  Future<bool> _changePassword(
      String currentPassword, String newPassword) async {
    bool success = false;

    final cred = await _auth.signInWithEmailAndPassword(
        email: prefs.email, password: currentPassword);
    print(cred);
    await cred.user!.updatePassword(newPassword).then((_) {
      success = true;
      //usersRef.doc(uid).update({"password": newPassword});
    }).catchError((error) {
      print(error);
    });
    //}).catchError((err) {
    //  print(err);
    // });

    return success;
  }
}
