import 'package:aministrador_app_v1/src/models/soportes_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SoportesProvider {
  CollectionReference refS = FirebaseFirestore.instance.collection('soportes');

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<bool> crearSoportes(SoportesModel soporte) async {
    try {
      var soporteAdd = await refS.add(soporte.toJson());
      await refS.doc(soporteAdd.id).update({"id": soporteAdd.id});
      return true;
    } catch (e) {
      return false;
    }
  }
}
