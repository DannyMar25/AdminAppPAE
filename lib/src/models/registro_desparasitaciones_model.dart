// To parse this JSON data, do
//
//     final registroDesparasitacionModel = registroDesparasitacionModelFromJson(jsonString);

import 'dart:convert';

RegistroDesparasitacionModel registroDesparasitacionModelFromJson(String str) =>
    RegistroDesparasitacionModel.fromJson(json.decode(str));

String registroDesparasitacionModelToJson(RegistroDesparasitacionModel data) =>
    json.encode(data.toJson());

class RegistroDesparasitacionModel {
  RegistroDesparasitacionModel({
    this.id = '',
    this.fecha = '',
    this.nombreProducto = '',
    this.pesoActual = 2.2,
    this.fechaProxDesparasitacion = '',
  });

  String id;
  String fecha;
  String nombreProducto;
  double pesoActual;
  String fechaProxDesparasitacion;

  factory RegistroDesparasitacionModel.fromJson(Map<String, dynamic> json) =>
      RegistroDesparasitacionModel(
        id: json["id"],
        fecha: json["fecha"],
        nombreProducto: json["nombreProducto"],
        pesoActual: json["pesoActual"].toDouble(),
        fechaProxDesparasitacion: json["fechaProxDesparasitacion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fecha": fecha,
        "nombreProducto": nombreProducto,
        "pesoActual": pesoActual,
        "fechaProxDesparasitacion": fechaProxDesparasitacion,
      };
}
