import 'package:aministrador_app_v1/src/models/donaciones_model.dart';
import 'package:aministrador_app_v1/src/providers/donaciones_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class VerDonacionesOutAddPage extends StatefulWidget {
  const VerDonacionesOutAddPage({Key? key}) : super(key: key);

  @override
  _VerDonacionesOutAddPageState createState() =>
      _VerDonacionesOutAddPageState();
}

class _VerDonacionesOutAddPageState extends State<VerDonacionesOutAddPage> {
  final donacionesProvider = new DonacionesProvider();
  final userProvider = new UsuarioProvider();
  DonacionesModel donaciones = new DonacionesModel();
  final List<String> _items =
      ['Alimento', 'Medicina', 'Insumos Higienicos', 'Otros'].toList();
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
        title: Text('Donaciones salientes registradas'),
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
              _crearTipoDonacion(),
              Divider(),
              _verListado(),
              Divider(),
              //_mostrarTotal()
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
          'Seleccione el tipo de donacion:  ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        DropdownButton<String>(
            hint: Text(donaciones.tipo.toString()),
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

  Widget _verListado() {
    return FutureBuilder(
        future: donacionesProvider.verDonacionesOut(_selection.toString()),
        builder: (BuildContext context,
            AsyncSnapshot<List<DonacionesModel>> snapshot) {
          if (snapshot.hasData) {
            final donaciones = snapshot.data;
            return Column(
              children: [
                SizedBox(
                    height: 300,
                    child: ListView.builder(
                        itemCount: donaciones!.length,
                        itemBuilder: (context, i) =>
                            _crearItem(context, donaciones[i]))),
                // _mostrarTotal(context),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(BuildContext context, DonacionesModel donacion) {
    //_mostrarTotal(context);
    return Column(key: UniqueKey(),
        // background: Container(
        //   color: Colors.red,
        // ),
        children: [
          ListTile(
              title: Text('${donacion.tipo} - ${donacion.cantidad}'),
              subtitle: Text('${donacion.descripcion}'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'verDonacionesOutAdd1',
                    arguments: donacion);
              }),
          // _mostrarTotal(context),
        ]);
    //return _mostrarTotal(context);
  }

  Widget _mostrarTotal(BuildContext context) {
    return TextFormField(
      //initialValue: donacionesProvider.sumarDonaciones1().toString(),
      readOnly: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Total:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
    );
  }
}
