// To parse this JSON data, do
//
//     final soportesModel = soportesModelFromJson(jsonString);

import 'dart:convert';

SoportesModel soportesModelFromJson(String str) =>
    SoportesModel.fromJson(json.decode(str));

String soportesModelToJson(SoportesModel data) => json.encode(data.toJson());

class SoportesModel {
  SoportesModel({
    this.id = '',
    this.nombre = '',
    this.correo = '',
    this.asunto = '',
    this.mensaje = '',
  });

  String id;
  String nombre;
  String correo;
  String asunto;
  String mensaje;

  factory SoportesModel.fromJson(Map<String, dynamic> json) => SoportesModel(
        id: json["id"],
        nombre: json["nombre"],
        correo: json["correo"],
        asunto: json["asunto"],
        mensaje: json["mensaje"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "correo": correo,
        "asunto": asunto,
        "mensaje": mensaje,
      };
}
