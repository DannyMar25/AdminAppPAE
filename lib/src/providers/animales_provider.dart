import 'dart:convert';
import 'dart:io';
import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class AnimalesProvider {
  CollectionReference refAn = FirebaseFirestore.instance.collection('animales');
  //late AnimalModel animal1;

  final String _url =
      'https://flutter-varios-1637a-default-rtdb.firebaseio.com';
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<bool> crearAnimal1(AnimalModel animal, File _image1) async {
    try {
      // print("este esadkjljdkjadkjskadjlkjsdljasdljasdj");
      var animalAdd = await refAn.add(animal.toJson());

      String url;
      String path;
      String fec = DateTime.now().toString();
      path = '/animales/${animalAdd.id}/${animalAdd.id + fec}.jpg';
      //Reference ref = storage.ref().child(path + DateTime.now().toString());
      Reference ref = storage.ref().child(path);
      UploadTask uploadTask = ref.putFile(_image1);
      uploadTask.whenComplete(() async {
        url = await ref.getDownloadURL();
        //guardarBase(url);
        //actualizarCampoUrl(url, animal);
        await refAn
            .doc(animalAdd.id)
            .update({"fotoUrl": url, "id": animalAdd.id});
        return url;
      }).catchError((onError) {
        print(onError);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setCoordenada(int n, String id) async {
    //final url = '$_url/animales/${animal.id}.json?auth=${_prefs.token}';
    final url = '$_url/gps/Test/.json';
    final values = {"GetDataGPS": n, "id": id};

    final resp = await http.put(Uri.parse(url), body: values);
    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<bool> editarAnimal(AnimalModel animal, File _image1) async {
    try {
      await refAn.doc(animal.id).update(animal.toJson());
      //var animalUp = await refAn.doc(animal.id).update(animal.toJson());
      String url;
      String path;
      String fec = DateTime.now().toString();
      path = '/animales/${animal.id}/${animal.id! + fec}.jpg';
      //Reference ref = storage.ref().child(path + DateTime.now().toString());
      Reference ref = storage.ref().child(path);
      UploadTask uploadTask = ref.putFile(_image1);
      uploadTask.whenComplete(() async {
        url = await ref.getDownloadURL();
        //guardarBase(url);
        //actualizarCampoUrl(url, animal);
        await refAn.doc(animal.id).update({"fotoUrl": url});
        return url;
      }).catchError((onError) {
        print(onError);
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<AnimalModel>> cargarAnimal1() async {
    final List<AnimalModel> animales = <AnimalModel>[];
    var documents = await refAn.get();
    animales.addAll(documents.docs.map((e) {
      //var animal = AnimalModel.fromJson(e.data() as Map<String, dynamic>);
      var data = e.data() as Map<String, dynamic>;
      var animal = AnimalModel.fromJson({
        "id": e.id,
        "nombre": data["nombre"],
        "sexo": data["sexo"],
        "edad": data["edad"],
        "temperamento": data["temperamento"],
        "peso": data["peso"],
        "tamanio": data["tamanio"],
        "color": data["color"],
        "raza": data["raza"],
        "caracteristicas": data["caracteristicas"],
        "fotoUrl": data["fotoUrl"]
      });
      return animal;
    }).toList());
    return animales;
  }

  Future<int> borrarAnimal(String id) async {
    await refAn.doc(id).delete();

    return 1;
  }

  Future<AnimalModel> cargarAnimalId(String id) async {
    AnimalModel animals = new AnimalModel();
    final doc = await refAn.doc(id).get();
    var data = doc.data() as Map<String, dynamic>;

    animals = AnimalModel.fromJson({
      "id": doc.id,
      "nombre": data["nombre"],
      "sexo": data["sexo"],
      "edad": data["edad"],
      "temperamento": data["temperamento"],
      "peso": data["peso"],
      "tamanio": data["tamanio"],
      "color": data["color"],
      "raza": data["raza"],
      "caracteristicas": data["caracteristicas"],
      "fotoUrl": data["fotoUrl"]
    });

    return animals;
  }
}
