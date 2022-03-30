import 'package:aministrador_app_v1/src/models/citas_model.dart';
import 'package:aministrador_app_v1/src/providers/animales_provider.dart';
import 'package:aministrador_app_v1/src/providers/citas_provider.dart';
import 'package:aministrador_app_v1/src/providers/horarios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class VerCitasPage extends StatefulWidget {
  VerCitasPage({Key? key}) : super(key: key);

  @override
  _VerCitasPageState createState() => _VerCitasPageState();
}

class _VerCitasPageState extends State<VerCitasPage> {
  TextEditingController _inputFieldDateController = new TextEditingController();
  List<CitasModel> citasA = [];
  List<Future<CitasModel>> listaC = [];
  final formKey = GlobalKey<FormState>();
  final citasProvider = new CitasProvider();
  final horariosProvider = new HorariosProvider();
  final animalesProvider = new AnimalesProvider();
  final userProvider = new UsuarioProvider();
  String _fecha = '';
  //TextEditingController _inputFieldDateController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    //showCitas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Citas agendadas'),
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
                _crearFecha(context),
                Divider(),
                _verListado(),
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
        break;
      case 2:
        userProvider.signOut();
        Navigator.pushNamed(context, 'login');
    }
  }

  showCitas() async {
    citasA.clear();
    listaC =
        await citasProvider.cargarCitasFecha(_inputFieldDateController.text);
    for (var yy in listaC) {
      CitasModel cit = await yy;
      // print("Datos: " + cit.id);
      // print("Datos: " + cit.idHorario);
      // print("Datos: " + cit.animal!.nombre);
      // print("Datos: " + cit.horario!.dia);
      // print("Datos: " + cit.nombreClient);
      setState(() {
        citasA.add(cit);
      });
    }
  }

  Widget _verListado() {
    return Column(
      children: [
        SizedBox(
          height: 800,
          child: ListView.builder(
            itemCount: citasA.length,
            itemBuilder: (context, i) => _crearItem(context, citasA[i]),
          ),
        ),
      ],
    );
  }

  Widget _crearItem(BuildContext context, CitasModel cita) {
    String fecha = cita.horario!.dia;
    // DateTime fecha1 = DateTime.parse(fecha);
    // String fecha2 = fecha1.year.toString() +
    //     "-" +
    //     fecha1.month.toString() +
    //     "-" +
    //     fecha1.day.toString();
    String hora = cita.horario!.hora;

    return ListTile(
      title: Column(
        children: [
          Divider(color: Colors.purple),
          Text("Fecha:" + '${cita.fechaCita}'),
          Text("Nombre del cliente: " + '${cita.nombreClient}'),
          // Text("Posible a doptante para: " '${cita.animal!.nombre}'),
          Text("Dia de la cita: " + fecha),
          Text("Hora de la cita: " + hora),

          Divider(color: Colors.purple)
          // IconButton(
          //     onPressed: () async {
          //       HorariosModel h1 = new HorariosModel();
          //       h1 = await horariosProvider.cargarHorarioId(cita.idHorario);
          //       print("Datos de horario");
          //       print(h1.dia + h1.hora);
          //     },
          //     icon: Icon(Icons.access_alarm))
        ],
      ),
      //subtitle: Text('${horario}'),
      onTap: () => Navigator.pushNamed(context, 'verCitasR', arguments: cita),
    );
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
          suffixIcon: Icon(Icons.perm_contact_calendar),
          icon: Icon(Icons.calendar_today),
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
      firstDate: new DateTime(2020),
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
        //_fechaCompleta = picked.toString();

        //_fecha = DateFormat('EEEE').format(picked);
        _inputFieldDateController.text = _fecha;
        showCitas();
      });
    }
  }

  // Widget _buildChild() {
  //   _crearFecha(context);

  //   if (_fecha == _fecha) {
  //     showCitas();
  //     return _verListado();
  //   } //else {
  //   //   if (_selection == 'Otros') {
  //   //     return _crearDonacion();
  //   //   }
  //   // }
  //   return Text('');
  // }
}
