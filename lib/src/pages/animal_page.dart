import 'dart:io';

import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/providers/animales_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:aministrador_app_v1/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';
//import 'package:firebase_core/firebase_core.dart';

class AnimalPage extends StatefulWidget {
  //const ProductoPage({Key? key}) : super(key: key);

  @override
  _AnimalPageState createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animalProvider = new AnimalesProvider();
  final userProvider = new UsuarioProvider();

  AnimalModel animal = new AnimalModel();
  bool _guardando = false;
  File? foto;
  //variables usadas para desplegar opciones de tamaño
  final List<String> _items = ['Pequeño', 'Mediano', 'Grande'].toList();
  String? _selection;
  final List<String> _items1 = ['Macho', 'Hembra'].toList();
  String? _selection1;
  @override
  void initState() {
    // _selection = _items.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Object? animData = ModalRoute.of(context)!.settings.arguments;
    if (animData != null) {
      animal = animData as AnimalModel;
      print(animal.id);
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Animal'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
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
          //cerrar sesion

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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _mostrarFoto(),
                _crearNombre(),
                _crearSexo(),
                _crearEdad(),
                _crearTemperamento(),
                _crearPeso(),
                _crearTamanio(),
                _crearColor(),
                _crearRaza(),
                _crearCaracteristicas(),
                // _crearDisponible(),
                _crearBoton(),
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

  Widget _crearNombre() {
    return TextFormField(
      initialValue: animal.nombre,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombre',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      onSaved: (value) => animal.nombre = value!,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese el nombre de la mascota';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearSexo() {
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
          'Seleccione el sexo: ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        DropdownButton<String>(
            hint: Text(animal.sexo.toString()),
            value: _selection1,
            items: dropdownMenuOptions,
            onChanged: (s) {
              setState(() {
                _selection1 = s;
                animal.sexo = s!;
              });
            }),
      ],
    );
  }

  Widget _crearEdad() {
    return TextFormField(
      initialValue: animal.edad.toString(),
      //textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Edad',
        labelStyle: TextStyle(fontSize: 21, color: Colors.black),
      ),
      onSaved: (value) => animal.edad = int.parse(value!),
      validator: (value) {
        if (utils.isNumeric(value!)) {
          return null;
        } else {
          return 'Solo numeros';
        }
      },
    );
  }

  Widget _crearTemperamento() {
    return TextFormField(
      initialValue: animal.temperamento,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Temperamento',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      onSaved: (value) => animal.temperamento = value!,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese el temperamento de la mascota';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPeso() {
    return TextFormField(
      initialValue: animal.peso.toString(),
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Peso',
        labelStyle: TextStyle(fontSize: 21, color: Colors.black),
      ),
      onSaved: (value) => animal.peso = double.parse(value!),
      validator: (value) {
        if (utils.isNumeric(value!)) {
          return null;
        } else {
          return 'Solo numeros';
        }
      },
    );
  }

  Widget _crearTamanio() {
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
          'Seleccione el tamaño: ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        DropdownButton<String>(
            hint: Text(animal.tamanio.toString()),
            value: _selection,
            items: dropdownMenuOptions,
            onChanged: (s) {
              setState(() {
                _selection = s;
                animal.tamanio = s!;
              });
            }),
      ],
    );

    // return TextFormField(
    //   initialValue: animal.tamanio.toString(),
    //   textCapitalization: TextCapitalization.sentences,
    //   decoration: InputDecoration(
    //     labelText: 'Tamaño',
    //   ),
    //   onSaved: (value) => animal.tamanio = double.parse(value!),
    //   validator: (value) {
    //     if (utils.isNumeric(value!)) {
    //       return null;
    //     } else {
    //       return 'Solo numeros';
    //     }
    //   },
    // );
  }

  Widget _crearColor() {
    return TextFormField(
      initialValue: animal.color,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Color',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      onSaved: (value) => animal.color = value!,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese el color de la mascota';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearRaza() {
    return TextFormField(
      initialValue: animal.raza,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Raza',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      onSaved: (value) => animal.raza = value!,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese la raza de la mascota';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearCaracteristicas() {
    return TextFormField(
      initialValue: animal.caracteristicas,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Caracteristicas',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      onSaved: (value) => animal.caracteristicas = value!,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese las caracteristicas especiales';
        } else {
          return null;
        }
      },
    );
  }

  //Widget _crearDisponible() {
  //return SwitchListTile(
  //value: producto.disponible,
  // title: Text('Disponible'),
  //activeColor: Colors.deepPurple,
  //onChanged: (value) => setState(() {
  //producto.disponible = value;
  // }),
  //);
  //}

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
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    print('Todo OK!');

    setState(() {
      _guardando = true;
    });

    if (animal.id == "") {
      animalProvider.crearAnimal1(animal, foto!);
    } else {
      animalProvider.editarAnimal(animal, foto!);
    }
    //setState(() {
    //  _guardando = false;
    // });

    mostrarSnackbar('Registro guardado');

    Navigator.pushNamed(context, 'home');
    // if (animal.id == null) {
    //   print("ssssss");
    // }
    // if (animal.id == "") {
    //   print("aaaaaa");
    // }
    // print(animal.id);
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (animal.fotoUrl != '') {
      return FadeInImage(
        image: NetworkImage(animal.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300,
        fit: BoxFit.contain,
      );
    } else {
      if (foto != null) {
        return Image.file(
          foto!,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset(foto?.path ?? 'assets/no-image.png');
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final _picker = ImagePicker();
    final pickedFile =
        await _picker.getImage(source: origen, maxHeight: 720, maxWidth: 720);
    foto = File(pickedFile!.path);
    if (foto != null) {
      animal.fotoUrl = '';
    }
    setState(() {});
  }
}
