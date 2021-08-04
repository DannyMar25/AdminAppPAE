import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class CitasPage extends StatefulWidget {
  const CitasPage({Key? key}) : super(key: key);

  @override
  _CitasPageState createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  String _fecha = '';
  String _hora = '';
  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _inputFieldTimeController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              _crearFecha(context),
              Divider(),
              _crearHora(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearFecha(BuildContext context) {
    return TextField(
      //textCapitalization: TextCapitalization.sentences,
      enableInteractiveSelection: false,
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
    );
  }

  Widget _crearHora(BuildContext context) {
    return TextField(
      //textCapitalization: TextCapitalization.sentences,
      enableInteractiveSelection: false,
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
      });
    }
  }
}
