import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/models/citas_model.dart';
import 'package:aministrador_app_v1/src/models/horarios_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
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
  String nombre = '';
  String telefono = '';
  String correo = '';
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
  String campoVacio = 'Por favor, llena este campo';

  AnimalModel animal = new AnimalModel();
  bool seleccionado = false;

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
      //Navigator.pushNamed(context, 'login');
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
            String fecha = 'Por favor selecciona una fecha';
            return fecha;
          } else {
            return null;
          }
        },
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
            seleccionado = true;
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
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombre',
      ),
      onChanged: (s) {
        setState(() {
          nombre = s;
        });
      },
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
      keyboardType: TextInputType.phone,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Teléfono',
      ),
      onChanged: (s) {
        setState(() {
          telefono = s;
        });
      },
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
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Correo',
      ),
      onChanged: (s) {
        setState(() {
          correo = s;
        });
      },
      validator: (value) => validarEmail(value),
      // validator: (value) {
      //   if (value!.length < 3 && value.length > 0) {
      //     return 'Ingrese su correo electrónico';
      //   } else if (value.isEmpty) {
      //     return campoVacio;
      //   } else {
      //     return null;
      //   }
      // },
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
          if (formKey.currentState!.validate()) {
            if (seleccionado == true) {
              SnackBar(
                content: Text('Información ingresada correctamente.'),
              );
              _submit();
              seleccionado = false;
            } else {
              mostrarAlerta(context,
                  'Debes seleccionar un horario disponible para tu cita.');
            }
            // Si el formulario es válido, queremos mostrar un Snackbar

          } else {
            mostrarAlerta(
                context, 'Asegúrate de que todos los campos estén llenos.');
          }
        });
  }

  void _submit() async {
    //Guardar datos en base
    citas.nombreClient = nombre;
    citas.telfClient = telefono;
    citas.correoClient = correo;
    citas.fechaCita = _fechaCompleta;
    citas.estado = 'Pendiente';
    if (animal.id == '') {
      citas.idAnimal = 'WCkke2saDQ5AfeJkU6ck';
    } else {
      citas.idAnimal = animal.id!;
    }

    //citas.idHorario = horarios.id;

    // if (citas.id == "") {
    //   citasProvider.crearCita(citas);
    //   mostrarAlertaOk(
    //       context, 'La cita ha sido registrada con éxito', 'bienvenida');
    // }

    if (citas.id == "") {
      final estadoCita = await citasProvider.verificar(correo);
      if (estadoCita.isEmpty) {
        print('Puede');
        citasProvider.crearCita(citas);
        mostrarAlertaOk1(
            context,
            'La cita ha sido registrada con éxito, revise su correo para verificar el día y hora agendados.',
            'home',
            'Información correcta');
      } else {
        print('no puede');
        mostrarAlerta(context, 'Al momento ya cuenta con una cita registrada.');
      }
      //citasProvider.crearCita(citas);
      // mostrarAlertaOk(context, 'La cita ha sido registrada con éxito', 'home');
    }

    //Navigator.pushNamed(context, 'bienvenida');
  }
}
