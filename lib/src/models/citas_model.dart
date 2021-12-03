// To parse this JSON data, do
//
//     final citasModel = citasModelFromJson(jsonString);

import 'dart:convert';

import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/models/horarios_model.dart';

CitasModel citasModelFromJson(String str) =>
    CitasModel.fromJson(json.decode(str));

String citasModelToJson(CitasModel data) => json.encode(data.toJson());

class CitasModel {
  CitasModel(
      {this.id = '',
      this.nombreClient = '',
      this.telfClient = '',
      this.correoClient = '',
      this.estado = '',
      this.fechaCita = '',
      this.idAnimal = '',
      this.idHorario = '',
      this.animal,
      this.horario});

  String id;
  String nombreClient;
  String telfClient;
  String correoClient;
  String estado;
  String fechaCita;
  String idAnimal;
  String idHorario;
  AnimalModel? animal;
  HorariosModel? horario;

  factory CitasModel.fromJson(Map<String, dynamic> json) => CitasModel(
        id: json["id"],
        nombreClient: json["nombreClient"],
        telfClient: json["telfClient"],
        correoClient: json["correoClient"],
        estado: json["estado"],
        fechaCita: json["fechaCita"],
        idAnimal: json["idAnimal"],
        idHorario: json["idHorario"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombreClient": nombreClient,
        "telfClient": telfClient,
        "correoClient": correoClient,
        "estado": estado,
        "fechaCita": fechaCita,
        "idAnimal": idAnimal,
        "idHorario": idHorario,
      };
}
