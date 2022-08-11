import 'package:aministrador_app_v1/src/models/donaciones_model.dart';
import 'package:aministrador_app_v1/src/providers/donaciones_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class VerDonacionesInAddPage extends StatefulWidget {
  const VerDonacionesInAddPage({Key? key}) : super(key: key);

  @override
  _VerDonacionesInAddPageState createState() => _VerDonacionesInAddPageState();
}

class _VerDonacionesInAddPageState extends State<VerDonacionesInAddPage> {
  List<DonacionesModel> donacionA = [];
  List<Future<DonacionesModel>> listaD = [];
  final donacionesProvider = new DonacionesProvider();
  final userProvider = new UsuarioProvider();
  DonacionesModel donaciones = new DonacionesModel();
  final List<String> _items =
      ['Alimento', 'Medicina', 'Insumos Higiénicos', 'Otros'].toList();
  String? _selection;
  int total1 = 0;
  int totalA = 0;
  @override
  void initState() {
    // _selection = _items.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donaciones registradas'),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: Icon(Icons.manage_accounts),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      child: Text("Información"),
                      value: 0,
                    ),
                    PopupMenuItem<int>(
                      child: Text("Ayuda"),
                      value: 1,
                    ),
                    PopupMenuItem<int>(
                      child: Text("Cerrar Sesión"),
                      value: 2,
                    )
                  ]),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Form(
          child: Column(
            children: [
              _crearTipoDonacion(),
              Divider(),
              _verListado(),
              Divider(),
              // _mostrarTotal()
            ],
          ),
        ),
      ),
      drawer: MenuWidget(),
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

  Widget _crearTipoDonacion() {
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
          'Seleccione el tipo de donación:  ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        DropdownButton<String>(
            hint: Text(donaciones.tipo.toString()),
            value: _selection,
            items: dropdownMenuOptions,
            onChanged: (s) {
              setState(() {
                _selection = s;
                showCitas();
                // horarios.dia = s!;
              });
            }),
      ],
    );
  }

  showCitas() async {
    donacionA.clear();
    total1 = 0;
    listaD =
        await donacionesProvider.cargarDonacionesIn11_P(_selection.toString());
    for (var yy in listaD) {
      DonacionesModel don = await yy;
      setState(() {
        donacionA.add(don);
        total1 += don.cantidad;
      });
    }
    print(total1.toString());
  }

  Widget _verListado() {
    return Column(
      children: [
        SizedBox(
            height: 600,
            child: ListView.builder(
                itemCount: donacionA.length,
                itemBuilder: (context, i) =>
                    _crearItem(context, donacionA[i]))),
        //_mostrarTotal(),
      ],
    );
  }

  Widget _crearItem(BuildContext context, DonacionesModel donacion) {
    //_mostrarTotal(context);
    if (donacion.tipo == 'Alimento') {
      return Card(
        color: Colors.lightGreen[200],
        shadowColor: Colors.green,
        child: Column(key: UniqueKey(),
            // background: Container(
            //   color: Colors.red,
            // ),
            children: [
              ListTile(
                  title: Column(
                    children: [
                      Text(
                          '${donacion.tipo}  ${'- Cantidad:'} ${donacion.cantidad}'),
                      //Text('${'Fecha de ingreso: '} ${donacion.fechaIngreso}'),
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      Text(
                          '${donacion.descripcion} ${'- Peso:'}  ${donacion.peso} ${'Kg'}'),
                      Text('${'Fecha de ingreso: '} ${donacion.fechaIngreso}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, 'verDonacionesIn1',
                        arguments: donacion);
                  }),
            ]),
      );
    } else {
      return Card(
        color: Colors.lightGreen[200],
        shadowColor: Colors.green,
        child: Column(key: UniqueKey(), children: [
          ListTile(
              title: Text(
                  '${donacion.tipo}  ${'- Cantidad:'} ${donacion.cantidad}',
                  textAlign: TextAlign.center),
              subtitle: Column(
                children: [
                  Text('${donacion.descripcion}'),
                  Text('${'Fecha de ingreso: '} ${donacion.fechaIngreso}'),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, 'verDonacionesIn1',
                    arguments: donacion);
              }),
        ]),
      );
    }

    //return _mostrarTotal(context);
  }

  // Widget _mostrarTotal() {
  //   return TextFormField(
  //     initialValue: totalA.toString(),
  //     readOnly: true,
  //     textCapitalization: TextCapitalization.sentences,
  //     decoration: InputDecoration(
  //         labelText: 'Total:',
  //         labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
  //   );
  // }
}
