import 'package:aministrador_app_v1/src/models/donaciones_model.dart';
import 'package:aministrador_app_v1/src/providers/donaciones_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:aministrador_app_v1/src/utils/utils.dart' as utils;

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
      ['Alimento', 'Medicina', 'Insumos Higienicos', 'Otros'].toList();
  String? _selection;
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
        title: Text('Registro de donaciones'),
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
                        'Donaciones',
                        style: TextStyle(
                          fontSize: 33,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.blueGrey[300]!,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Divider(),

                      Divider(),
                      _crearTipoDonacion(),
                      Divider(),
                      // _crearUnidades(),
                      Divider(),
                      //_buildChild(),
                      Divider(),
                      // _crearDescripcion(),
                      Divider(),
                      _crearBoton(),
                      // _crearCantidad(),
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

              donaciones.tipo = s!;
              //animal.tamanio = s!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildChild() {
    if (_selection == 'Alimento') {
      return _crearPeso();
    } //else {
    //   if (_selection == 'Otros') {
    //     return _crearDonacion();
    //   }
    // }
    return Text('');
  }

  Widget _crearPeso() {
    //if (_selection == 'Alimento') {
    return TextFormField(
      initialValue: donaciones.peso.toString(),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Ingrese Peso (Kg.):',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      onChanged: (s) {
        setState(() {
          donaciones.peso = double.parse(s);
        });
      },
      // onSaved: (value) => donaciones.peso = double.parse(value!),
      // validator: (value) {
      //   if (utils.isNumeric(value!)) {
      //     return null;
      //   } else {
      //     return 'Solo numeros';
      //   }
      // },
    );
    //}
  }

  Widget _crearDescripcion() {
    return TextFormField(
      initialValue: donaciones.descripcion,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Descripcion:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      onChanged: (s) {
        setState(() {
          donaciones.descripcion = s;
        });
      },
      // onSaved: (value) => donaciones.descripcion = value!,
      // validator: (value) {
      //   if (value!.length < 3) {
      //     return 'Ingrese la descripcion';
      //   } else {
      //     return null;
      //   }
      // },
    );
  }

  Widget _crearDonacion() {
    return TextFormField(
      // initialValue: ,
      readOnly: false,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Ingrese el tipo de donacion:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
    );
  }

  Widget _crearUnidades() {
    return TextFormField(
      initialValue: donaciones.cantidad.toString(),
      //readOnly: false,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          labelText: 'Ingrese la cantidad:',
          labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
      onChanged: (s) {
        setState(() {
          donaciones.cantidad = int.parse(s);
        });
      },
      // onSaved: (value) => donaciones.cantidad = int.parse(value!),
      // validator: (value) {
      //   if (utils.isNumeric(value!)) {
      //     return null;
      //   } else {
      //     return 'Solo numeros';
      //   }
      // },
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
    if (donaciones.id == "") {
      donacionesProvider.crearDonacion(donaciones);
    } else {
      donacionesProvider.editarDonacion(donaciones);
    }
    //mostrarSnackbar('Registro guardado');
    //Navigator.pushNamed(context, 'verDonacionesOutAdd');
  }

  Widget _verListado() {
    return FutureBuilder(
        future: donacionesProvider.cargarDonaciones(_selection.toString()),
        builder: (BuildContext context,
            AsyncSnapshot<List<DonacionesModel>> snapshot) {
          if (snapshot.hasData) {
            final donaciones = snapshot.data;
            return SizedBox(
                height: 300,
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
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      child: ListTile(
        title: Text('${donacion.tipo} - ${donacion.cantidad}'),
        subtitle: Text('${donacion.descripcion}'),
        onTap: () => Navigator.pushNamed(context, 'donacionesInAdd',
            arguments: donacion),
      ),
    );
  }
}
