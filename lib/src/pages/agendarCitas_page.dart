import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/models/citas_model.dart';
import 'package:aministrador_app_v1/src/models/horarios_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:aministrador_app_v1/src/providers/citas_provider.dart';
import 'package:aministrador_app_v1/src/providers/horarios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/utils/utils.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String campoVacio = 'Por favor, llena este campo';
  final prefs = new PreferenciasUsuario();

  //bool _guardando = false;
  //final formKey = GlobalKey<FormState>();
  HorariosModel horarios = new HorariosModel();
  final horariosProvider = new HorariosProvider();
  final citasProvider = new CitasProvider();
  CollectionReference dbRefH =
      FirebaseFirestore.instance.collection('horarios');

  AnimalModel animal = new AnimalModel();

  bool seleccionado = false;

  late String horaSeleccionada;
  late String idHorario;
  @override
  Widget build(BuildContext context) {
    final email = prefs.email;
    final Object? animData = ModalRoute.of(context)!.settings.arguments;
    if (animData != null) {
      animal = animData as AnimalModel;
      print(animal.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de citas'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: Icon(Icons.manage_accounts),
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
        Navigator.pushNamed(context, 'soporte');
        break;
      case 1:
        userProvider.signOut();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      // Navigator.pushNamed(context, 'login');
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
        validator: (value) {
          if (value!.isEmpty) {
            return 'Por favor selecciona una fecha';
          } else {
            return null;
          }
        },
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _selectDate(context);
        });
  }

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now().add(Duration(days: 1)),
      firstDate: new DateTime.now().add(Duration(days: 1)),
      lastDate: new DateTime.now().add(Duration(days: 8)),
      locale: Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.green, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.green, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fechaCompleta = picked.year.toString() +
            '-' +
            picked.month.toString() +
            '-' +
            picked.day.toString();

        // _fecha = picked.toString();
        _fecha = picked.weekday.toString();
        if (_fecha == '1') {
          _fecha = 'Lunes';
        }
        if (_fecha == '2') {
          _fecha = 'Martes';
        }
        if (_fecha == '3') {
          _fecha = 'Miércoles';
        }
        if (_fecha == '4') {
          _fecha = 'Jueves';
        }
        if (_fecha == '5') {
          _fecha = 'Viernes';
        }
        if (_fecha == '6') {
          _fecha = 'Sábado';
        }
        if (_fecha == '7') {
          _fecha = 'Domingo';
        }
        //_fecha = DateFormat('EEEE').format(picked);
        _inputFieldDateController.text = _fecha + ' ' + _fechaCompleta;
      });
    }
  }

  Widget _verListado() {
    return FutureBuilder(
        future: horariosProvider.cargarHorariosDia1(_fecha),
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
            idHorario = horario.id;
            horaSeleccionada = horario.hora;

            print(horario.hora);
          },
          initialValue: horario.hora + '  -   ' + horario.disponible,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              //labelText: 'Hora',
              suffixIcon: Icon(Icons.add),
              icon: Icon(Icons.calendar_today)),
        ),
        Divider(
          color: Colors.white,
        )
      ],
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      //initialValue: animal.nombre,
      controller: nombre,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
      ],
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombre',
      ),
      onSaved: (value) => nombre = value as TextEditingController,
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese su nombre';
        } else if (value.isEmpty) {
          return campoVacio;
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
      keyboardType: TextInputType.phone,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Teléfono (Celular: 0998765432)',
      ),
      onSaved: (value) => telefono = value as TextEditingController,
      validator: (value) {
        if (value!.length < 10 || value.length > 10 && value.length > 0) {
          return 'Ingrese un número de teléfono válido';
        } else if (value.isEmpty) {
          return campoVacio;
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
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Correo',
      ),
      onSaved: (value) => correo = value as TextEditingController,
      validator: (value) => validarEmail(value),
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            return Colors.green[700];
          }),
        ),
        label: Text('Revisar'),
        icon: Icon(Icons.save),
        autofocus: true,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Información'),
                  content: Text('Nombre: ' +
                      nombre.text +
                      '\n' +
                      'Teléfono: ' +
                      telefono.text +
                      '\n' +
                      'Correo: ' +
                      correo.text +
                      '\n' +
                      'Fecha de la cita:' +
                      _fechaCompleta +
                      '\n' +
                      'Hora:' +
                      horaSeleccionada),
                  actions: [
                    TextButton(
                        child: Text('Guardar'),
                        //onPressed: () => Navigator.of(context).pop(),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            SnackBar(
                              content:
                                  Text('Información ingresada correctamente.'),
                            );
                            _submit();
                          } else {
                            mostrarAlerta(context,
                                'Asegúrate de que todos los campos estén llenos.');
                          }
                        }),
                    TextButton(
                        child: Text('Corregir información'),
                        //onPressed: () => Navigator.of(context).pop(),
                        onPressed: () => Navigator.of(context).pop()),
                  ],
                );
              });
        });
  }

  void _submit() async {
    //Guardar datos en base
    citas.nombreClient = nombre.text;
    citas.telfClient = telefono.text;
    citas.correoClient = correo.text;
    citas.fechaCita = _fechaCompleta;
    horariosProvider.editarDisponible(idHorario);
    citas.idHorario = idHorario;
    citas.estado = 'Pendiente';
    if (animal.id == '') {
      citas.idAnimal = 'WCkke2saDQ5AfeJkU6ck';
    } else {
      citas.idAnimal = animal.id!;
    }

    if (citas.id == "") {
      final estadoCita = await citasProvider.verificar(correo.text);
      if (estadoCita.isEmpty) {
        print('Puede');
        citasProvider.crearCita(citas);
        mostrarAlertaOk1(context, 'La cita ha sido registrada con éxito.',
            'home', 'Información correcta');
      } else {
        print('no puede');
        mostrarAlerta(context, 'Al momento ya cuenta con una cita registrada.');
      }
    }
  }
}
