import 'package:aministrador_app_v1/src/models/formulario_domicilio_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_relacionAnimal_model.dart';
import 'package:aministrador_app_v1/src/providers/formularios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/background.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class DomicilioPage extends StatefulWidget {
  const DomicilioPage({Key? key}) : super(key: key);

  @override
  State<DomicilioPage> createState() => _DomicilioPageState();
}

class _DomicilioPageState extends State<DomicilioPage> {
  FormulariosModel formularios = new FormulariosModel();
  //DatosPersonalesModel datosA = new DatosPersonalesModel();
  DomicilioModel domicilios = new DomicilioModel();
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
    //   domicilios = formulariosData as DomicilioModel;
    //   print(domicilios.id);
    // }
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    //if (dat == arg['datosper']) {
    domicilios = arg['domicilio'] as DomicilioModel;
    print(domicilios.id);
    //print(formularios.idDatosPersonales);
    relacionAn = arg['relacionAn'] as RelacionAnimalesModel;
    formularios = arg['formulario'] as FormulariosModel;
    print(formularios.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitudes'),
        backgroundColor: Colors.green,
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
      body: Stack(
        children: [
          Background(),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text(
                      'Que tipo de inmueble posee?',
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
                    _mostrarTipoInmueble(),
                    _mostrarM2(),
                    Divider(),
                    _mostrarInmueble(),
                    Divider(),
                    Text(
                      'Planea mudarse proximamente?',
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
                    _mostrarPlanMudanza(),
                    Divider(),
                    Text(
                      'El lugar donde pasara la mascota, tiene cerramiento?',
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
                    _mostrarCerramiento(),
                    Divider(),
                    Text(
                      'Cual piensa que es la mascota mas adecuada para Ud.?',
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
                        DataColumn(label: Text("Sexo")),
                        DataColumn(label: Text("Edad "), numeric: true),
                        DataColumn(label: Text("Tamaño")),
                      ],
                      rows: [
                        DataRow(selected: true, cells: [
                          DataCell(_mostrarSexo()),
                          DataCell(_mostrarEdad()),
                          DataCell(_mostrarTamano()),
                        ]),
                      ],
                    ),
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
        ],
      ),
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

  Widget _mostrarTipoInmueble() {
    return TextFormField(
      readOnly: true,
      initialValue: domicilios.tipoInmueble.toString(),
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Tipo de inmueble:",
        icon: Icon(
          Icons.house,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarM2() {
    return TextFormField(
      readOnly: true,
      initialValue: domicilios.m2.toString(),
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "m^2:",
        icon: Icon(
          Icons.yard,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarInmueble() {
    if (domicilios.inmueble == 'Propio') {
      return TextFormField(
        readOnly: true,
        initialValue: domicilios.inmueble,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: "El inmueble es:",
          icon: Icon(
            Icons.house,
            color: Colors.purple,
          ),
        ),
      );
    } else {
      return Column(
        children: [
          TextFormField(
            readOnly: true,
            initialValue: domicilios.inmueble,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: "El inmueble es:",
              icon: Icon(
                Icons.house,
                color: Colors.purple,
              ),
            ),
          ),
          _mostrarNombre(),
          _mostrarTelefono()
        ],
      );
    }
  }

  Widget _mostrarNombre() {
    return TextFormField(
      readOnly: true,
      initialValue: domicilios.nombreD,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Nombre:",
        icon: Icon(
          Icons.person,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarTelefono() {
    return TextFormField(
      readOnly: true,
      initialValue: domicilios.telfD,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Telefono:",
        icon: Icon(
          Icons.person,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarPlanMudanza() {
    return TextFormField(
      readOnly: true,
      initialValue: domicilios.planMudanza,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        icon: Icon(
          Icons.question_answer,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarCerramiento() {
    if (domicilios.cerramiento == 'No') {
      return TextFormField(
        readOnly: true,
        initialValue: domicilios.cerramiento,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          icon: Icon(
            Icons.question_answer,
            color: Colors.purple,
          ),
        ),
      );
    } else {
      return Column(
        children: [
          TextFormField(
            readOnly: true,
            initialValue: domicilios.cerramiento,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              icon: Icon(
                Icons.question_answer,
                color: Colors.purple,
              ),
            ),
          ),
          _mostrarAltura(),
          _mostrarMaterial()
        ],
      );
    }
  }

  Widget _mostrarAltura() {
    return TextFormField(
      readOnly: true,
      initialValue: domicilios.alturaC.toString(),
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        label: Text('Altura en m2:'),
        icon: Icon(
          Icons.question_answer,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarMaterial() {
    return TextFormField(
      readOnly: true,
      initialValue: domicilios.materialC,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        label: Text('Material:'),
        icon: Icon(
          Icons.question_answer,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarSexo() {
    return TextFormField(
      readOnly: true,
      initialValue: domicilios.sexoAd,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarEdad() {
    return TextFormField(
      readOnly: true,
      initialValue: domicilios.edadAd,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _mostrarTamano() {
    return TextFormField(
      readOnly: true,
      initialValue: domicilios.tamanioAd,
      textCapitalization: TextCapitalization.sentences,
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
            Navigator.pushNamed(context, 'relacionAnim', arguments: {
              'relacionAn': relacionAn,
              'formulario': formularios
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
