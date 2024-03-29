import 'dart:io';
import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AnimalesProvider {
  CollectionReference refAn = FirebaseFirestore.instance.collection('animales');
  //late AnimalModel animal1;

  // final String _url =
  //     'https://flutter-varios-1637a-default-rtdb.firebaseio.com';
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<bool> crearAnimal1(AnimalModel animal, File _image1) async {
    try {
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

  Future<bool> editarAnimal(AnimalModel animal, File _image1) async {
    try {
      await refAn.doc(animal.id).update(animal.toJson());
      String url;
      String path;
      String fec = DateTime.now().toString();
      path = '/animales/${animal.id}/${animal.id! + fec}.jpg';
      Reference ref = storage.ref().child(path);
      UploadTask uploadTask = ref.putFile(_image1);
      uploadTask.whenComplete(() async {
        url = await ref.getDownloadURL();
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

  Future<bool> editarAnimalSinFoto(AnimalModel animal, String fotourl) async {
    try {
      await refAn.doc(animal.id).update(animal.toJson());
      await refAn.doc(animal.id).update({"fotoUrl": fotourl});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<AnimalModel>> cargarAnimal1() async {
    final List<AnimalModel> animales = <AnimalModel>[];
    var documents = await refAn.get();
    animales.addAll(documents.docs.map((e) {
      var data = e.data() as Map<String, dynamic>;
      var animal = AnimalModel.fromJson({
        "id": e.id,
        "especie": data["especie"],
        "nombre": data["nombre"],
        "sexo": data["sexo"],
        "etapaVida": data["etapaVida"],
        "temperamento": data["temperamento"],
        "peso": data["peso"],
        "tamanio": data["tamanio"],
        "color": data["color"],
        "raza": data["raza"],
        "esterilizado": data["esterilizado"],
        "estado": data["estado"],
        "caracteristicas": data["caracteristicas"],
        "fotoUrl": data["fotoUrl"]
      });
      return animal;
    }).toList());
    return animales;
  }

  Future<List<AnimalModel>> cargarAnimalBusqueda(String nombre) async {
    final List<AnimalModel> animales = <AnimalModel>[];
    var documents =
        await refAn.where('nombre', isGreaterThanOrEqualTo: nombre).get();
    animales.addAll(documents.docs.map((e) {
      var data = e.data() as Map<String, dynamic>;
      var animal = AnimalModel.fromJson({
        "id": e.id,
        "especie": data["especie"],
        "nombre": data["nombre"],
        "sexo": data["sexo"],
        "etapaVida": data["etapaVida"],
        "temperamento": data["temperamento"],
        "peso": data["peso"],
        "tamanio": data["tamanio"],
        "color": data["color"],
        "raza": data["raza"],
        "esterilizado": data["esterilizado"],
        "estado": data["estado"],
        "caracteristicas": data["caracteristicas"],
        "fotoUrl": data["fotoUrl"]
      });
      return animal;
    }).toList());
    return animales;
  }

  Future<List<AnimalModel>> cargarBusqueda(String? especie, String? sexo,
      String? etapaVida, String? tamanio, String? estado) async {
    final List<AnimalModel> animales = <AnimalModel>[];
    var documents = await refAn
        .where('especie', isEqualTo: especie)
        .where('estado', isEqualTo: estado)
        .where('sexo', isEqualTo: sexo)
        .where('etapaVida', isEqualTo: etapaVida)
        .where('tamanio', isEqualTo: tamanio)
        .get();
    animales.addAll(documents.docs.map((e) {
      var data = e.data() as Map<String, dynamic>;
      var animal = AnimalModel.fromJson({
        "id": e.id,
        "especie": data["especie"],
        "nombre": data["nombre"],
        "sexo": data["sexo"],
        "etapaVida": data["etapaVida"],
        "temperamento": data["temperamento"],
        "peso": data["peso"],
        "tamanio": data["tamanio"],
        "color": data["color"],
        "raza": data["raza"],
        "esterilizado": data["esterilizado"],
        "estado": data["estado"],
        "caracteristicas": data["caracteristicas"],
        "fotoUrl": data["fotoUrl"]
      });
      return animal;
    }).toList());
    return animales;
  }

  Future<List<AnimalModel>> cargarBusqueda4(
      String especie, String sexo, String etapaVida, String estado) async {
    final List<AnimalModel> animales = <AnimalModel>[];
    var documents = await refAn
        .where('especie', isEqualTo: especie)
        .where('estado', isEqualTo: estado)
        .where('sexo', isEqualTo: sexo)
        .where('etapaVida', isEqualTo: etapaVida)
        .get();
    animales.addAll(documents.docs.map((e) {
      var data = e.data() as Map<String, dynamic>;
      var animal = AnimalModel.fromJson({
        "id": e.id,
        "especie": data["especie"],
        "nombre": data["nombre"],
        "sexo": data["sexo"],
        "etapaVida": data["etapaVida"],
        "temperamento": data["temperamento"],
        "peso": data["peso"],
        "tamanio": data["tamanio"],
        "color": data["color"],
        "raza": data["raza"],
        "esterilizado": data["esterilizado"],
        "estado": data["estado"],
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
      "especie": data["especie"],
      "nombre": data["nombre"],
      "sexo": data["sexo"],
      "etapaVida": data["etapaVida"],
      "temperamento": data["temperamento"],
      "peso": data["peso"],
      "tamanio": data["tamanio"],
      "color": data["color"],
      "raza": data["raza"],
      "esterilizado": data["esterilizado"],
      "estado": data["estado"],
      "caracteristicas": data["caracteristicas"],
      "fotoUrl": data["fotoUrl"]
    });

    return animals;
  }

  Future<bool> editarEstado(AnimalModel animal, String estado) async {
    try {
      //String disp = "";
      await refAn.doc(animal.id).update({"estado": estado});
      return true;
    } catch (e) {
      return false;
    }
  }

  //Nuevas funciones
}
