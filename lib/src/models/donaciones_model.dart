// To parse this JSON data, do
//
//     final donacionesModel = donacionesModelFromJson(jsonString);

import 'dart:convert';

DonacionesModel donacionesModelFromJson(String str) =>
    DonacionesModel.fromJson(json.decode(str));

String donacionesModelToJson(DonacionesModel data) =>
    json.encode(data.toJson());

//Se aumento los campos disponibilidad y fecha de ingreso

class DonacionesModel {
  DonacionesModel({
    this.id = '',
    this.tipo = '',
    this.cantidad = 0,
    this.peso = 0.0,
    this.descripcion = '',
    this.estadoDonacion = '',
    this.disponibilidad = '',
    this.fechaIngreso = '',
  });

  String id;
  String tipo;
  int cantidad;
  double peso;
  String descripcion;
  String estadoDonacion;
  String disponibilidad;
  String fechaIngreso;

  factory DonacionesModel.fromJson(Map<String, dynamic> json) =>
      DonacionesModel(
        id: json["id"],
        tipo: json["tipo"],
        cantidad: json["cantidad"],
        peso: json["peso"].toDouble(),
        descripcion: json["descripcion"],
        estadoDonacion: json["estadoDonacion"],
        disponibilidad: json["disponibilidad"],
        fechaIngreso: json["fechaIngreso"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "cantidad": cantidad,
        "peso": peso,
        "descripcion": descripcion,
        "estadoDonacion": estadoDonacion,
        "disponibilidad": disponibilidad,
        "fechaIngreso": fechaIngreso,
      };
}
