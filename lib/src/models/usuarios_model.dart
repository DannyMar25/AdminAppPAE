// To parse this JSON data, do
//
//     final soportesModel = soportesModelFromJson(jsonString);

import 'dart:convert';

UsuariosModel soportesModelFromJson(String str) =>
    UsuariosModel.fromJson(json.decode(str));

String soportesModelToJson(UsuariosModel data) => json.encode(data.toJson());

class UsuariosModel {
  UsuariosModel({
    this.id = '',
    //this.idUs = '',
    this.email = '',
    this.nombre = '',
    this.cedula = '',
    this.rol = '',
  });

  String id;
  //String idUs;
  String email;
  String nombre;
  String cedula;
  String rol;

  factory UsuariosModel.fromJson(Map<String, dynamic> json) => UsuariosModel(
        id: json["id"],
        //idUs: json["idUs"],
        email: json["email"],
        nombre: json["nombre"],
        cedula: json["cedula"],
        rol: json["rol"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "nombre": nombre,
        "cedula": cedula,
        "rol": rol,
      };
}
