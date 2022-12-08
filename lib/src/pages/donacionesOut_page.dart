import 'package:aministrador_app_v1/src/models/donaciones_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/providers/donaciones_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class IngresoDonacionesOutPage extends StatefulWidget {
  IngresoDonacionesOutPage({Key? key}) : super(key: key);

  @override
  _IngresoDonacionesOutPageState createState() =>
      _IngresoDonacionesOutPageState();
}

class _IngresoDonacionesOutPageState extends State<IngresoDonacionesOutPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final donacionesProvider = new DonacionesProvider();
  final userProvider = new UsuarioProvider();
  DonacionesModel donaciones = new DonacionesModel();
  final List<String> _items =
      ['Alimento', 'Medicina', 'Insumos Higiénicos', 'Otros'].toList();
  String? _selection = "Alimento";
  @override
  void initState() {
    // _selection = _items.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Object? donacData = ModalRoute.of(context)!.settings.arguments;
    if (donacData != null) {
      donaciones = donacData as DonacionesModel;
      print(donaciones.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text('Recursos disponibles para donación')),
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: Icon(Icons.account_circle),
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
      body: Stack(
        children: [
          //Background(),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text(
                        'Registros',
                        style: TextStyle(
                          fontSize: 30,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = Colors.blueGrey[300]!,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Divider(
                        color: Colors.transparent,
                      ),
                      _crearTipoDonacion(),
                      Divider(
                        color: Colors.transparent,
                      ),
                      _verListado(),
                      Divider(
                        color: Colors.transparent,
                      ),
                    ],
                  )),
            ),
          ),
        ],
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
        Expanded(
          child: Text(
            'Seleccione el tipo de donación:',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        Expanded(
          child: DropdownButton<String>(
            hint: Text(donaciones.tipo.toString()),
            value: _selection,
            items: dropdownMenuOptions,
            onChanged: (s) {
              setState(() {
                _selection = s;

                //donaciones.tipo = s!;
                //animal.tamanio = s!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _verListado() {
    return FutureBuilder(
        future: donacionesProvider.cargarDonaciones(_selection.toString()),
        builder: (BuildContext context,
            AsyncSnapshot<List<DonacionesModel>> snapshot) {
          if (snapshot.hasData) {
            final donaciones = snapshot.data;
            return SizedBox(
                height: 600,
                child: ListView.builder(
                  itemCount: donaciones!.length,
                  itemBuilder: (context, i) =>
                      _crearItem(context, donaciones[i]),
                ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(BuildContext context, DonacionesModel donacion) {
    if (donacion.tipo == 'Alimento') {
      return Card(
        color: Colors.lightGreen[200],
        shadowColor: Colors.green,
        child: ListTile(
          title: Text(
            '${'Cantidad:'} ${donacion.cantidad} ${'- Peso:'}  ${donacion.peso} ${'Kg'}',
            textAlign: TextAlign.center,
          ),
          subtitle: Column(
            children: [
              Text('${donacion.descripcion}'),
              Text('${'Fecha de ingreso: '} ${donacion.fechaIngreso}'),
            ],
          ),
          onTap: () => Navigator.pushNamed(context, 'DonacionesOutAdd1',
              arguments: donacion),
        ),
      );
    } else {
      return Card(
        color: Colors.lightGreen[200],
        shadowColor: Colors.green,
        child: ListTile(
          title: Text(
            '${'Cantidad:'} ${donacion.cantidad}',
            textAlign: TextAlign.center,
          ),
          subtitle: Column(
            children: [
              Text('${donacion.descripcion}'),
              Text('${'Fecha de ingreso: '} ${donacion.fechaIngreso}'),
            ],
          ),
          onTap: () => Navigator.pushNamed(context, 'DonacionesOutAdd1',
              arguments: donacion),
        ),
      );
    }
  }
}
