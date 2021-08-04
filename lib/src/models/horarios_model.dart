// To parse this JSON data, do
//
//     final horariosModel = horariosModelFromJson(jsonString);

import 'dart:convert';

HorariosModel horariosModelFromJson(String str) =>
    HorariosModel.fromJson(json.decode(str));

String horariosModelToJson(HorariosModel data) => json.encode(data.toJson());

class HorariosModel {
  String id;
  String dia;
  String hora;
  //bool disponible;
  String disponible;

  HorariosModel({
    this.id = '',
    this.dia = '',
    this.hora = '',
    this.disponible = '',
  });

  factory HorariosModel.fromJson(Map<String, dynamic> json) => HorariosModel(
        id: json["id"],
        dia: json["dia"],
        hora: json["hora"],
        disponible: json["disponible"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dia": dia,
        "hora": hora,
        "disponible": disponible,
      };
}
