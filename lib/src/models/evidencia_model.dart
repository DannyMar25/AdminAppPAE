// To parse this JSON data, do
//
//     final evidenciasModel = evidenciasModelFromJson(jsonString);

import 'dart:convert';

EvidenciasModel evidenciasModelFromJson(String str) =>
    EvidenciasModel.fromJson(json.decode(str));

String evidenciasModelToJson(EvidenciasModel data) =>
    json.encode(data.toJson());

class EvidenciasModel {
  EvidenciasModel({
    this.id = '',
    this.fecha = '',
    this.fotoUrl = '',
    this.archivoUrl = '',
    this.nombreArchivo = '',
  });

  String id;
  String fecha;
  String fotoUrl;
  String archivoUrl;
  String nombreArchivo;

  factory EvidenciasModel.fromJson(Map<String, dynamic> json) =>
      EvidenciasModel(
        id: json["id"],
        fecha: json["fecha"],
        fotoUrl: json["fotoUrl"],
        archivoUrl: json["archivoUrl"],
        nombreArchivo: json["nombreArchivo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fecha": fecha,
        "fotoUrl": fotoUrl,
        "archivoUrl": archivoUrl,
        "nombreArchivo": nombreArchivo,
      };
}
