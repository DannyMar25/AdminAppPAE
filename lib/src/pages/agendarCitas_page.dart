import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/models/citas_model.dart';
import 'package:aministrador_app_v1/src/models/horarios_model.dart';
import 'package:aministrador_app_v1/src/providers/citas_provider.dart';
import 'package:aministrador_app_v1/src/providers/horarios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/utils/utils.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AgendarCitasPage extends StatefulWidget {
  //RegistroClienteCitas({Key? key}) : super(key: key);

  @override
  _AgendarCitasPageState createState() => _AgendarCitasPageState();
}

class _AgendarCitasPageState extends State<AgendarCitasPage> {
  late double latitude, longitude;
  late DocumentSnapshot datosUbic;
  List<Marker> myMarker = [];
  final firestoreInstance = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userProvider = new UsuarioProvider();
  CitasModel citas = new CitasModel();
  TextEditingController nombre = new TextEditingController();
  TextEditingController telefono = new TextEditingController();
  TextEditingController correo = new TextEditingController();
  String _fecha = '';
  String _fechaCompleta = '';
  TextEditingController _inputFieldDateController = new TextEditingController();

  //bool _guardando = false;
  //final formKey = GlobalKey<FormState>();
  HorariosModel horarios = new HorariosModel();
  final horariosProvider = new HorariosProvider();
  final citasProvider = new CitasProvider();
  CollectionReference dbRefH =
      FirebaseFirestore.instance.collection('horarios');

  AnimalModel animal = new AnimalModel();
  @override
  Widget build(BuildContext context) {
    final Object? animData = ModalRoute.of(context)!.settings.arguments;
    if (animData != null) {
      animal = animData as AnimalModel;
      print(animal.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar citas'),
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
          // Builder(builder: (BuildContext context) {
          //   return TextButton(
          //     style: ButtonStyle(
          //       foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          //     ),
          //     onPressed: () async {
          //       userProvider.signOut();
          //       Navigator.pushNamed(context, 'login');
          //     },
          //     child: Text('Sign Out'),
          //   );
          // }),
        ],
      ),
      drawer: MenuWidget(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _crearNombre(),
                _crearTelefono(),
                _crearCorreo(),
                Divider(),
                _crearFecha(context),
                Divider(),
                Divider(),
                _verListado(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, 'soporte');
        break;
      case 2:
        userProvider.signOut();
        Navigator.pushNamed(context, 'login');
    }
  }

  Widget _crearFecha(BuildContext context) {
    return TextFormField(
        controller: _inputFieldDateController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          //counter: Text('Letras ${_nombre.length}'),
          //hintText: 'Ingrese fecha de agendamiento de cita',
          labelText: 'Fecha de la cita',
          //helperText: 'Solo es el nombre',
          suffixIcon: Icon(
            Icons.perm_contact_calendar,
            color: Colors.green,
          ),
          icon: Icon(
            Icons.calendar_today,
            color: Colors.green,
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            _selectDate(context);
          });
        });
  }

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime.now(),
      lastDate: new DateTime.now().add(Duration(days: 7)),
      locale: Locale('es', 'ES'),
    );

    if (picked != null) {
      setState(() {
        _fechaCompleta = picked.year.toString() +
            '-' +
            picked.month.toString() +
            '-' +
            picked.day.toString();
        //_fechaCompleta = picked.toString();
        _fecha = picked.weekday.toString();
        if (_fecha == '1') {
          _fecha = 'Lunes';
        }
        if (_fecha == '2') {
          _fecha = 'Martes';
        }
        if (_fecha == '3') {
          _fecha = 'Miercoles';
        }
        if (_fecha == '4') {
          _fecha = 'Jueves';
        }
        if (_fecha == '5') {
          _fecha = 'Viernes';
        }
        if (_fecha == '6') {
          _fecha = 'Sabado';
        }
        if (_fecha == '7') {
          _fecha = 'Domingo';
        }
        //_fecha = DateFormat('EEEE').format(picked);
        _inputFieldDateController.text = _fecha;
      });
    }
  }

  Widget _verListado() {
    return FutureBuilder(
        future:
            horariosProvider.cargarHorariosDia1(_inputFieldDateController.text),
        builder: (BuildContext context,
            AsyncSnapshot<List<HorariosModel>> snapshot) {
          if (snapshot.hasData) {
            final horarios = snapshot.data;
            return SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: horarios!.length,
                  itemBuilder: (context, i) => _crearItem(context, horarios[i]),
                ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(BuildContext context, HorariosModel horario) {
    return Column(
      children: [
        TextFormField(
          readOnly: true,
          onTap: () {
            citas.idHorario = horario.id;
            horariosProvider.editarDisponible(horario);
          },
          initialValue: horario.hora + '  -   ' + horario.disponible,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              //labelText: 'Hora',
              suffixIcon: Icon(Icons.add),
              icon: Icon(Icons.calendar_today)),
        ),
        Divider(color: Colors.white),
      ],
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      //initialValue: animal.nombre,
      controller: nombre,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombre',
      ),
      onSaved: (value) => nombre = value as TextEditingController,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese su nombre';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearTelefono() {
    return TextFormField(
      //initialValue: animal.nombre,
      controller: telefono,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Telefono',
      ),
      onSaved: (value) => telefono = value as TextEditingController,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese su numero de telefono';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearCorreo() {
    return TextFormField(
      //initialValue: animal.nombre,
      controller: correo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Correo',
      ),
      onSaved: (value) => correo = value as TextEditingController,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese su correo electronico';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            return Colors.green;
          }),
        ),
        label: Text('Guardar'),
        icon: Icon(Icons.save),
        autofocus: true,
        onPressed: () {
          _submit();
        }
        // onPressed: () {
        //   print(animal.id);
        // },
        );
  }

  void _submit() async {
    //Guardar datos en base
    citas.nombreClient = nombre.text;
    citas.telfClient = telefono.text;
    citas.correoClient = correo.text;
    citas.fechaCita = _fechaCompleta;
    citas.estado = 'Pendiente';
    if (animal.id == '') {
      citas.idAnimal = 'WCkke2saDQ5AfeJkU6ck';
    } else {
      citas.idAnimal = animal.id!;
    }

    //citas.idHorario = horarios.id;

    if (citas.id == "") {
      citasProvider.crearCita(citas);
      mostrarAlertaOk(
          context, 'La cita ha sido registrada con exito', 'bienvenida');
    }

    //Navigator.pushNamed(context, 'bienvenida');
  }
}
