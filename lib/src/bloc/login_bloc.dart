import 'dart:async';

//import 'package:flutter/foundation.dart';
import 'package:aministrador_app_v1/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _usNameController = BehaviorSubject<String>();
  final _cedulaController = BehaviorSubject<String>();
  //nuevo
  final _passwordConfirmController = BehaviorSubject<String>();

  //_emailController.value

  //Recuperar los datos del stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);
  Stream<String> get nameStream =>
      _usNameController.stream.transform(validarNombre);
  Stream<String> get cedulaStream =>
      _cedulaController.stream.transform(validarCedula);

  //nuevo

  Stream<String> get passwordConfirmStream => _passwordConfirmController.stream
          .transform(validarPassword)
          .doOnData((String? c) {
        if (0 != _passwordController.value.compareTo(c!)) {
          _passwordConfirmController.addError("Contraseñas no coinciden.");
        }
      });

  Stream<bool> get formValidStream => Rx.combineLatest3(
      emailStream, passwordStream, nameStream, (e, p, n) => true);
  Stream<bool> get formValidStreamL =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  Stream<bool> get formValidStream1 => Rx.combineLatest4(emailStream,
      passwordStream, nameStream, passwordConfirmStream, (e, p, n, s) => true);
  Stream<bool> get formValidStream5 => Rx.combineLatest5(
      emailStream,
      passwordStream,
      nameStream,
      passwordConfirmStream,
      cedulaStream,
      (e, p, n, s, c) => true);

  //Insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeName => _usNameController.sink.add;
  Function(String) get changePasswordConfirm =>
      _passwordConfirmController.sink.add;
  Function(String) get changeCedula => _cedulaController.sink.add;

  //Obtener el ultimo valor ingresado a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;
  String get name => _usNameController.value;
  String get passwordConfirm => _passwordController.value;
  String get cedula => _cedulaController.value;

  dispose() {
    _emailController.close();
    _passwordController.close();
    _usNameController.close();
    _passwordConfirmController.close();
    _cedulaController.close();
  }
}
