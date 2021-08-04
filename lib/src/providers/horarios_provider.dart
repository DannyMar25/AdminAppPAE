import 'package:aministrador_app_v1/src/models/horarios_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HorariosProvider {
  CollectionReference refAn = FirebaseFirestore.instance.collection('horarios');
  //late AnimalModel animal1;

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<bool> crearHorario(HorariosModel horario) async {
    try {
      // print("este esadkjljdkjadkjskadjlkjsdljasdljasdj");
      var horarioAdd = await refAn.add(horario.toJson());
      await refAn.doc(horarioAdd.id).update({"id": horarioAdd.id});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<HorariosModel>> cargarHorarios() async {
    final List<HorariosModel> horarios = <HorariosModel>[];
    var documents = await refAn.get();
    horarios.addAll(documents.docs.map((e) {
      //var animal = AnimalModel.fromJson(e.data() as Map<String, dynamic>);
      var data = e.data() as Map<String, dynamic>;
      var horario = HorariosModel.fromJson({
        "id": e.id,
        "dia": data["dia"],
        "hora": data["hora"],
        "disponible": data["disponible"],
      });
      return horario;
    }).toList());
    return horarios;
  }
}
