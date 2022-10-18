import 'package:aministrador_app_v1/src/models/donaciones_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/providers/donaciones_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/utils/utils.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class VerDonacionesIn1Page extends StatefulWidget {
  VerDonacionesIn1Page({Key? key}) : super(key: key);

  @override
  _VerDonacionesIn1PageState createState() => _VerDonacionesIn1PageState();
}

class _VerDonacionesIn1PageState extends State<VerDonacionesIn1Page> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final donacionesProvider = new DonacionesProvider();
  final userProvider = new UsuarioProvider();
  DonacionesModel donaciones = new DonacionesModel();
  final List<String> _items =
      ['Alimento', 'Medicina', 'Insumos Higiénicos', 'Otros'].toList();
  String? _selection;
  bool isChecked = false;
  bool isChecked1 = false;
  String disponibilidad = '';
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
        backgroundColor: Colors.green,
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              icon: Icon(Icons.manage_accounts),
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
                      // Row(
                      //   children: [
                      //     Text('Tipo de donación: '),
                      //     Text(donaciones.tipo)
                      //   ],
                      // ),
                      Divider(),
                      _crearUnidades(),
                      Divider(),
                      _buildChild(),
                      Divider(),
                      _crearDescripcion(),
                      Divider(),
                      _mostrarDisponibilidad(),
                      Divider(),
                      Text(
                        'Cambiar disponibilidad de la donación',
                        style: TextStyle(
                          fontSize: 18,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1.5
                            ..color = Colors.orange,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [Text('Disponible'), _crearCheckBox1()],
                            ),
                            Row(
                              children: [
                                Text('No Disponible'),
                                _crearCheckBox2()
                              ],
                            ),
                          ]),
                      Padding(padding: EdgeInsets.only(bottom: 15.0)),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _crearBoton(),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          _crearBotonEliminar()
                        ],
                      )
                      //_crearBoton(),
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

  // Widget _crearTipoDonacion() {
  //   return TextFormField(
  //     initialValue: donaciones.tipo,
  //     readOnly: true,
  //     textCapitalization: TextCapitalization.sentences,
  //     decoration: InputDecoration(
  //         //labelText: 'Tipo de Donación:',
  //         labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
  //   );
  // }
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
            'Tipo de donación: ',
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: DropdownButton<String>(
            hint: Text(donaciones.tipo.toString()),
            //value: _selection,
            value: seleccionTipo(),
            items: dropdownMenuOptions,
            onChanged: null,
            // onChanged: (s) {
            //   setState(() {
            //     _selection = s;

            //     donaciones.tipo = s!;
            //     //animal.tamanio = s!;
            //   });
            // },
          ),
        ),
      ],
    );
  }

  seleccionTipo() {
    if (donaciones.id == '') {
      return _selection;
    } else {
      return donaciones.tipo.toString();
    }
  }

  Widget _buildChild() {
    if (donaciones.tipo == 'Alimento') {
      return _crearPeso();
    }
    return Text('');
  }

  Widget _crearPeso() {
    return TextFormField(
      initialValue: donaciones.peso.toString(),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Ingrese Peso (Kg.):',
        labelStyle: TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      onChanged: (s) {
        setState(() {
          donaciones.peso = double.parse(s);
        });
      },
    );
  }

  Widget _crearDescripcion() {
    return TextFormField(
      initialValue: donaciones.descripcion,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Descripción:',
          labelStyle: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
      onChanged: (s) {
        setState(() {
          donaciones.descripcion = s;
        });
      },
    );
  }

  Widget _mostrarDisponibilidad() {
    return TextFormField(
      readOnly: true,
      initialValue: donaciones.disponibilidad,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Dsiponibilidad de la donación:',
        labelStyle: TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        //labelStyle: ,
        //border: BorderRadius(BorderRadius.circular(2.0)),
        icon: Icon(
          Icons.info,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _crearCheckBox1() {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        if (isChecked1 == true) {
          return null;
        } else {
          setState(() {
            isChecked = value!;
            //domicilio.planMudanza = "Si";
            donaciones.disponibilidad = "Disponible";
          });
        }
      },
    );
  }

  Widget _crearCheckBox2() {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked1,
      onChanged: (bool? value) {
        if (isChecked == true) {
          return null;
        } else {
          setState(() {
            isChecked1 = value!;
            //domicilio.planMudanza = "No";
            donaciones.disponibilidad = "No Disponible";
            //donaciones.cantidad = 0;
          });
        }
      },
    );
  }

  // Widget _crearDonacion() {
  //   return TextFormField(
  //     // initialValue: ,
  //     readOnly: false,
  //     textCapitalization: TextCapitalization.sentences,
  //     decoration: InputDecoration(
  //         labelText: 'Ingrese el tipo de donación:',
  //         labelStyle: TextStyle(fontSize: 16, color: Colors.black)),
  //   );
  // }

  Widget _crearUnidades() {
    return TextFormField(
      initialValue: donaciones.cantidad.toString(),
      //readOnly: false,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          labelText: 'Ingrese la cantidad:',
          labelStyle: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
      onChanged: (s) {
        setState(() {
          donaciones.cantidad = int.parse(s);
        });
      },
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
    // donaciones.estadoDonacion = 'Entrante';
    //onacionesProvider.editarDisponibilidad(donaciones, disponibilidad);
    donacionesProvider.editarDonacion(donaciones);
    mostrarAlertaOk(
        context, 'Registro actualizado con éxito.', 'verDonacionesInAdd');
    //mostrarSnackbar('Registro guardado');
    //Navigator.pushNamed(context, 'verDonacionesInAdd');
  }

  Widget _crearBotonEliminar() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return Colors.green;
        }),
      ),
      label: Text('Eliminar'),
      icon: Icon(Icons.delete),
      autofocus: true,
      onPressed: () {
        mostrarAlertaBorrarDonacion(context,
            '¿Estás seguro de borrar el registro?', donaciones.id.toString());
        // donacionesProvider.borrarDonacion(donaciones.id);
        // mostrarAlertaOk(
        //     context, 'Registro eliminado con éxito', 'verDonacionesInAdd');
      },
    );
  }
}
