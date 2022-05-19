import 'package:aministrador_app_v1/src/models/horarios_model.dart';
import 'package:aministrador_app_v1/src/providers/horarios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class HorariosPage extends StatefulWidget {
  const HorariosPage({Key? key}) : super(key: key);

  @override
  _HorariosPageState createState() => _HorariosPageState();
}

class _HorariosPageState extends State<HorariosPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final horariosProvider = new HorariosProvider();
  final userProvider = new UsuarioProvider();
  HorariosModel horarios = new HorariosModel();
  bool _disponible = false;
  //lista dias
  final List<String> _items =
      ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado'].toList();
  final List<String> _items1 = [
    '9:00 - 9:30',
    '9:30 - 10:00',
    '10:00 - 10:30',
    '10:30 - 11:00',
    '11:00 - 11:30',
    '11:30 - 12:00',
    '12:00 - 12:30',
    '12:30 - 13:00',
    '14:00 - 14:30',
    '14:30 - 15:00'
  ].toList();
  String? _selection;
  String? _selection1;
  @override
  void initState() {
    // _selection = _items.last;
    super.initState();
  }

  //bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    final Object? horarioData = ModalRoute.of(context)!.settings.arguments;
    if (horarioData != null) {
      horarios = horarioData as HorariosModel;
      print(horarios.id);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar horarios de visita"),
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
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Form(
          child: Column(
            children: [
              _crearDia(),
              Divider(),
              _crearHoraDia(),
              Divider(),
              _crearDisponible(),
              Divider(),
              _crearBotonEliminar(),
              Divider(),
              _crearBoton(),
              Divider(),
            ],
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

  Widget _crearDia() {
    final dropdownMenuOptions = _items
        .map((String item) =>
            //new DropdownMenuItem<String>(value: item, child: new Text(item)))
            new DropdownMenuItem<String>(value: item, child: new Text(item)))
        .toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Seleccione el dia:         ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        DropdownButton<String>(
            hint: Text(horarios.dia.toString()),
            value: _selection,
            items: dropdownMenuOptions,
            onChanged: (s) {
              setState(() {
                _selection = s;
                horarios.dia = s!;
              });
            }),
      ],
    );
  }

  Widget _crearHoraDia() {
    final dropdownMenuOptions = _items1
        .map((String item) =>
            //new DropdownMenuItem<String>(value: item, child: new Text(item)))
            new DropdownMenuItem<String>(value: item, child: new Text(item)))
        .toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Seleccione el dia:         ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        DropdownButton<String>(
            hint: Text(horarios.hora.toString()),
            value: _selection1,
            items: dropdownMenuOptions,
            onChanged: (s) {
              setState(() {
                _selection1 = s;
                horarios.hora = s!;
              });
            }),
      ],
    );
  }

  Widget _crearDisponible() {
    if (horarios.disponible == 'No disponible') {
      _disponible = false;
    }
    if (horarios.disponible == 'Disponible') {
      _disponible = true;
    }
    return SwitchListTile(
      value: _disponible,
      title: Text('Horario disponible:'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.grey)),
      activeColor: Colors.green,
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
          return Colors.green;
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
    } else {
      horariosProvider.editarHorarios(horarios);
    }
    //mostrarSnackbar('Registro guardado');
    Navigator.pushNamed(context, 'horariosAdd');
  }

  Widget _crearBotonEliminar() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return Colors.green;
        }),
      ),
      label: Text('Eliminar registro'),
      icon: Icon(Icons.delete),
      autofocus: true,
      //onPressed: (_guardando) ? null : _submit,
      onPressed: () {
        horariosProvider.borrarHorario(horarios.id);
        Navigator.pushNamed(context, 'horariosAdd');
      },
    );
  }
}
