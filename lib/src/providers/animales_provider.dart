import 'dart:convert';

import 'dart:io';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aministrador_app_v1/src/models/animales_model.dart';

import 'package:aministrador_app_v1/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;

class AnimalesProvider {
  final String _url =
      'https://flutter-varios-1637a-default-rtdb.firebaseio.com';

  final _prefs = new PreferenciasUsuario();

  Future<bool> crearAnimal(AnimalModel animal) async {
    //final url = '$_url/animales.json?auth=${_prefs.token}';
    final url = '$_url/animales.json';

    final resp =
        await http.post(Uri.parse(url), body: animalModelToJson(animal));
    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<bool> editarAnimal(AnimalModel animal) async {
    //final url = '$_url/animales/${animal.id}.json?auth=${_prefs.token}';
    final url = '$_url/animales/${animal.id}.json';

    final resp =
        await http.put(Uri.parse(url), body: animalModelToJson(animal));
    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<List<AnimalModel>> cargarAnimal() async {
    //final url = '$_url/animales.json?auth=${_prefs.token}';
    final url = '$_url/animales.json';
    final resp = await http.get(Uri.parse(url));
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<AnimalModel> animales = <AnimalModel>[];

    //print(decodedData);

    if (decodedData == null) {
      return [];
    }

    decodedData.forEach((id, animal) {
      //print(prod);\
      final animalTemp = AnimalModel.fromJson(animal);
      animalTemp.id = id;

      animales.add(animalTemp);
    });

    print(animales);

    return animales;
  }

  // Future<List<GpsModel>> cargarUbicacion() async {
  //   //final url = '$_url/animales.json?auth=${_prefs.token}';
  //   final url = '$_url/gps/coordenadas.json';
  //   final resp = await http.get(Uri.parse(url));
  //   final Map<String, dynamic> decodedData = json.decode(resp.body);
  //   final List<GpsModel> ubicaciones = <GpsModel>[];

  //   //print(decodedData);

  //   if (decodedData == null) {
  //     return [];
  //   }

  //   decodedData.forEach((lat, ubicacion) {
  //     //print(prod);\
  //     final gpsTemp = GpsModel.fromJson(ubicacion);
  //     gpsTemp.latitud = lat;

  //     ubicaciones.add(gpsTemp);
  //   });

  //   print(ubicaciones);

  //   return ubicaciones;
  // }

  Future<int> borrarAnimal(String id) async {
    final url = '$_url/animales/$id.json';
    //final url = '$_url/animales/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(Uri.parse(url));

    print(json.decode(resp.body));
    return 1;
  }

  Future uploadPic(File _image1, AnimalModel animal) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String url;
    Reference ref = storage.ref().child("image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image1);
    uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();
      //guardarBase(url);
      actualizarCampoUrl(url, animal);

      return url;
    }).catchError((onError) {
      print(onError);
    });
  }

  void actualizarCampoUrl(String url, AnimalModel animal) {
    //ProductoModel producto;
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    DatabaseReference prodRef = ref.child("animales");
    DatabaseReference urlRef = prodRef.child("${animal.id}");
    urlRef.update({"fotoUrl": "" + url});
  }

  Future<String?> subirImagen(File imagen) async {
    final url = Uri.parse('');
    final mimeType = mime(imagen.path)!.split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    //final respData = json.decode(resp.body);

    //return respData['secure_url'];
  }
}
