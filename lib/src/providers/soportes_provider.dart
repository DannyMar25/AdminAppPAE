import 'package:aministrador_app_v1/src/models/horarios_model.dart';
import 'package:aministrador_app_v1/src/models/soportes_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SoportesProvider {
  CollectionReference refS = FirebaseFirestore.instance.collection('soportes');
  //late AnimalModel animal1;

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<bool> crearSoportes(SoportesModel soporte) async {
    try {
      // print("este esadkjljdkjadkjskadjlkjsdljasdljasdj");
      var soporteAdd = await refS.add(soporte.toJson());
      await refS.doc(soporteAdd.id).update({"id": soporteAdd.id});
      return true;
    } catch (e) {
      return false;
    }
  }

  // Future<bool> editarHorarios(HorariosModel horarios) async {
  //   try {
  //     await refS.doc(horarios.id).update(horarios.toJson());
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // Future<List<HorariosModel>> cargarHorarios() async {
  //   final List<HorariosModel> horarios = <HorariosModel>[];
  //   var documents = await refAn.get();
  //   horarios.addAll(documents.docs.map((e) {
  //     //var animal = AnimalModel.fromJson(e.data() as Map<String, dynamic>);
  //     var data = e.data() as Map<String, dynamic>;
  //     var horario = HorariosModel.fromJson({
  //       "id": e.id,
  //       "dia": data["dia"],
  //       "hora": data["hora"],
  //       "disponible": data["disponible"],
  //     });
  //     return horario;
  //   }).toList());
  //   return horarios;
  // }
}
