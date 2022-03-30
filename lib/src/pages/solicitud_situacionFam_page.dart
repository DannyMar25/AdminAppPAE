import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_domicilio_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_relacionAnimal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_situacionFam_model.dart';
import 'package:aministrador_app_v1/src/providers/formularios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/background.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class SituacionFamiliarPage extends StatefulWidget {
  const SituacionFamiliarPage({Key? key}) : super(key: key);

  @override
  State<SituacionFamiliarPage> createState() => _SituacionFamiliarPageState();
}

class _SituacionFamiliarPageState extends State<SituacionFamiliarPage> {
  FormulariosModel formularios = new FormulariosModel();
  DatosPersonalesModel datosA = new DatosPersonalesModel();
  SitFamiliarModel situacionF = new SitFamiliarModel();
  DomicilioModel domicilio = new DomicilioModel();
  RelacionAnimalesModel relacionAn = new RelacionAnimalesModel();
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
    //   situacionF = formulariosData as SitFamiliarModel;
    //   print(situacionF.id);
    //   //print(formularios.idDatosPersonales);
    // }
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    //if (dat == arg['datosper']) {
    situacionF = arg['situacionF'] as SitFamiliarModel;
    print(situacionF.id);
    //print(formularios.idDatosPersonales);
    domicilio = arg['domicilio'] as DomicilioModel;
    formularios = arg['formulario'] as FormulariosModel;
    relacionAn = arg['relacionAn'] as RelacionAnimalesModel;
    datosA = arg['datosper'] as DatosPersonalesModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitudes'),
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: Icon(Icons.manage_accounts),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      child: Text("Informacion"),
                      value: 0,
                    ),
                    PopupMenuItem<int>(
                      child: Text("Ayuda"),
                      value: 1,
                    ),
                    PopupMenuItem<int>(
                      child: Text("Cerrar Sesion"),
                      value: 2,
                    )
                  ]),
        ],
      ),
      drawer: MenuWidget(),
      body: Stack(children: [
        Background(),
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    'Mencione las personas con las que vive',
                    style: TextStyle(
                      fontSize: 22,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.orange[100]!,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Divider(),
                  DataTable(
                    sortColumnIndex: 2,
                    sortAscending: false,
                    columns: [
                      DataColumn(label: Text("Nombre")),
                      DataColumn(label: Text("Edad "), numeric: true),
                      DataColumn(label: Text("Parentesco")),
                    ],
                    rows: [
                      DataRow(selected: true, cells: [
                        DataCell(_mostrarNombreF1()),
                        DataCell(_mostrarEdadF1()),
                        DataCell(_mostrarParentesco1()),
                      ]),
                      DataRow(cells: [
                        DataCell(_mostrarNombreF2()),
                        DataCell(_mostrarEdadF2()),
                        DataCell(_mostrarParentesco2()),
                      ]),
                      DataRow(cells: [
                        DataCell(_mostrarNombreF3()),
                        DataCell(_mostrarEdadF3()),
                        DataCell(_mostrarParentesco3()),
                      ]),
                      DataRow(cells: [
                        DataCell(_mostrarNombreF4()),
                        DataCell(_mostrarEdadF4()),
                        DataCell(_mostrarParentesco4()),
                      ])
                    ],
                  ),
                  Divider(),
                  Text(
                    'Algun familiar espera un bebe?',
                    style: TextStyle(
                      fontSize: 22,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.orange[100]!,
                    ),
                  ),
                  Divider(),
                  _mostrarEsperabebe(),
                  Text(
                    'Alguien que viva con usted es alergico a los animales o sufre de asma?',
                    style: TextStyle(
                      fontSize: 22,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.orange[100]!,
                    ),
                  ),
                  Divider(),
                  _mostrarAlergia(),
                  Divider(),
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
      ]),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        userProvider.signOut();
        Navigator.pushNamed(context, 'login');
    }
  }

  Widget _mostrarNombreF1() {
    return TextFormField(
      readOnly: true,
      initialValue: situacionF.nombreFam1,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarNombreF2() {
    return TextFormField(
      readOnly: true,
      initialValue: situacionF.nombreFam2,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarNombreF3() {
    return TextFormField(
      readOnly: true,
      initialValue: situacionF.nombreFam3,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarNombreF4() {
    return TextFormField(
      readOnly: true,
      initialValue: situacionF.nombreFam4,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarEdadF1() {
    return TextFormField(
      readOnly: true,
      initialValue: situacionF.edadFam1.toString(),
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarEdadF2() {
    return TextFormField(
      readOnly: true,
      initialValue: situacionF.edadFam2.toString(),
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarEdadF3() {
    return TextFormField(
      readOnly: true,
      initialValue: situacionF.edadFam3.toString(),
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarEdadF4() {
    return TextFormField(
      readOnly: true,
      initialValue: situacionF.edadFam4.toString(),
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarParentesco1() {
    return TextFormField(
      readOnly: true,
      initialValue: situacionF.parentescoFam1,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarParentesco2() {
    return TextFormField(
      readOnly: true,
      initialValue: situacionF.parentescoFam2,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarParentesco3() {
    return TextFormField(
      readOnly: true,
      initialValue: situacionF.parentescoFam3,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarParentesco4() {
    return TextFormField(
      readOnly: true,
      initialValue: situacionF.parentescoFam4,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarEsperabebe() {
    return TextFormField(
      readOnly: true,
      initialValue: situacionF.esperaBebe,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "Algun familiar espera un bebe?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarAlergia() {
    return TextFormField(
      readOnly: true,
      initialValue: situacionF.alergiaAnimal,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        //labelText: "Alguien que viva con usted es alergico a los animales ?",
        icon: Icon(
          Icons.question_answer,
          color: Colors.purple,
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
            color: Colors.lightBlue[300],
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          icon: Icon(
            Icons.arrow_right_sharp,
          ),
          iconSize: 100,
          color: Colors.lightBlue[300],
          onPressed: () async {
            Navigator.pushNamed(context, 'domicilio', arguments: {
              'domicilio': domicilio,
              'relacionAn': relacionAn,
              'formulario': formularios,
            });
          },
        ));
  }

  Widget _botonAtras() {
    return Ink(
        padding: EdgeInsets.only(left: 50.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            color: Colors.lightBlue[300],
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ]),
        child: IconButton(
          padding: EdgeInsets.only(right: 20),
          //tooltip: 'Siguiente',
          icon: Icon(Icons.arrow_left_sharp),
          iconSize: 100,
          color: Colors.lightBlue[300],
          onPressed: () async {
            Navigator.pop(context);
          },
        ));
  }
}