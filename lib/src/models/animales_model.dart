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
    this.nombre = '',
    this.sexo = '',
    this.edad = '',
    this.temperamento = '',
    this.peso = 0.0,
    this.tamanio = '',
    this.color = '',
    this.raza = '',
    this.caracteristicas = '',
    this.fotoUrl = '',
  });

  String? id;
  String nombre;
  String sexo;
  String edad; //Cambio de int a String
  String temperamento;
  double peso;
  String tamanio;
  String color;
  String raza;
  String caracteristicas;
  String fotoUrl;

  factory AnimalModel.fromJson(Map<String, dynamic> json) => AnimalModel(
        id: json["id"],
        nombre: json["nombre"],
        sexo: json["sexo"],
        edad: json["edad"],
        temperamento: json["temperamento"],
        peso: json["peso"].toDouble(),
        tamanio: json["tamanio"],
        color: json["color"],
        raza: json["raza"],
        caracteristicas: json["caracteristicas"],
        fotoUrl: json["fotoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "sexo": sexo,
        "edad": edad,
        "temperamento": temperamento,
        "peso": peso,
        "tamanio": tamanio,
        "color": color,
        "raza": raza,
        "caracteristicas": caracteristicas,
        "fotoUrl": fotoUrl,
      };
}
