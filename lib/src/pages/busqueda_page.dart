import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/utils/utils.dart';
import 'package:flutter/material.dart';

class BusquedaPage extends StatefulWidget {
  const BusquedaPage({Key? key}) : super(key: key);

  @override
  State<BusquedaPage> createState() => _BusquedaPageState();
}

class _BusquedaPageState extends State<BusquedaPage> {
  final formKey = GlobalKey<FormState>();
  AnimalModel animal = new AnimalModel();
  final List<String> _especie = ['Canina', 'Felina'].toList();
  String? _selection;
  final List<String> _sexo = ['Macho', 'Hembra'].toList();
  String? _selection1;
  final List<String> _etapaVida = [
    'Cachorro',
    'Joven',
    'Adulto',
    'Anciano',
    'Geriátrico',
  ].toList();
  String? _selection2;
  final List<String> _tamanio = ['Pequeño', 'Mediano', 'Grande'].toList();
  String? _selection3;

  bool isChecked1 = false;
  bool isChecked2 = false;

  final List<String> _estadoAdopcion =
      ['Pendiente', 'En Adopción', 'Adoptado'].toList();
  String? _selection4;

  final userProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'home');
          },
        ),
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
        title: Text('Búsqueda de mascotas'),
      ),
      body: Stack(
        children: [
          //Background(),
          SingleChildScrollView(
            child: Flexible(
              fit: FlexFit.loose,
              child: Container(
                //padding: EdgeInsets.all(15.0),
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        //Padding(padding: EdgeInsets.only(top: 1.0)),
                        SizedBox(
                          height: 170,
                          child: Image(
                            image: AssetImage("assets/dog_an6.gif"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Text('Buscador',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 30,
                            )),
                        Padding(padding: EdgeInsets.only(bottom: 10.0)),
                        Text(
                          'Selecciona la o las categorías de tu gusto y te mostraremos los resultados.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15),
                        ),
                        //Divider(),
                        //Text('Especie:'),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                      height: 80,
                                      child: Image(
                                          image: AssetImage(
                                              "assets/dog_an1.gif"))),
                                ),
                                Expanded(
                                  child: SizedBox(
                                      height: 80,
                                      child: Image(
                                          image: AssetImage(
                                              "assets/cat_im2.jpg"))),
                                ),
                              ],
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        _seleccionarEspecie(),

                        Padding(padding: EdgeInsets.only(bottom: 30.0)),
                        _seleccionarEstadoAdopcion(),
                        Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                      height: 50,
                                      child: Image(
                                          image: AssetImage(
                                              "assets/huella_azul3.png"))),
                                ),
                                Expanded(
                                  child: SizedBox(
                                      height: 50,
                                      child: Image(
                                          image: AssetImage(
                                              "assets/huella_rosa3.png"))),
                                )
                              ],
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        _seleccionarSexo(),
                        Padding(padding: EdgeInsets.only(bottom: 25.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                  height: 150.0,
                                  child: Image(
                                      image: AssetImage("assets/pets_4.png"))),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        _seleccionarEtapaVida(),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     //Padding(padding: EdgeInsets.only(left: 150.0)),
                        //     Expanded(
                        //       child: SizedBox(
                        //           height: 200,
                        //           child: Image(
                        //               image: AssetImage("assets/pets_2.png"))),
                        //     ),
                        //   ],
                        // ),
                        //Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        // _seleccionarTamanio(),
                        buildChild(),
                        Padding(padding: EdgeInsets.only(bottom: 40.0)),
                        _crearBoton()
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChild() {
    if (_selection == 'Canina') {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Padding(padding: EdgeInsets.only(left: 150.0)),
              Expanded(
                child: SizedBox(
                    height: 200,
                    child: Image(image: AssetImage("assets/pets_2.png"))),
              ),
            ],
          ),
          _seleccionarTamanio(),
        ],
      );
    } else {
      return Text('');
    }
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

  Widget _seleccionarEspecie() {
    final dropdownMenuOptions = _especie
        .map((String especie) =>
            //new DropdownMenuItem<String>(value: item, child: new Text(item)))
            new DropdownMenuItem<String>(
                value: especie, child: new Text(especie)))
        .toList();
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Text(
          'Seleccione especie:',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            //Se cambio dropdownbutton por dropdownbuttonformfiel y con esto se anadio validator
            child: SizedBox(
              width: 150.0,
              child: DropdownButtonFormField<String>(
                  //hint: Text(animal.tamanio.toString()),
                  value: _selection,
                  items: dropdownMenuOptions,
                  // validator: (value) =>
                  //     value == null ? 'Selecciona una opción' : null,
                  onChanged: (s) {
                    setState(() {
                      if (s == null) {
                        _selection = "vacio";
                      } else {
                        _selection = s;
                      }
                      //animal.tamanio = s!;
                    });
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _seleccionarSexo() {
    final dropdownMenuOptions = _sexo
        .map((String sexo) =>
            //new DropdownMenuItem<String>(value: item, child: new Text(item)))
            new DropdownMenuItem<String>(value: sexo, child: new Text(sexo)))
        .toList();
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Text(
          'Seleccione género:',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: SizedBox(
              width: 150.0,
              child: DropdownButtonFormField<String>(
                  //hint: Text(animal.tamanio.toString()),
                  value: _selection1,
                  items: dropdownMenuOptions,
                  // validator: (value) =>
                  //     value == null ? 'Selecciona una opción' : null,
                  onChanged: (s) {
                    setState(() {
                      //_selection1 = s;
                      if (s == null) {
                        _selection1 = "vacio";
                      } else {
                        _selection1 = s;
                      }
                    });
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _seleccionarEtapaVida() {
    final dropdownMenuOptions = _etapaVida
        .map((String edad) =>
            //new DropdownMenuItem<String>(value: item, child: new Text(item)))
            new DropdownMenuItem<String>(value: edad, child: new Text(edad)))
        .toList();
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Text(
          'Seleccione etapa de vida:',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: SizedBox(
              width: 150.0,
              child: DropdownButtonFormField<String>(
                  //hint: Text(animal.tamanio.toString()),
                  value: _selection2,
                  items: dropdownMenuOptions,
                  // validator: (value) =>
                  //     value == null ? 'Selecciona una opción' : null,
                  onChanged: (s) {
                    setState(() {
                      // _selection2 = s;
                      if (s == null) {
                        _selection2 = "vacio";
                      } else {
                        _selection2 = s;
                      }
                    });
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _seleccionarTamanio() {
    final dropdownMenuOptions = _tamanio
        .map((String tamanio) =>
            //new DropdownMenuItem<String>(value: item, child: new Text(item)))
            new DropdownMenuItem<String>(
                value: tamanio, child: new Text(tamanio)))
        .toList();
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Text(
          'Seleccione tamaño:',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: SizedBox(
              width: 150.0,
              child: DropdownButtonFormField<String>(
                  //hint: Text(animal.tamanio.toString()),
                  value: _selection3,
                  items: dropdownMenuOptions,
                  // validator: (value) =>
                  //     value == null ? 'Selecciona una opción' : null,
                  onChanged: (s) {
                    setState(() {
                      //_selection3 = s;
                      if (s == null) {
                        _selection3 = "vacio";
                      } else {
                        _selection3 = s;
                      }
                    });
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _seleccionarEstadoAdopcion() {
    final dropdownMenuOptions = _estadoAdopcion
        .map((String estado) =>
            //new DropdownMenuItem<String>(value: item, child: new Text(item)))
            new DropdownMenuItem<String>(
                value: estado, child: new Text(estado)))
        .toList();
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.only(top: 10.0)),
        Text(
          'Seleccione estado de adopción:',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: SizedBox(
              width: 150.0,
              child: DropdownButtonFormField<String>(
                  //hint: Text(animal.tamanio.toString()),
                  value: _selection4,
                  items: dropdownMenuOptions,
                  // validator: (value) =>
                  //     value == null ? 'Selecciona una opción' : null,
                  onChanged: (s) {
                    setState(() {
                      //_selection4 = s;
                      if (s == null) {
                        _selection4 = "vacio";
                      } else {
                        _selection4 = s;
                      }
                    });
                  }),
            ),
          ),
        ),
      ],
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
      label: Text('Buscar'),
      icon: Icon(Icons.search),
      autofocus: true,
      //onPressed: (_guardando) ? null : _submit,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          SnackBar(
            content: Text('Por favor selecciona una opción'),
          );
          //_submit();
          buildChild1();
        } else {
          mostrarAlerta(context,
              'Todos los campos deben ser seleccionados. Asegúrate de haber completado todos.');
        }
        //_submit();
      },
    );
  }

  buildChild1() {
    if (_selection == 'Canina') {
      return _submit();
    } else {
      return _submit4();
    }
  }

  void _submit() async {
    Navigator.pushNamed(context, 'resultadoBusqueda', arguments: {
      'especie': _selection,
      'sexo': _selection1,
      'etapaVida': _selection2,
      'tamanio': _selection3,
      'estado': _selection4
    });
  }

  void _submit4() async {
    Navigator.pushNamed(context, 'resultadoBusqueda', arguments: {
      'especie': _selection,
      'sexo': _selection1,
      'etapaVida': _selection2,
      'tamanio': null,
      'estado': _selection4
    });
  }
}
