import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/models/evidencia_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_domicilio_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_relacionAnimal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_situacionFam_model.dart';
import 'package:aministrador_app_v1/src/models/registro_desparasitaciones_model.dart';
import 'package:aministrador_app_v1/src/models/registro_vacunas_model.dart';
import 'package:aministrador_app_v1/src/providers/animales_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FormulariosProvider {
  CollectionReference refForm =
      FirebaseFirestore.instance.collection('formularios');
  final animalesProvider = new AnimalesProvider();

  //late AnimalModel animal1;

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> crearFormularioPrin(FormulariosModel formulario,
      DatosPersonalesModel datosPersona, BuildContext context) async {
    try {
      var formularioAdd = await refForm.add(formulario.toJson());
      await refForm.doc(formularioAdd.id).update({"id": formularioAdd.id});
      CollectionReference refFormDP = FirebaseFirestore.instance
          .collection('formularios')
          .doc(formularioAdd.id)
          .collection('datosPersonales');
      var datosPersonalesAdd = await refFormDP.add(datosPersona.toJson());
      await refFormDP
          .doc(datosPersonalesAdd.id)
          .update({"id": datosPersonalesAdd.id});
      //return formularioAdd.id;
      var idFormu = formularioAdd.id;
      Navigator.pushNamed(context, 'formularioP2', arguments: idFormu);
      print(idFormu);
      return idFormu;
    } catch (e) {
      return "";
    }
  }

  Future<List<Future<FormulariosModel>>> cargarFormularios() async {
    final List<FormulariosModel> formularios = <FormulariosModel>[];
    var documents = await refForm.where('estado', isEqualTo: 'Pendiente').get();
    //citas.addAll
    var s = (documents.docs.map((e) async {
      //var animal = AnimalModel.fromJson(e.data() as Map<String, dynamic>);
      var data = e.data() as Map<String, dynamic>;
      //HorariosModel h1 = new HorariosModel();
      AnimalModel anim = new AnimalModel();
      //h1 = await horariosProvider.cargarHorarioId(e["idHorario"]);
      anim = await animalesProvider.cargarAnimalId(e["idAnimal"]);
      var formulario = FormulariosModel.fromJson({
        "id": e.id,
        "idAnimal": e["idAnimal"],
        "fechaIngreso": e["fechaIngreso"],
        "fechaRespuesta": e["fechaRespuesta"],
        "idClient": e["idClient"],
        "nombreClient": e["nombreClient"],
        "identificacion": e["identificacion"],
        "emailClient": e["emailClient"],
        "estado": e["estado"],
        "observacion": e["observacion"],
        "idDatosPersonales": e["idDatosPersonales"],
        "idSituacionFam": e["idSituacionFam"],
        "idDomicilio": e["idDomicilio"],
        "idRelacionAn": e["idRelacionAn"],
        "idVacuna": e["idVacuna"],
        "idDesparasitacion": e["idDesparasitacion"],
        "idEvidencia": e["idEvidencia"],
      });
      //cita.horario = h1;
      formulario.animal = anim;
      return formulario;
    }));
    return s.toList();
  }

  Future<List<DatosPersonalesModel>> cargarFormularioDatosPerId(
      String idf) async {
    final List<DatosPersonalesModel> datos = <DatosPersonalesModel>[];
    var documents = await refForm.doc(idf).collection('datosPersonales').get();
    datos.addAll(documents.docs.map((e) {
      //var animal = AnimalModel.fromJson(e.data() as Map<String, dynamic>);
      var data = e.data();
      var datosPer = DatosPersonalesModel.fromJson({
        "id": e.id,
        "nombreCom": data["nombreCom"],
        "cedula": data["cedula"],
        "direccion": data["direccion"],
        "fechaNacimiento": data["fechaNacimiento"],
        "ocupacion": data["ocupacion"],
        "email": data["email"],
        "nivelInst": data["nivelInst"],
        "telfCel": data["telfCel"],
        "telfDomi": data["telfDomi"],
        "telfTrab": data["telfTrab"],
        "nombreRef": data["nombreRef"],
        "parentescoRef": data["parentescoRef"],
        "telfRef": data["telfRef"],
      });
      return datosPer;
    }).toList());
    return datos;
  }

  Future<DatosPersonalesModel> cargarDPId(String idf, String idD) async {
    DatosPersonalesModel datos = new DatosPersonalesModel();
    final doc =
        await refForm.doc(idf).collection('datosPersonales').doc(idD).get();
    var data = doc.data() as Map<String, dynamic>;

    datos = DatosPersonalesModel.fromJson({
      "id": data["id"],
      "nombreCom": data["nombreCom"],
      "cedula": data["cedula"],
      "direccion": data["direccion"],
      "fechaNacimiento": data["fechaNacimiento"],
      "ocupacion": data["ocupacion"],
      "email": data["email"],
      "nivelInst": data["nivelInst"],
      "telfCel": data["telfCel"],
      "telfDomi": data["telfDomi"],
      "telfTrab": data["telfTrab"],
      "nombreRef": data["nombreRef"],
      "parentescoRef": data["parentescoRef"],
      "telfRef": data["telfRef"],
    });

    return datos;
  }

  Future<SitFamiliarModel> cargarSFId(String idf, String idS) async {
    SitFamiliarModel situacionF = new SitFamiliarModel();
    final doc =
        await refForm.doc(idf).collection('situacionFamiliar').doc(idS).get();
    var data = doc.data() as Map<String, dynamic>;

    situacionF = SitFamiliarModel.fromJson({
      "id": data["id"],
      "nombreFam1": data["nombreFam1"],
      "edadFam1": data["edadFam1"],
      "parentescoFam1": data["parentescoFam1"],
      "nombreFam2": data["nombreFam2"],
      "edadFam2": data["edadFam2"],
      "parentescoFam2": data["parentescoFam2"],
      "nombreFam3": data["nombreFam3"],
      "edadFam3": data["edadFam3"],
      "parentescoFam3": data["parentescoFam3"],
      "nombreFam4": data["nombreFam4"],
      "edadFam4": data["edadFam4"],
      "parentescoFam4": data["parentescoFam4"],
      "esperaBebe": data["esperaBebe"],
      "alergiaAnimal": data["alergiaAnimal"],
    });

    return situacionF;
  }

  Future<DomicilioModel> cargarDomId(String idf, String idDom) async {
    DomicilioModel domicilio = new DomicilioModel();
    final doc = await refForm.doc(idf).collection('domicilio').doc(idDom).get();
    var data = doc.data() as Map<String, dynamic>;

    domicilio = DomicilioModel.fromJson({
      "id": data["id"],
      "tipoInmueble": data["tipoInmueble"],
      "m2": data["m2"].toDouble(),
      "inmueble": data["inmueble"],
      "nombreD": data["nombreD"],
      "telfD": data["telfD"],
      "planMudanza": data["planMudanza"],
      "cerramiento": data["cerramiento"],
      "alturaC": data["alturaC"].toDouble(),
      "materialC": data["materialC"],
      "especieAd": data["especieAd"],
      "sexoAd": data["sexoAd"],
      "edadAd": data["edadAd"],
      "tamanioAd": data["tamanioAd"],
    });

    return domicilio;
  }

  Future<RelacionAnimalesModel> cargarRAId(String idf, String idRA) async {
    RelacionAnimalesModel relaciones = new RelacionAnimalesModel();
    final doc =
        await refForm.doc(idf).collection('relacionAnimal').doc(idRA).get();
    var data = doc.data() as Map<String, dynamic>;

    relaciones = RelacionAnimalesModel.fromJson({
      "id": data["id"],
      "tipoMs1": data["tipoMs1"],
      "nombreMs1": data["nombreMs1"],
      "sexoMs1": data["sexoMs1"],
      "estMs1": data["estMs1"],
      "tipoMs2": data["tipoMs2"],
      "nombreMs2": data["nombreMs2"],
      "sexoMs2": data["sexoMs2"],
      "estMs2": data["estMs2"],
      "ubicMascota": data["ubicMascota"],
      "deseoAdop": data["deseoAdop"],
      "cambioDomi": data["cambioDomi"],
      "relNuevaCasa": data["relNuevaCasa"],
      "viajeMascota": data["viajeMascota"],
      "tiempoSolaMas": data["tiempoSolaMas"],
      "diaNocheMas": data["diaNocheMas"],
      "duermeMas": data["duermeMas"],
      "necesidadMas": data["necesidadMas"],
      "comidaMas": data["comidaMas"],
      "promedVida": data["promedVida"],
      "enfermedadMas": data["enfermedadMas"],
      "responGastos": data["responGastos"],
      "dineroMas": data["dineroMas"],
      "recursoVet": data["recursoVet"],
      "visitaPer": data["visitaPer"],
      "justificacion1": data["justificacion1"],
      "acuerdoEst": data["acuerdoEst"],
      "justificacion2": data["justificacion2"],
      "benefEst": data["benefEst"],
      "tenenciaResp": data["tenenciaResp"],
      "ordenMuni": data["ordenMuni"],
      "adCompart": data["adCompart"],
      "famAcuerdo": data["famAcuerdo"],
    });

    return relaciones;
  }

  Future<List<Future<FormulariosModel>>> cargarInfo() async {
    final List<FormulariosModel> formularios = <FormulariosModel>[];
    var documents = await refForm.where('estado', isEqualTo: 'Aprobado').get();
    //citas.addAll
    var s = (documents.docs.map((e) async {
      var data = e.data() as Map<String, dynamic>;
      AnimalModel anim = new AnimalModel();
      anim = await animalesProvider.cargarAnimalId(e["idAnimal"]);
      var formulario = FormulariosModel.fromJson({
        "id": e.id,
        "idAnimal": e["idAnimal"],
        "fechaIngreso": e["fechaIngreso"],
        "fechaRespuesta": e["fechaRespuesta"],
        "idClient": e["idClient"],
        "nombreClient": e["nombreClient"],
        "identificacion": e["identificacion"],
        "emailClient": e["emailClient"],
        "estado": e["estado"],
        "observacion": e["observacion"],
        "idDatosPersonales": e["idDatosPersonales"],
        "idSituacionFam": e["idSituacionFam"],
        "idDomicilio": e["idDomicilio"],
        "idRelacionAn": e["idRelacionAn"],
        "idVacuna": e["idVacuna"],
        "idDesparasitacion": e["idDesparasitacion"],
        "idEvidencia": e["idEvidencia"],
      });
      //cita.horario = h1;
      formulario.animal = anim;
      return formulario;
    }));
    return s.toList();
  }

  Future<List<Future<FormulariosModel>>> cargarInfoR() async {
    final List<FormulariosModel> formularios = <FormulariosModel>[];
    var documents = await refForm.where('estado', isEqualTo: 'Negado').get();
    //citas.addAll
    var s = (documents.docs.map((e) async {
      var data = e.data() as Map<String, dynamic>;
      AnimalModel anim = new AnimalModel();
      anim = await animalesProvider.cargarAnimalId(e["idAnimal"]);
      var formulario = FormulariosModel.fromJson({
        "id": e.id,
        "idAnimal": e["idAnimal"],
        "fechaIngreso": e["fechaIngreso"],
        "fechaRespuesta": e["fechaRespuesta"],
        "idClient": e["idClient"],
        "nombreClient": e["nombreClient"],
        "identificacion": e["identificacion"],
        "emailClient": e["emailClient"],
        "estado": e["estado"],
        "observacion": e["observacion"],
        "idDatosPersonales": e["idDatosPersonales"],
        "idSituacionFam": e["idSituacionFam"],
        "idDomicilio": e["idDomicilio"],
        "idRelacionAn": e["idRelacionAn"],
        "idVacuna": e["idVacuna"],
        "idDesparasitacion": e["idDesparasitacion"],
        "idEvidencia": e["idEvidencia"],
      });
      //cita.horario = h1;
      formulario.animal = anim;
      return formulario;
    }));
    return s.toList();
  }

  Future<List<RegistroVacunasModel>> cargarVacunas(String idForm) async {
    final List<RegistroVacunasModel> vacunas = <RegistroVacunasModel>[];
    var documents = await refForm
        .doc(idForm)
        .collection('registroVacunas')
        .orderBy('fechaConsulta')
        .get();
    vacunas.addAll(documents.docs.map((e) {
      var data = e.data() as Map<String, dynamic>;
      var vacuna = RegistroVacunasModel.fromJson({
        "id": e.id,
        "fechaConsulta": e["fechaConsulta"],
        "pesoActual": e["pesoActual"],
        "fechaProximaVacuna": e["fechaProximaVacuna"],
        "tipoVacuna": e["tipoVacuna"],
        "veterinarioResp": e["veterinarioResp"],
      });
      return vacuna;
    }).toList());
    return vacunas;
  }

  Future<List<RegistroDesparasitacionModel>> cargarRegDesp(
      String idForm) async {
    final List<RegistroDesparasitacionModel> desparasitaciones =
        <RegistroDesparasitacionModel>[];
    var documents = await refForm
        .doc(idForm)
        .collection('registroDesparasitacion')
        .orderBy('fecha')
        .get();
    desparasitaciones.addAll(documents.docs.map((e) {
      var data = e.data() as Map<String, dynamic>;
      var desparasitacion = RegistroDesparasitacionModel.fromJson({
        "id": e.id,
        "fecha": e["fecha"],
        "nombreProducto": e["nombreProducto"],
        "pesoActual": e["pesoActual"],
        "fechaProxDesparasitacion": e["fechaProxDesparasitacion"],
      });
      return desparasitacion;
    }).toList());
    return desparasitaciones;
  }

  Future<List<EvidenciasModel>> cargarEvidenciaF(String idForm) async {
    final List<EvidenciasModel> evidenciaF = <EvidenciasModel>[];
    var documents = await refForm.doc(idForm).collection('evidencias').get();
    evidenciaF.addAll(documents.docs.map((e) {
      var data = e.data() as Map<String, dynamic>;
      var evidencia = EvidenciasModel.fromJson({
        "id": e.id,
        "fecha": e["fecha"],
        "fotoUrl": e["fotoUrl"],
        "archivoUrl": e["archivoUrl"],
        "nombreArchivo": e["nombreArchivo"],
      });
      return evidencia;
    }).toList());
    return evidenciaF;
  }

  Future<List<EvidenciasModel>> cargarEvidenciaA(String idForm) async {
    final List<EvidenciasModel> evidenciaF = <EvidenciasModel>[];
    var documents = await refForm
        .doc(idForm)
        .collection('evidencias')
        // .where("nombreArchivo", "", )
        .get();
    evidenciaF.addAll(documents.docs.map((e) {
      var data = e.data() as Map<String, dynamic>;
      var evidencia = EvidenciasModel.fromJson({
        "id": e.id,
        "fecha": e["fecha"],
        "fotoUrl": e["fotoUrl"],
        "archivoUrl": e["archivoUrl"],
        "nombreArchivo": e["nombreArchivo"],
      });
      return evidencia;
    }).toList());
    return evidenciaF;
  }

  Future<bool> editarEstado(FormulariosModel formulario, String estado) async {
    try {
      await refForm.doc(formulario.id).update({"estado": estado});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editarFechaRespuesta(
      FormulariosModel formulario, String fecha) async {
    try {
      await refForm.doc(formulario.id).update({"fechaRespuesta": fecha});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editarObservacion(
      FormulariosModel formulario, String observacion) async {
    try {
      await refForm.doc(formulario.id).update({"observacion": observacion});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> crearFormularioPrin1(
      FormulariosModel formulario, DatosPersonalesModel datosPersona) async {
    try {
      var formularioAdd = await refForm.add(formulario.toJson());
      await refForm.doc(formularioAdd.id).update({"id": formularioAdd.id});
      CollectionReference refFormDP = FirebaseFirestore.instance
          .collection('formularios')
          .doc(formularioAdd.id)
          .collection('datosPersonales');
      var datosPersonalesAdd = await refFormDP.add(datosPersona.toJson());
      await refFormDP
          .doc(datosPersonalesAdd.id)
          .update({"id": datosPersonalesAdd.id});

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> crearFormSituacionFam(
      SitFamiliarModel sitFamilia, var idFormu, BuildContext context) async {
    CollectionReference refFormSF = FirebaseFirestore.instance
        .collection('formularios')
        .doc(idFormu)
        .collection('situacionFamiliar');
    try {
      var sitFamiliarAdd = await refFormSF.add(sitFamilia.toJson());
      await refFormSF.doc(sitFamiliarAdd.id).update({"id": sitFamiliarAdd.id});
      var idFormu1 = idFormu;
      Navigator.pushNamed(context, 'formularioP3', arguments: idFormu1);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> crearFormDomicilio(
      DomicilioModel domicilio, var idFormu1, BuildContext context) async {
    CollectionReference refFormDom = FirebaseFirestore.instance
        .collection('formularios')
        .doc(idFormu1)
        .collection('domicilio');
    try {
      var domicilioAdd = await refFormDom.add(domicilio.toJson());
      await refFormDom.doc(domicilioAdd.id).update({"id": domicilioAdd.id});
      var idFormu2 = idFormu1;
      Navigator.pushNamed(context, 'formularioP4', arguments: idFormu2);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> crearFormRelacionAnim(RelacionAnimalesModel relacionA,
      var idFormu2, BuildContext context) async {
    CollectionReference refFormRel = FirebaseFirestore.instance
        .collection('formularios')
        .doc(idFormu2)
        .collection('relacionAnimal');
    try {
      var relacionAnimAdd = await refFormRel.add(relacionA.toJson());
      await refFormRel
          .doc(relacionAnimAdd.id)
          .update({"id": relacionAnimAdd.id});
      Navigator.pushNamed(context, 'home');
      return true;
    } catch (e) {
      return false;
    }
  }
}
