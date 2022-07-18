// To parse this JSON data, do
//
//     final animalModel = animalModelFromJson(jsonString);

import 'dart:convert';

AnimalModel animalModelFromJson(String str) =>
    AnimalModel.fromJson(json.decode(str));

String animalModelToJson(AnimalModel data) => json.encode(data.toJson());

class AnimalModel {
  AnimalModel({
    this.id = '',
    this.especie = '',
    this.nombre = '',
    this.sexo = '',
    this.etapaVida = '',
    this.temperamento = '',
    this.peso = 0.0,
    this.tamanio = '',
    this.color = '',
    this.raza = '',
    this.esterilizado = '',
    this.estado = '',
    this.caracteristicas = '',
    this.fotoUrl = '',
  });

  String? id;
  String especie;
  String nombre;
  String sexo;
  String etapaVida; //Cambio de int a String
  String temperamento;
  double peso;
  String tamanio;
  String color;
  String raza;
  String esterilizado;
  String estado;
  String caracteristicas;
  String fotoUrl;

  factory AnimalModel.fromJson(Map<String, dynamic> json) => AnimalModel(
        id: json["id"],
        especie: json["especie"],
        nombre: json["nombre"],
        sexo: json["sexo"],
        etapaVida: json["etapaVida"],
        temperamento: json["temperamento"],
        peso: json["peso"].toDouble(),
        tamanio: json["tamanio"],
        color: json["color"],
        raza: json["raza"],
        esterilizado: json["esterilizado"],
        estado: json["estado"],
        caracteristicas: json["caracteristicas"],
        fotoUrl: json["fotoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "especie": especie,
        "nombre": nombre,
        "sexo": sexo,
        "etapaVida": etapaVida,
        "temperamento": temperamento,
        "peso": peso,
        "tamanio": tamanio,
        "color": color,
        "raza": raza,
        "esterilizado": esterilizado,
        "estado": estado,
        "caracteristicas": caracteristicas,
        "fotoUrl": fotoUrl,
      };
}
