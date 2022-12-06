import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_relacionAnimal_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/providers/formularios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class RelacionAnimalPage extends StatefulWidget {
  const RelacionAnimalPage({Key? key}) : super(key: key);

  @override
  State<RelacionAnimalPage> createState() => _RelacionAnimalPageState();
}

class _RelacionAnimalPageState extends State<RelacionAnimalPage> {
  FormulariosModel formularios = new FormulariosModel();
  //DatosPersonalesModel datosA = new DatosPersonalesModel();
  RelacionAnimalesModel relaciones = new RelacionAnimalesModel();
  final formKey = GlobalKey<FormState>();
  final formulariosProvider = new FormulariosProvider();
  //final horariosProvider = new HorariosProvider();
  // final animalesProvider = new AnimalesProvider();
  final userProvider = new UsuarioProvider();
  var idForm;
  var idD;

  @override
  void initState() {
    super.initState();
    //showCitas();
  }

  @override
  Widget build(BuildContext context) {
    // final Object? formulariosData = ModalRoute.of(context)!.settings.arguments;
    // if (formulariosData != null) {
    //   relaciones = formulariosData as RelacionAnimalesModel;
    //   print(relaciones.id);
    // }
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    //if (dat == arg['datosper']) {
    //print(formularios.idDatosPersonales);
    relaciones = arg['relacionAn'] as RelacionAnimalesModel;
    print(relaciones.id);
    formularios = arg['formulario'] as FormulariosModel;
    print(formularios.id);
    return Scaffold(
      backgroundColor: Color.fromARGB(223, 248, 248, 245),
      appBar: AppBar(
        title: Text('Relación con los animales'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: Icon(Icons.account_circle),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      child: Text("Soporte"),
                      value: 0,
                    ),
                    PopupMenuItem<int>(
                      child: Text("Cerrar Sesión"),
                      value: 1,
                    )
                  ]),
        ],
      ),
      drawer: MenuWidget(),
      body: Stack(
        children: [
          //Background(),
          SingleChildScrollView(
            child: Flexible(
              fit: FlexFit.loose,
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Liste sus dos últimas mascotas',
                          style: TextStyle(
                            fontSize: 22,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.blueGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Divider(),
                      Align(
                        alignment: Alignment.topCenter,
                        child: DataTable(
                          sortColumnIndex: 2,
                          columnSpacing: 25,
                          sortAscending: false,
                          columns: [
                            DataColumn(label: Text("Tipo")),
                            DataColumn(label: Text("Nombre")),
                            DataColumn(label: Text("Sexo")),
                            DataColumn(label: Text("Esterilizado")),
                          ],
                          rows: [
                            DataRow(selected: true, cells: [
                              DataCell(_mostrarTipo1()),
                              DataCell(_mostrarNombre1()),
                              DataCell(_mostrarSexo1()),
                              DataCell(_mostrarEsteriliza1())
                            ]),
                            DataRow(cells: [
                              DataCell(_mostrarTipo2()),
                              DataCell(_mostrarNombre2()),
                              DataCell(_mostrarSexo2()),
                              DataCell(_mostrarEsteriliza2())
                            ]),
                          ],
                        ),
                      ),
                      Divider(),
                      Divider(color: Colors.transparent),

                      Text(
                        '¿Dónde está ahora? Si falleció, perdió o está en otro lugar, indique la causa.',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarUbicMascota(),
                      Divider(color: Colors.transparent),

                      Text(
                        '¿Por qué desea adoptar una mascota?',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarDeseaAdop(),
                      Divider(color: Colors.transparent),
                      Text(
                        'Si por algún motivo tuviera que cambiar de domicilio, ¿Qué pasaría con su mascota?',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarCambioDomi(),
                      Divider(color: Colors.transparent),
                      Text(
                        'Con relación a la anterior pregunta ¿Qué pasaría si los dueños de la nueva casa no aceptacen mascotas?',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarRelNuevaCasa(),
                      Divider(color: Colors.transparent),
                      Text(
                        'Si Ud. debe salir de viaje más de un día, la mascota:',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarViajeMasc(),
                      Divider(color: Colors.transparent),
                      Text(
                        '¿Cuánto tiempo en el día pasará sola la mascota?',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarTiempoSola(),
                      Divider(color: Colors.transparent),
                      Text(
                        '¿Dónde pasará durante el día y la noche?',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarDiaNoche(),
                      Divider(color: Colors.transparent),
                      Text(
                        '¿Dónde dormirá la mascota?',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarDondeDormir(),
                      Divider(color: Colors.transparent),
                      Text(
                        '¿Dónde hará sus necesidades?',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarDondeNecesidad(),
                      Divider(color: Colors.transparent),
                      Text(
                        '¿Qué comerá habitualmente la mascota?',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarComidaMas(),
                      Divider(color: Colors.transparent),
                      Text(
                        '¿Cuántos años cree que vive un perro promedio?',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarPromedioVida(),
                      Divider(color: Colors.transparent),
                      Text(
                        'Si su mascota se enferma usted:',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarMascotaEnferma(),
                      Divider(color: Colors.transparent),
                      Text(
                        '¿Quién será el responsable y se hará cargo de cubrir los gastos de la mascota?',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarResponsableMas(),
                      Divider(color: Colors.transparent),
                      Text(
                        'Estime cuánto dinero podría gastar en su mascota mensualmente',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarDineroGasto(),
                      Divider(color: Colors.transparent),
                      Text(
                        '¿Cuenta con los recursos para cubrir los gastos veterinarios del animal de companía?',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarRecursosVet(),
                      Divider(color: Colors.transparent),
                      Divider(),
                      Text(
                        '¿Está de acuerdo en que se haga una visita periódica a su domicilio para ver como se encuentra el adoptado?',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.justify,
                      ),
                      Divider(),
                      _mostrarVisitaDomicilio(),
                      _mostrarJustificacion1(),
                      Divider(),
                      Text(
                        '¿Está de acuerdo en que la mascota sea esterilizada?',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.justify,
                      ),
                      Divider(),
                      _mostrarAcuerdoEst(),
                      _mostrarJustificacion2(),
                      Divider(),
                      Text(
                        '¿Conoce usted los beneficios de la esterilización?',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarBeneficios(),
                      Divider(color: Colors.transparent),
                      Text(
                        '¿Según usted que es tenencia responsable?',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarTenencia(),
                      Divider(color: Colors.transparent),
                      //pregunta de ordenanza
                      Text(
                        '¿Está Ud. informado y conciente sobre la ordenanza municipal sobre la tenencia responsable de mascotas?',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarOrdenMuni(),
                      Divider(color: Colors.transparent),
                      Text(
                        '¿La adopción fue compartida con su familia?',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarAdopcionFam(),
                      Divider(color: Colors.transparent),
                      Text(
                        'Su familia esta:',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.justify,
                      ),
                      _mostrarFamilia(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _botonAtras(),
                          _botonSiguiente(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.pushNamed(context, 'soporte');
        break;
      case 1:
        userProvider.signOut();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      //Navigator.pushNamed(context, 'login');
    }
  }

  Widget _mostrarTipo1() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.tipoMs1,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarTipo2() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.tipoMs2,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarNombre1() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.nombreMs1,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarNombre2() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.nombreMs2,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarSexo1() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.sexoMs1,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarSexo2() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.sexoMs2,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarEsteriliza1() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.estMs1,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarEsteriliza2() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.estMs2,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarUbicMascota() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.ubicMascota,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "Algun familiar espera un bebe?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarDeseaAdop() {
    return TextFormField(
      maxLines: 2,
      readOnly: true,
      initialValue: relaciones.deseoAdop,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "Algun familiar espera un bebe?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarCambioDomi() {
    return TextFormField(
      maxLines: 1,
      readOnly: true,
      initialValue: relaciones.cambioDomi,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "Algun familiar espera un bebe?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarRelNuevaCasa() {
    return TextFormField(
      maxLines: 1,
      readOnly: true,
      initialValue: relaciones.relNuevaCasa,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "Si usted debe salir de viaje mas de un dia, la mascota:",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarViajeMasc() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.viajeMascota,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "Si usted debe salir de viaje mas de un dia, la mascota:",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarTiempoSola() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.tiempoSolaMas,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "¿Cuánto tiempo en el dia pasará sola la mascota?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarDiaNoche() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.diaNocheMas,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "¿Dónde pasará durante el día y la noche?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarDondeDormir() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.duermeMas,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "¿Dónde dormirá la mascota?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarDondeNecesidad() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.necesidadMas,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "¿Dónde hará sus necesidades?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarComidaMas() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.comidaMas,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "¿Qué comerá habitualmente la mascota?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarPromedioVida() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.promedVida,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "¿Cuantos años cree que vive un perro promedio?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarMascotaEnferma() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.enfermedadMas,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "Si su mascota se enferma usted:",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarResponsableMas() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.responGastos,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "¿Dónde hará sus necesidades?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarDineroGasto() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.dineroMas,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarRecursosVet() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.recursoVet,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "¿Dónde hará sus necesidades?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarVisitaDomicilio() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.visitaPer,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "¿Dónde hará sus necesidades?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarJustificacion1() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.justificacion1,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "¿Por qué?",
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarAcuerdoEst() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.acuerdoEst,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "¿Dónde hará sus necesidades?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarJustificacion2() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.justificacion2,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "¿Por qué?",
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarBeneficios() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.benefEst,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "¿Conoce usted los beneficios de la esterilización?",
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarTenencia() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.tenenciaResp,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "¿Según usted que es tenecia responsable?",
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarOrdenMuni() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.ordenMuni,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "¿Conoce usted los beneficios de la esterilización?",
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarAdopcionFam() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.adCompart,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "¿La adopción fue compartida con su familia?",
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _mostrarFamilia() {
    return TextFormField(
      readOnly: true,
      initialValue: relaciones.famAcuerdo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "Su familia esta:",
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _botonSiguiente() {
    return Ink(
        padding: EdgeInsets.only(left: 50.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: Icon(
            Icons.arrow_right_sharp,
          ),
          iconSize: 100,
          color: Colors.green[400],
          onPressed: () async {
            Navigator.pushNamed(context, 'observacionSolicitud',
                arguments: formularios);
          },
        ));
  }

  Widget _botonAtras() {
    return Ink(
        padding: EdgeInsets.only(left: 50.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          padding: EdgeInsets.only(right: 20),
          //tooltip: 'Siguiente',
          icon: Icon(Icons.arrow_left_sharp),
          iconSize: 100,
          color: Colors.green[400],
          onPressed: () async {
            Navigator.pop(context);
          },
        ));
  }
}
