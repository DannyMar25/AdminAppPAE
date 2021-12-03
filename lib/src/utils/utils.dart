import 'package:flutter/material.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Informacion incorrecta'),
          content: Text(mensaje),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      });
}

void mostrarAlertaOk(BuildContext context, String mensaje, String ruta) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Informacion correcta'),
          content: Text(mensaje),
          actions: [
            TextButton(
                child: Text('Ok'),
                //onPressed: () => Navigator.of(context).pop(),
                onPressed: () => Navigator.pushNamed(context, ruta)),
          ],
        );
      });
}

void mostrarAlertaBorrar(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Esta seguro de borrar el registro'),
          content: Text(mensaje),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {},
            ),
          ],
        );
      });
}
