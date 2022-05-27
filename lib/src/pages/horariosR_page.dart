import 'package:aministrador_app_v1/src/models/horarios_model.dart';
import 'package:aministrador_app_v1/src/providers/horarios_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class HorariosAgregados extends StatefulWidget {
  const HorariosAgregados({Key? key}) : super(key: key);

  @override
  _HorariosAgregadosState createState() => _HorariosAgregadosState();
}

class _HorariosAgregadosState extends State<HorariosAgregados> {
  final horariosProvider = new HorariosProvider();
  final userProvider = new UsuarioProvider();
  final List<String> _items =
      ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado'].toList();
  String? _selection;
  @override
  void initState() {
    // _selection = _items.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horarios Registrados'),
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
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Form(
          child: Column(
            children: [
              _crearDia(),
              Divider(),
              _verListado(),
              Divider(),
            ],
          ),
        ),
      ),
      drawer: MenuWidget(),
    );
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
            //hint: Text(horarios.dia.toString()),
            value: _selection,
            items: dropdownMenuOptions,
            onChanged: (s) {
              setState(() {
                _selection = s;
                // horarios.dia = s!;
              });
            }),
      ],
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

  Widget _verListado() {
    return FutureBuilder(
        future: horariosProvider.cargarHorariosDia(_selection.toString()),
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
    return Card(
      color: Colors.lightGreen[200],
      shadowColor: Colors.green,
      child: Column(key: UniqueKey(),
          // background: Container(
          //   color: Colors.red,
          // ),
          children: [
            ListTile(
              title: Text('${horario.dia} - ${horario.hora}'),
              subtitle: Text('${horario.disponible}'),
              onTap: () =>
                  Navigator.pushNamed(context, 'citasAdd', arguments: horario),
            )
          ]),
    );
  }
}
