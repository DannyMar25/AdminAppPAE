// To parse this JSON data, do
//
//     final gpsModel = gpsModelFromJson(jsonString);

import 'dart:convert';

GpsModel gpsModelFromJson(String str) => GpsModel.fromJson(json.decode(str));

String gpsModelToJson(GpsModel data) => json.encode(data.toJson());

class GpsModel {
  GpsModel({
    //this.coordenadas = "",
    this.latitud = "",
    this.longitud = "",
  });

  //String coordenadas;
  String latitud;
  String longitud;

  factory GpsModel.fromJson(Map<String, dynamic> json) => GpsModel(
        //coordenadas: json["coordenadas"],
        latitud: json["latitud"],
        longitud: json["longitud"],
      );

  Map<String, dynamic> toJson() => {
        //"coordenadas": coordenadas,
        "latitud": latitud,
        "longitud": longitud,
      };
}
