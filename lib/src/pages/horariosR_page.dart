import 'package:aministrador_app_v1/src/models/horarios_model.dart';
import 'package:aministrador_app_v1/src/providers/horarios_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class HorariosAgregados extends StatefulWidget {
  const HorariosAgregados({Key? key}) : super(key: key);

  @override
  _HorariosAgregadosState createState() => _HorariosAgregadosState();
}

class _HorariosAgregadosState extends State<HorariosAgregados> {
  final horariosProvider = new HorariosProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horarios agregados'),
      ),
      body: _crearListado(),
      drawer: MenuWidget(),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
        future: horariosProvider.cargarHorarios(),
        builder: (BuildContext context,
            AsyncSnapshot<List<HorariosModel>> snapshot) {
          if (snapshot.hasData) {
            final horarios = snapshot.data;
            return ListView.builder(
              itemCount: horarios!.length,
              itemBuilder: (context, i) => _crearItem(context, horarios[i]),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(BuildContext context, HorariosModel horario) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      child: ListTile(
        title: Text('${horario.dia} - ${horario.hora}'),
        subtitle: Text('${horario.disponible}'),
        onTap: () =>
            Navigator.pushNamed(context, 'citasAdd', arguments: horario),
      ),
    );
  }
}
