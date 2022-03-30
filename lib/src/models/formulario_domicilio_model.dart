// To parse this JSON data, do
//
//     final domicilioModel = domicilioModelFromJson(jsonString);

import 'dart:convert';

DomicilioModel domicilioModelFromJson(String str) =>
    DomicilioModel.fromJson(json.decode(str));

String domicilioModelToJson(DomicilioModel data) => json.encode(data.toJson());

class DomicilioModel {
  DomicilioModel({
    this.id = '',
    this.tipoInmueble = '',
    this.m2 = 1.1,
    this.inmueble = '',
    this.nombreD = '',
    this.telfD = '',
    this.planMudanza = '',
    this.cerramiento = '',
    this.alturaC = 1.1,
    this.materialC = '',
    this.sexoAd = '',
    this.edadAd = '',
    this.tamanioAd = '',
  });

  String id;
  String tipoInmueble;
  double m2;
  String inmueble;
  String nombreD;
  String telfD;
  String planMudanza;
  String cerramiento;
  double alturaC;
  String materialC;
  String sexoAd;
  String edadAd;
  String tamanioAd;

  factory DomicilioModel.fromJson(Map<String, dynamic> json) => DomicilioModel(
        id: json["id"],
        tipoInmueble: json["tipoInmueble"],
        m2: json["m2"].toDouble(),
        inmueble: json["inmueble"],
        nombreD: json["nombreD"],
        telfD: json["telfD"],
        planMudanza: json["planMudanza"],
        cerramiento: json["cerramiento"],
        alturaC: json["alturaC"].toDouble(),
        materialC: json["materialC"],
        sexoAd: json["sexoAd"],
        edadAd: json["edadAd"],
        tamanioAd: json["tamanioAd"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipoInmueble": tipoInmueble,
        "m2": m2,
        "inmueble": inmueble,
        "nombreD": nombreD,
        "telfD": telfD,
        "planMudanza": planMudanza,
        "cerramiento": cerramiento,
        "alturaC": alturaC,
        "materialC": materialC,
        "sexoAd": sexoAd,
        "edadAd": edadAd,
        "tamanioAd": tamanioAd,
      };
}
