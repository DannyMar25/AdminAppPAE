// To parse this JSON data, do
//
//     final sitFamiliarModel = sitFamiliarModelFromJson(jsonString);

import 'dart:convert';

SitFamiliarModel sitFamiliarModelFromJson(String str) =>
    SitFamiliarModel.fromJson(json.decode(str));

String sitFamiliarModelToJson(SitFamiliarModel data) =>
    json.encode(data.toJson());

class SitFamiliarModel {
  SitFamiliarModel({
    this.id = '',
    this.nombreFam1 = '',
    this.edadFam1 = 0,
    this.parentescoFam1 = '',
    this.nombreFam2 = '',
    this.edadFam2 = 0,
    this.parentescoFam2 = '',
    this.nombreFam3 = '',
    this.edadFam3 = 0,
    this.parentescoFam3 = '',
    this.nombreFam4 = '',
    this.edadFam4 = 0,
    this.parentescoFam4 = '',
    this.esperaBebe = '',
    this.alergiaAnimal = '',
  });

  String id;
  String nombreFam1;
  int edadFam1;
  String parentescoFam1;
  String nombreFam2;
  int edadFam2;
  String parentescoFam2;
  String nombreFam3;
  int edadFam3;
  String parentescoFam3;
  String nombreFam4;
  int edadFam4;
  String parentescoFam4;
  String esperaBebe;
  String alergiaAnimal;

  factory SitFamiliarModel.fromJson(Map<String, dynamic> json) =>
      SitFamiliarModel(
        id: json["id"],
        nombreFam1: json["nombreFam1"],
        edadFam1: json["edadFam1"],
        parentescoFam1: json["parentescoFam1"],
        nombreFam2: json["nombreFam2"],
        edadFam2: json["edadFam2"],
        parentescoFam2: json["parentescoFam2"],
        nombreFam3: json["nombreFam3"],
        edadFam3: json["edadFam3"],
        parentescoFam3: json["parentescoFam3"],
        nombreFam4: json["nombreFam4"],
        edadFam4: json["edadFam4"],
        parentescoFam4: json["parentescoFam4"],
        esperaBebe: json["esperaBebe"],
        alergiaAnimal: json["alergiaAnimal"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombreFam1": nombreFam1,
        "edadFam1": edadFam1,
        "parentescoFam1": parentescoFam1,
        "nombreFam2": nombreFam2,
        "edadFam2": edadFam2,
        "parentescoFam2": parentescoFam2,
        "nombreFam3": nombreFam3,
        "edadFam3": edadFam3,
        "parentescoFam3": parentescoFam3,
        "nombreFam4": nombreFam4,
        "edadFam4": edadFam4,
        "parentescoFam4": parentescoFam4,
        "esperaBebe": esperaBebe,
        "alergiaAnimal": alergiaAnimal,
      };
}
