// To parse this JSON data, do
//
//     final registroVacunasModel = registroVacunasModelFromJson(jsonString);

import 'dart:convert';

RegistroVacunasModel registroVacunasModelFromJson(String str) =>
    RegistroVacunasModel.fromJson(json.decode(str));

String registroVacunasModelToJson(RegistroVacunasModel data) =>
    json.encode(data.toJson());

class RegistroVacunasModel {
  RegistroVacunasModel({
    this.id = '',
    this.fechaConsulta = '',
    this.pesoActual = 2.2,
    this.fechaProximaVacuna = '',
    this.tipoVacuna = '',
    this.veterinarioResp = '',
  });

  String id;
  String fechaConsulta;
  double pesoActual;
  String fechaProximaVacuna;
  String tipoVacuna;
  String veterinarioResp;

  factory RegistroVacunasModel.fromJson(Map<String, dynamic> json) =>
      RegistroVacunasModel(
        id: json["id"],
        fechaConsulta: json["fechaConsulta"],
        pesoActual: json["pesoActual"].toDouble(),
        fechaProximaVacuna: json["fechaProximaVacuna"],
        tipoVacuna: json["tipoVacuna"],
        veterinarioResp: json["veterinarioResp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fechaConsulta": fechaConsulta,
        "pesoActual": pesoActual,
        "fechaProximaVacuna": fechaProximaVacuna,
        "tipoVacuna": tipoVacuna,
        "veterinarioResp": veterinarioResp,
      };
}
