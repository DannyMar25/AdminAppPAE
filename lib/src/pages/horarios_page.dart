import 'package:aministrador_app_v1/src/models/horarios_model.dart';
import 'package:aministrador_app_v1/src/providers/horarios_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class HorariosPage extends StatefulWidget {
  //const CitasPage({Key? key}) : super(key: key);

  @override
  _HorariosPageState createState() => _HorariosPageState();
}

class _HorariosPageState extends State<HorariosPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _guardando = false;
  final horariosProvider = new HorariosProvider();
  HorariosModel horarios = new HorariosModel();
  String _fecha = '';
  String _hora = '';
  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _inputFieldTimeController = new TextEditingController();
  bool _disponible = false;
  @override
  Widget build(BuildContext context) {
    final Object? horarioData = ModalRoute.of(context)!.settings.arguments;
    if (horarioData != null) {
      horarios = horarioData as HorariosModel;
      print(horarios.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Creacion de horarios de visita"),
      ),
      drawer: MenuWidget(),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Form(
          child: Column(
            children: [
              //ListView(
              //children: [
              _crearFecha(context),
              Divider(),
              _crearHora(context),
              Divider(),
              _crearDisponible(),
              Divider(),
              _crearBoton(),
              Divider(),
              //],
              //),
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearFecha(BuildContext context) {
    return TextFormField(
      //textCapitalization: TextCapitalization.sentences,
      //initialValue: horarios.dia,
      //enableInteractiveSelection: true,
      controller: _inputFieldDateController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        //counter: Text('Letras ${_nombre.length}'),
        hintText: 'Ingrese fecha de agendamiento de cita',
        labelText: 'Fecha de la cita',
        //helperText: 'Solo es el nombre',
        suffixIcon: Icon(Icons.perm_contact_calendar),
        icon: Icon(Icons.calendar_today),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
      //onSaved: (value) => horarios.dia = _inputFieldDateController.toString(),
    );
  }

  Widget _crearHora(BuildContext context) {
    return TextFormField(
      //initialValue: horarios.hora,
      //textCapitalization: TextCapitalization.sentences,
      //enableInteractiveSelection: true,
      controller: _inputFieldTimeController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        //counter: Text('Letras ${_nombre.length}'),
        hintText: 'Ingrese hora de agendamiento de cita',
        labelText: 'Hora de la cita',
        //helperText: 'Solo es el nombre',
        suffixIcon: Icon(Icons.perm_contact_calendar),
        icon: Icon(Icons.calendar_today),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectTime(context);
      },
      //onSaved: (value) => horarios.hora = _inputFieldTimeController.toString(),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2025),
      locale: Locale('es', 'ES'),
    );

    if (picked != null) {
      setState(() {
        _fecha = picked.year.toString() +
            '-' +
            picked.month.toString() +
            '-' +
            picked.day.toString();
        //_fecha = picked.toString();
        _inputFieldDateController.text = _fecha;
        horarios.dia = picked.toString();
      });
    }
  }

  _selectTime(BuildContext context) async {
    TimeOfDay? picked1 = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked1 != null) {
      setState(() {
        _hora = picked1.hour.toString() + ':' + picked1.minute.toString();
        _inputFieldTimeController.text = _hora;
        horarios.hora = picked1.toString();
      });
    }
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: _disponible,
      title: Text('Horario disponible:'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.grey)),
      activeColor: Colors.deepPurple,
      onChanged: (bool value) => setState(() {
        _disponible = value;
        if (value == false) {
          horarios.disponible = "No disponible";
        } else {
          horarios.disponible = "Disponible";
        }
      }),
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return Colors.deepPurple;
        }),
      ),
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      autofocus: true,
      //onPressed: (_guardando) ? null : _submit,
      onPressed: () {
        _submit();
      },
    );
  }

  void _submit() async {
    if (horarios.id == "") {
      horariosProvider.crearHorario(horarios);
    } //else {
    //animalProvider.editarAnimal(animal, foto!);
    //}
    //mostrarSnackbar('Registro guardado');
    Navigator.pushNamed(context, 'horariosAdd');
  }
}
