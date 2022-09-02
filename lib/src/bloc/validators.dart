import 'dart:async';

class Validators {
  final validarEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern.toString());
    if (regExp.hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('Correo no es correcto');
    }
  });

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 8) {
      sink.add(password);
    } else {
      sink.addError('Más de 8 caracteres por favor');
    }
  });

  //se anade otro validator para confirmar contrasena
  final validarPasswordN = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 8) {
      sink.add(password);
    } else {
      sink.addError('Más de 8 caracteres por favor');
    }
  });

  //nuevo

  final validarNombre = StreamTransformer<String, String>.fromHandlers(
      handleData: (nombre, sink) {
    if (nombre.length >= 5) {
      sink.add(nombre);
    } else {
      sink.addError('Más de 5 caracteres por favor');
    }
  });
}
