// To parse this JSON data, do
//
//     final donacionesModel = donacionesModelFromJson(jsonString);

import 'dart:convert';

DonacionesModel donacionesModelFromJson(String str) =>
    DonacionesModel.fromJson(json.decode(str));

String donacionesModelToJson(DonacionesModel data) =>
    json.encode(data.toJson());

class DonacionesModel {
  DonacionesModel({
    this.id = '',
    this.tipo = '',
    this.cantidad = 0,
    this.peso = 0.0,
    this.descripcion = '',
    this.estadoDonacion = '',
  });

  String id;
  String tipo;
  int cantidad;
  double peso;
  String descripcion;
  String estadoDonacion;

  factory DonacionesModel.fromJson(Map<String, dynamic> json) =>
      DonacionesModel(
        id: json["id"],
        tipo: json["tipo"],
        cantidad: json["cantidad"],
        peso: json["peso"].toDouble(),
        descripcion: json["descripcion"],
        estadoDonacion: json["estadoDonacion"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "cantidad": cantidad,
        "peso": peso,
        "descripcion": descripcion,
        "estadoDonacion": estadoDonacion,
      };
}
