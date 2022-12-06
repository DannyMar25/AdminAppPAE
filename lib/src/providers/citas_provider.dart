import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/models/citas_model.dart';
import 'package:aministrador_app_v1/src/models/horarios_model.dart';
import 'package:aministrador_app_v1/src/providers/animales_provider.dart';
import 'package:aministrador_app_v1/src/providers/horarios_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CitasProvider {
  CollectionReference refCit = FirebaseFirestore.instance.collection('citas');
  FirebaseStorage storage = FirebaseStorage.instance;
  final horariosProvider = new HorariosProvider();
  final animalesProvider = new AnimalesProvider();

  Future<bool> crearCita(
    CitasModel cita,
  ) async {
    try {
      var citasAdd = await refCit.add(cita.toJson());
      await refCit.doc(citasAdd.id).update({"id": citasAdd.id});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Future<CitasModel>>> cargarCitas() async {
    var documents = await refCit.where('estado', isEqualTo: 'Pendiente').get();
    var s = (documents.docs.map((e) async {
      var data = e.data() as Map<String, dynamic>;
      HorariosModel h1 = new HorariosModel();
      AnimalModel anim = new AnimalModel();
      h1 = await horariosProvider.cargarHorarioId(e["idHorario"]);
      anim = await animalesProvider.cargarAnimalId(e["idAnimal"]);
      var cita = CitasModel.fromJson({
        "id": e.id,
        "nombreClient": e["nombreClient"],
        "telfClient": e["telfClient"],
        "correoClient": e["correoClient"],
        "estado": e["estado"],
        "fechaCita": e["fechaCita"],
        "idAnimal": e["idAnimal"],
        "idHorario": e["idHorario"]
      });
      cita.horario = h1;
      cita.animal = anim;
      return cita;
    }));
    return s.toList();
  }

  Future<List<Future<CitasModel>>> cargarCitasFecha(String fecha) async {
    var documents = await refCit
        .where('fechaCita', isEqualTo: fecha)
        .where('estado', isEqualTo: 'Pendiente')
        .get();
    //citas.addAll
    var s = (documents.docs.map((e) async {
      //var animal = AnimalModel.fromJson(e.data() as Map<String, dynamic>);
      var data = e.data() as Map<String, dynamic>;
      HorariosModel h1 = new HorariosModel();
      AnimalModel anim = new AnimalModel();
      h1 = await horariosProvider.cargarHorarioId(e["idHorario"]);
      anim = await animalesProvider.cargarAnimalId(e["idAnimal"]);
      var cita = CitasModel.fromJson({
        "id": e.id,
        "nombreClient": e["nombreClient"],
        "telfClient": e["telfClient"],
        "correoClient": e["correoClient"],
        "estado": e["estado"],
        "fechaCita": e["fechaCita"],
        "idAnimal": e["idAnimal"],
        "idHorario": e["idHorario"]
      });
      cita.horario = h1;
      cita.animal = anim;
      return cita;
    }));
    return s.toList();
  }

  Future<List<Future<CitasModel>>> cargarCitasAtendidas(String fecha) async {
    var documents = await refCit
        .where('estado', isEqualTo: 'Atendido')
        .where('fechaCita', isEqualTo: fecha)
        .get();
    var s = (documents.docs.map((e) async {
      var data = e.data() as Map<String, dynamic>;
      HorariosModel h1 = new HorariosModel();
      AnimalModel anim = new AnimalModel();
      h1 = await horariosProvider.cargarHorarioId(e["idHorario"]);
      anim = await animalesProvider.cargarAnimalId(e["idAnimal"]);
      var cita = CitasModel.fromJson({
        "id": e.id,
        "nombreClient": e["nombreClient"],
        "telfClient": e["telfClient"],
        "correoClient": e["correoClient"],
        "estado": e["estado"],
        "fechaCita": e["fechaCita"],
        "idAnimal": e["idAnimal"],
        "idHorario": e["idHorario"]
      });
      cita.horario = h1;
      cita.animal = anim;
      return cita;
    }));
    return s.toList();
  }

  Future<bool> editarEstadoCita(CitasModel cita) async {
    try {
      String estado = "Atendido";
      await refCit.doc(cita.id).update({"estado": estado});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Future<CitasModel>>> verificar(String correo) async {
    var documents = await refCit
        .where('estado', isEqualTo: 'Pendiente')
        .where('correoClient', isEqualTo: correo)
        .get();
    //citas.addAll
    var s = (documents.docs.map((e) async {
      //var data = e.data() as Map<String, dynamic>;
      var cita = CitasModel.fromJson({
        "id": e.id,
        "nombreClient": e["nombreClient"],
        "telfClient": e["telfClient"],
        "correoClient": e["correoClient"],
        "estado": e["estado"],
        "fechaCita": e["fechaCita"],
        "idAnimal": e["idAnimal"],
        "idHorario": e["idHorario"]
      });
      return cita;
    }));
    return s.toList();
  }
}
