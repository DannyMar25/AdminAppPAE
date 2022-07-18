// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

DatosPersonalesModel datosPersonalesModelFromJson(String str) =>
    DatosPersonalesModel.fromJson(json.decode(str));

String datosPersonalesModelToJson(DatosPersonalesModel data) =>
    json.encode(data.toJson());

class DatosPersonalesModel {
  DatosPersonalesModel({
    this.id = '',
    this.nombreCom = '',
    this.cedula = '',
    this.direccion = '',
    this.fechaNacimiento = '',
    this.ocupacion = '',
    this.email = '',
    this.nivelInst = '',
    this.telfCel = '',
    this.telfDomi = '',
    this.telfTrab = '',
    this.nombreRef = '',
    this.parentescoRef = '',
    this.telfRef = '',
  });

  String id;
  String nombreCom;
  String cedula;
  String direccion;
  String fechaNacimiento;
  String ocupacion;
  String email;
  String nivelInst;
  String telfCel;
  String telfDomi;
  String telfTrab;
  String nombreRef;
  String parentescoRef;
  String telfRef;

  factory DatosPersonalesModel.fromJson(Map<String, dynamic> json) =>
      DatosPersonalesModel(
        id: json["id"],
        nombreCom: json["nombreCom"],
        cedula: json["cedula"],
        direccion: json["direccion"],
        fechaNacimiento: json["fechaNacimiento"],
        ocupacion: json["ocupacion"],
        email: json["email"],
        nivelInst: json["nivelInst"],
        telfCel: json["telfCel"],
        telfDomi: json["telfDomi"],
        telfTrab: json["telfTrab"],
        nombreRef: json["nombreRef"],
        parentescoRef: json["parentescoRef"],
        telfRef: json["telfRef"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombreCom": nombreCom,
        "cedula": cedula,
        "direccion": direccion,
        "fechaNacimiento": fechaNacimiento,
        "ocupacion": ocupacion,
        "email": email,
        "nivelInst": nivelInst,
        "telfCel": telfCel,
        "telfDomi": telfDomi,
        "telfTrab": telfTrab,
        "nombreRef": nombreRef,
        "parentescoRef": parentescoRef,
        "telfRef": telfRef,
      };
}
