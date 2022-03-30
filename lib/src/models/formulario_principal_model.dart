// To parse this JSON data, do
//
//     final horariosModel = horariosModelFromJson(jsonString);

import 'dart:convert';

import 'package:aministrador_app_v1/src/models/animales_model.dart';

FormulariosModel formulariosModelFromJson(String str) =>
    FormulariosModel.fromJson(json.decode(str));

String formulariosModelToJson(FormulariosModel data) =>
    json.encode(data.toJson());

//Se anadio la fecha en la que lleno el formulario, se anadio identificacion y nombre del cliente
//Cambio se anadio el id de cada subcoleccion
//Se anadio los id para la evidencia, vacunas, desparasitaciones

class FormulariosModel {
  String id;
  String idAnimal;
  String fechaIngreso;
  String fechaRespuesta;
  String nombreClient;
  String identificacion;
  String estado;
  String observacion;
  String idDatosPersonales;
  String idSituacionFam;
  String idDomicilio;
  String idRelacionAn;
  String idVacuna;
  String idDesparasitacion;
  String idEvidencia;
  AnimalModel? animal;
  //bool disponible;
  //String disponible;

  FormulariosModel({
    this.id = '',
    this.idAnimal = '',
    this.fechaIngreso = '',
    this.fechaRespuesta = '',
    this.nombreClient = '',
    this.identificacion = '',
    this.estado = '',
    this.observacion = '',
    this.idDatosPersonales = '',
    this.idSituacionFam = '',
    this.idDomicilio = '',
    this.idRelacionAn = '',
    this.idVacuna = '',
    this.idDesparasitacion = '',
    this.idEvidencia = '',
    this.animal,
    //this.disponible = '',
  });

  factory FormulariosModel.fromJson(Map<String, dynamic> json) =>
      FormulariosModel(
        id: json["id"],
        idAnimal: json["idAnimal"],
        fechaIngreso: json["fechaIngreso"],
        fechaRespuesta: json["fechaRespuesta"],
        nombreClient: json["nombreClient"],
        identificacion: json["identificacion"],
        estado: json["estado"],
        observacion: json["observacion"],
        idDatosPersonales: json["idDatosPersonales"],
        idSituacionFam: json["idSituacionFam"],
        idDomicilio: json["idDomicilio"],
        idRelacionAn: json["idRelacionAn"],
        idVacuna: json["idVacuna"],
        idDesparasitacion: json["idDesparasitacion"],
        idEvidencia: json["idEvidencia"],
        //disponible: json["disponible"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idAnimal": idAnimal,
        "fechaIngreso": fechaIngreso,
        "fechaRespuesta": fechaRespuesta,
        "nombreClient": nombreClient,
        "identificacion": identificacion,
        "estado": estado,
        "observacion": observacion,
        "idDatosPersonales": idDatosPersonales,
        "idSituacionFam": idSituacionFam,
        "idDomicilio": idDomicilio,
        "idRelacionAn": idRelacionAn,
        "idVacuna": idVacuna,
        "idDesparasitacion": idDesparasitacion,
        "idEvidencia": idEvidencia,
        // "disponible": disponible,
      };
}
