// To parse this JSON data, do
//
//     final relacionAnimalesModel = relacionAnimalesModelFromJson(jsonString);

import 'dart:convert';

RelacionAnimalesModel relacionAnimalesModelFromJson(String str) =>
    RelacionAnimalesModel.fromJson(json.decode(str));

String relacionAnimalesModelToJson(RelacionAnimalesModel data) =>
    json.encode(data.toJson());

class RelacionAnimalesModel {
  RelacionAnimalesModel({
    this.id = '',
    this.tipoMs1 = '',
    this.nombreMs1 = '',
    this.sexoMs1 = '',
    this.estMs1 = '',
    this.tipoMs2 = '',
    this.nombreMs2 = '',
    this.sexoMs2 = '',
    this.estMs2 = '',
    this.ubicMascota = '',
    this.deseoAdop = '',
    this.cambioDomi = '',
    this.relNuevaCasa = '',
    this.viajeMascota = '',
    this.tiempoSolaMas = '',
    this.diaNocheMas = '',
    this.duermeMas = '',
    this.necesidadMas = '',
    this.comidaMas = '',
    this.promedVida = '',
    this.enfermedadMas = '',
    this.responGastos = '',
    this.dineroMas = '',
    this.recursoVet = '',
    this.visitaPer = '',
    this.justificacion1 = '',
    this.acuerdoEst = '',
    this.justificacion2 = '',
    this.benefEst = '',
    this.tenenciaResp = '',
    this.ordenMuni = '',
    this.adCompart = '',
    this.famAcuerdo = '',
  });

  String id;
  String tipoMs1;
  String nombreMs1;
  String sexoMs1;
  String estMs1;
  String tipoMs2;
  String nombreMs2;
  String sexoMs2;
  String estMs2;
  String ubicMascota;
  String deseoAdop;
  String cambioDomi;
  String relNuevaCasa;
  String viajeMascota;
  String tiempoSolaMas;
  String diaNocheMas;
  String duermeMas;
  String necesidadMas;
  String comidaMas;
  String promedVida;
  String enfermedadMas;
  String responGastos;
  String dineroMas;
  String recursoVet;
  String visitaPer;
  String justificacion1;
  String acuerdoEst;
  String justificacion2;
  String benefEst;
  String tenenciaResp;
  String ordenMuni;
  String adCompart;
  String famAcuerdo;

  factory RelacionAnimalesModel.fromJson(Map<String, dynamic> json) =>
      RelacionAnimalesModel(
        id: json["id"],
        tipoMs1: json["tipoMs1"],
        nombreMs1: json["nombreMs1"],
        sexoMs1: json["sexoMs1"],
        estMs1: json["estMs1"],
        tipoMs2: json["tipoMs2"],
        nombreMs2: json["nombreMs2"],
        sexoMs2: json["sexoMs2"],
        estMs2: json["estMs2"],
        ubicMascota: json["ubicMascota"],
        deseoAdop: json["deseoAdop"],
        cambioDomi: json["cambioDomi"],
        relNuevaCasa: json["relNuevaCasa"],
        viajeMascota: json["viajeMascota"],
        tiempoSolaMas: json["tiempoSolaMas"],
        diaNocheMas: json["diaNocheMas"],
        duermeMas: json["duermeMas"],
        necesidadMas: json["necesidadMas"],
        comidaMas: json["comidaMas"],
        promedVida: json["promedVida"],
        enfermedadMas: json["enfermedadMas"],
        responGastos: json["responGastos"],
        dineroMas: json["dineroMas"],
        recursoVet: json["recursoVet"],
        visitaPer: json["visitaPer"],
        justificacion1: json["justificacion1"],
        acuerdoEst: json["acuerdoEst"],
        justificacion2: json["justificacion2"],
        benefEst: json["benefEst"],
        tenenciaResp: json["tenenciaResp"],
        ordenMuni: json["ordenMuni"],
        adCompart: json["adCompart"],
        famAcuerdo: json["famAcuerdo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipoMs1": tipoMs1,
        "nombreMs1": nombreMs1,
        "sexoMs1": sexoMs1,
        "estMs1": estMs1,
        "tipoMs2": tipoMs2,
        "nombreMs2": nombreMs2,
        "sexoMs2": sexoMs2,
        "estMs2": estMs2,
        "ubicMascota": ubicMascota,
        "deseoAdop": deseoAdop,
        "cambioDomi": cambioDomi,
        "relNuevaCasa": relNuevaCasa,
        "viajeMascota": viajeMascota,
        "tiempoSolaMas": tiempoSolaMas,
        "diaNocheMas": diaNocheMas,
        "duermeMas": duermeMas,
        "necesidadMas": necesidadMas,
        "comidaMas": comidaMas,
        "promedVida": promedVida,
        "enfermedadMas": enfermedadMas,
        "responGastos": responGastos,
        "dineroMas": dineroMas,
        "recursoVet": recursoVet,
        "visitaPer": visitaPer,
        "justificacion1": justificacion1,
        "acuerdoEst": acuerdoEst,
        "justificacion2": justificacion2,
        "benefEst": benefEst,
        "tenenciaResp": tenenciaResp,
        "ordenMuni": ordenMuni,
        "adCompart": adCompart,
        "famAcuerdo": famAcuerdo,
      };
}
