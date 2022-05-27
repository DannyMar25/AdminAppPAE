import 'package:aministrador_app_v1/src/models/formulario_datosPersonales_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_domicilio_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_principal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_relacionAnimal_model.dart';
import 'package:aministrador_app_v1/src/models/formulario_situacionFam_model.dart';
import 'package:aministrador_app_v1/src/providers/formularios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class DatosPersonalesPage extends StatefulWidget {
  const DatosPersonalesPage({Key? key}) : super(key: key);

  @override
  State<DatosPersonalesPage> createState() => _DatosPersonalesPageState();
}

class _DatosPersonalesPageState extends State<DatosPersonalesPage> {
  FormulariosModel formularios = new FormulariosModel();
  DatosPersonalesModel datosA = new DatosPersonalesModel();
  SitFamiliarModel situacionF = new SitFamiliarModel();
  DomicilioModel domicilio = new DomicilioModel();
  RelacionAnimalesModel relacionAn = new RelacionAnimalesModel();
  DatosPersonalesModel datosC = new DatosPersonalesModel();
  final formKey = GlobalKey<FormState>();
  final formulariosProvider = new FormulariosProvider();
  //final horariosProvider = new HorariosProvider();
  // final animalesProvider = new AnimalesProvider();
  final userProvider = new UsuarioProvider();
  var idForm;
  var idD;
  Object? dat;
  @override
  void initState() {
    super.initState();
    //showCitas();
  }

  @override
  Widget build(BuildContext context) {
    // showCitas();
    // print(datosA.nombreCom);
    // var nombre1 = datosA.nombreCom;
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    //if (dat == arg['datosper']) {
    datosA = arg['datosper'] as DatosPersonalesModel;
    print(datosA.id);
    //print(formularios.idDatosPersonales);
    situacionF = arg['sitfam'] as SitFamiliarModel;
    domicilio = arg['domicilio'] as DomicilioModel;
    relacionAn = arg['relacionAn'] as RelacionAnimalesModel;
    formularios = arg['formulario'] as FormulariosModel;

    // }

    //var nombre1 = datosA.nombreCom;
    return Scaffold(
      backgroundColor: Color.fromARGB(223, 221, 248, 153),
      appBar: AppBar(
        title: Text('Datos personales'),
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
          //Background(),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text('Datos personales',
                        style: TextStyle(
                          fontSize: 22,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.blueGrey,
                        )),
                    Divider(),
                    _mostrarNombreCom(),
                    _mostrarCI(),
                    _mostrarDireccion(),
                    _mostrarEdad(),
                    _mostrarOcupacion(),
                    _mostrarEmail(),
                    Divider(),
                    Text('Instruccion',
                        style: TextStyle(
                          fontSize: 22,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.blueGrey,
                        )),
                    Divider(),
                    _mostrarNivelInstruccion(),
                    Divider(),
                    Text('Telefonos de contacto',
                        style: TextStyle(
                          fontSize: 22,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.blueGrey,
                        )),
                    Divider(),
                    _mostrarTelfCel(),
                    _mostrarTelfDom(),
                    _mostrarTelfTrab(),
                    Divider(),
                    Text('Referencias personales',
                        style: TextStyle(
                          fontSize: 22,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.blueGrey,
                        )),
                    Divider(),
                    _mostrarNombreRef(),
                    _mostrarParentesco(),
                    _mostrarTelfRef(),
                    Divider(
                      color: Colors.transparent,
                    ),
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

  Widget _mostrarNombreCom() {
    return TextFormField(
      readOnly: true,
      initialValue: datosA.nombreCom,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Nombre Completo",
        icon: Icon(
          Icons.person,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarCI() {
    return TextFormField(
      readOnly: true,
      initialValue: datosA.cedula,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Cedula",
        icon: Icon(
          Icons.assignment_ind,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarDireccion() {
    return TextFormField(
      readOnly: true,
      initialValue: datosA.direccion,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Direccion exacta donde estara la mascota",
        icon: Icon(
          Icons.place,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarEdad() {
    return TextFormField(
      readOnly: true,
      initialValue: datosA.edad.toString(),
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Edad",
        icon: Icon(
          Icons.person,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarOcupacion() {
    return TextFormField(
      readOnly: true,
      initialValue: datosA.ocupacion,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Ocupacion",
        icon: Icon(
          Icons.work,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarEmail() {
    return TextFormField(
      readOnly: true,
      initialValue: datosA.email,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "E-mail",
        icon: Icon(
          Icons.mail,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarNivelInstruccion() {
    return TextFormField(
      readOnly: true,
      initialValue: datosA.nivelInst,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Nivel de instruccion",
        icon: Icon(
          Icons.school,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarTelfCel() {
    return TextFormField(
      readOnly: true,
      initialValue: datosA.telfCel,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Celular",
        icon: Icon(
          Icons.phone_android,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarTelfDom() {
    return TextFormField(
      readOnly: true,
      initialValue: datosA.telfDomi,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Domicilio",
        icon: Icon(
          Icons.phone,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarTelfTrab() {
    return TextFormField(
      readOnly: true,
      initialValue: datosA.telfTrab,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Trabajo",
        icon: Icon(
          Icons.phone,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarNombreRef() {
    return TextFormField(
      readOnly: true,
      initialValue: datosA.nombreRef,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Nombre",
        icon: Icon(
          Icons.person,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarParentesco() {
    return TextFormField(
      readOnly: true,
      initialValue: datosA.parentescoRef,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Parentesco",
        icon: Icon(
          Icons.person,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _mostrarTelfRef() {
    return TextFormField(
      readOnly: true,
      initialValue: datosA.telfRef,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Telefono",
        icon: Icon(
          Icons.phone,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _botonSiguiente() {
    return Ink(
        padding: EdgeInsets.only(left: 50.0),
        decoration: BoxDecoration(
            //borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            //color: Color.fromARGB(223, 221, 248, 153),
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
          icon: Icon(
            Icons.arrow_right_sharp,
          ),
          iconSize: 100,
          color: Colors.lightBlue[300],
          onPressed: () async {
            Navigator.pushNamed(context, 'situacionFam', arguments: {
              'datosper': datosA,
              'situacionF': situacionF,
              'domicilio': domicilio,
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
            //borderRadius: BorderRadius.all(Radius.circular(8)),
            shape: BoxShape.rectangle,
            //color: Color.fromARGB(223, 221, 248, 153),
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
          color: Colors.lightBlue[300],
          onPressed: () async {
            Navigator.pushNamed(context, 'verSolicitudesMain',
                arguments: formularios);
          },
        ));
  }
}
