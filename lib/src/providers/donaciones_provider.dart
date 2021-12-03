import 'package:aministrador_app_v1/src/models/donaciones_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DonacionesProvider {
  CollectionReference refDon =
      FirebaseFirestore.instance.collection('donaciones');
  //late AnimalModel animal1;
  int total1 = 0;
  String? totalA;

  FirebaseStorage storage = FirebaseStorage.instance;
  final List<DonacionesModel> donaciones = <DonacionesModel>[];

  Future<bool> crearDonacion(DonacionesModel donacion) async {
    try {
      // print("este esadkjljdkjadkjskadjlkjsdljasdljasdj");
      var donacionAdd = await refDon.add(donacion.toJson());
      await refDon.doc(donacionAdd.id).update({"id": donacionAdd.id});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editarDonacion(DonacionesModel donaciones) async {
    try {
      await refDon.doc(donaciones.id).update(donaciones.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<DonacionesModel>> cargarDonaciones(String tipo) async {
    final List<DonacionesModel> donaciones = <DonacionesModel>[];
    var documents = await refDon.where('tipo', isEqualTo: tipo).get();
    donaciones.addAll(documents.docs.map((e) {
      //var animal = AnimalModel.fromJson(e.data() as Map<String, dynamic>);
      var data = e.data() as Map<String, dynamic>;
      var donacion = DonacionesModel.fromJson({
        "id": e.id,
        "tipo": data["tipo"],
        "cantidad": data["cantidad"],
        "peso": data["peso"],
        "descripcion": data["descripcion"],
        "estadoDonacion": data["estadoDonacion"],
      });
      return donacion;
    }).toList());
    return donaciones;
  }

  Future<List<DonacionesModel>> verDonaciones1(String tipo) async {
    donaciones.clear();
    total1 = 0;
    totalA = '';
    //totalA = 0;
    var documents = await refDon
        .where('estadoDonacion', isEqualTo: 'Entrante')
        .where('tipo', isEqualTo: tipo)
        .get();
    donaciones.addAll(documents.docs.map((e) {
      //var animal = AnimalModel.fromJson(e.data() as Map<String, dynamic>);
      var data = e.data() as Map<String, dynamic>;
      var donacion = DonacionesModel.fromJson({
        "id": e.id,
        "tipo": data["tipo"],
        "cantidad": data["cantidad"],
        "peso": data["peso"],
        "descripcion": data["descripcion"],
        "estadoDonacion": data["estadoDonacion"],
      });
      return donacion;
    }).toList());

    for (var documents in donaciones) {
      total1 += documents.cantidad;
    }
    //donaciones.clear();
    //totalA = total1.toString();
    print(total1);
    return donaciones;
  }

  int sumarDonaciones1() {
    //print(total1);
    return total1;
  }
}
