import 'dart:async';

import 'package:flutter/material.dart';

bool cedulaCorrecta = false;

class Validators {
  final validarEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern.toString());
    if (regExp.hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('Correo no es correcto.');
    }
  });

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 8) {
      sink.add(password);
    } else {
      sink.addError('Contraseña mayor o igual a 8 caracteres.');
    }
  });

  //se anade otro validator para confirmar contrasena
  final validarPasswordN = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 8) {
      sink.add(password);
    } else {
      sink.addError('Contraseña mayor o igual a 8 caracteres.');
    }
  });

  //nuevo

  final validarNombre = StreamTransformer<String, String>.fromHandlers(
      handleData: (nombre, sink) {
    if (nombre.length >= 5) {
      sink.add(nombre);
    } else {
      sink.addError('Más de 5 caracteres por favor.');
    }
  });

  final validarCedula = StreamTransformer<String, String>.fromHandlers(
      handleData: (cedula, sink) {
    if (cedula.length == 10) {
      //sink.add(cedula);
      int tercerDigito = int.parse(cedula.substring(2, 3));
      if (tercerDigito < 6) {
        List<int> coefValCedula = [2, 1, 2, 1, 2, 1, 2, 1, 2];
        int verificador = int.parse(cedula.substring(9, 10));
        int suma = 0;
        int digito = 0;
        for (int i = 0; i < (cedula.length - 1); i++) {
          digito = int.parse(cedula.substring(i, i + 1)) * coefValCedula[i];
          suma += ((digito % 10) + (digito / 10)).toInt();
        }
        if ((suma % 10 == 0) && (suma % 10 == verificador)) {
          cedulaCorrecta = true;
          //print('La cedula es correcta');
          print('La cédula:' + cedula + ' es correcta');
          SnackBar(
            content: Text('Información ingresada correctamente'),
          );
          sink.add(cedula);
        } else if ((10 - (suma % 10)) == verificador) {
          cedulaCorrecta = true;
          //print('La cedula es correcta');
          print('La cédula:' + cedula + ' es correcta');
          SnackBar(
            content: Text('Información ingresada correctamente'),
          );
          sink.add(cedula);
        } else {
          cedulaCorrecta = false;
          //print('La cedula es incorrecta');
          sink.addError('El número de cédula es incorrecto');
          print('la cédula:' + cedula + ' es incorrecta');
        }
      } else {
        cedulaCorrecta = false;

        print('la cédula:' + cedula + ' es incorrecta');
        //print('La cedula es incorrecta');
      }
    } else {
      cedulaCorrecta = false;
      sink.addError('El número de cédula es incorrecto');
      print('la cédula:' + cedula + ' es incorrecta');
      //print('La cedula es incorrecta');
    }
    if (!cedulaCorrecta) {
      //print("La Cédula ingresada es Incorrecta");
      sink.addError('El número de cédula es incorrecto.');
      print('la cédula:' + cedula + ' es incorrecta');
    }
  });
}
