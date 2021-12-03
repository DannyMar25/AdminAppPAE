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

  Future<bool> editarHorarios(HorariosModel horarios) async {
    try {
      await refAn.doc(horarios.id).update(horarios.toJson());
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

  Future<List<HorariosModel>> cargarHorariosDia(String dia) async {
    final List<HorariosModel> horarios = <HorariosModel>[];
    var documents = await refAn
        .where('dia', isEqualTo: dia)
        //.where('disponible', isEqualTo: 'Disponible')
        .get();
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

  Future<List<HorariosModel>> cargarHorariosDia1(String dia) async {
    final List<HorariosModel> horarios = <HorariosModel>[];
    var documents = await refAn
        .where('dia', isEqualTo: dia)
        .where('disponible', isEqualTo: 'Disponible')
        .get();
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

  Future<HorariosModel> cargarHorarioId(String id) async {
    HorariosModel horarios = new HorariosModel();
    //print("imprimire nmas bdk: " + id);
    final doc = await refAn.doc(id).get();
    print("sadhslkdhl: " + doc.id);
    print("asdasddsaddd: " + doc.data().toString());
    var data = doc.data() as Map<String, dynamic>;
    horarios = HorariosModel.fromJson({
      "id": doc.id,
      "dia": data["dia"],
      "hora": data["hora"],
      "disponible": data["disponible"],
    });
    print(horarios.dia);
    return horarios;
  }

  Future<bool> editarDisponible(HorariosModel horario) async {
    try {
      String disp = "No disponible";
      await refAn.doc(horario.id).update({"disponible": disp});
      return true;
    } catch (e) {
      return false;
    }
  }
}
