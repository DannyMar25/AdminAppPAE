import 'dart:io';

import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/providers/animales_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:aministrador_app_v1/src/utils/utils.dart' as utils;
import 'package:flutter/services.dart';
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
  File? foto;
  //variables usadas para desplegar opciones de tamaño
  final List<String> _items = ['Pequeño', 'Mediano', 'Grande'].toList();
  String? _selection;
  final List<String> _items1 = ['Macho', 'Hembra'].toList();
  String? _selection1;
  final List<String> _items2 =
      ['Cachorro', 'Joven', 'Adulto', 'Anciano', 'Geriátrico'].toList();
  String? _selection2;
  final List<String> _items3 = ['Canina', 'Felina'].toList();
  String? _selection3;
  final List<String> _items4 = ['Si', 'No'].toList();
  String? _selection4;
  int? edadN;
  bool isDisable = false;
  bool editFoto = false;
  String campoVacio = 'Por favor, llena este campo';
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
        automaticallyImplyLeading: true,
        title: Text('Animal'),
        backgroundColor: Colors.green,
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
              icon: Icon(Icons.account_circle),
              itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      child: Text("Ayuda"),
                      value: 0,
                    ),
                    PopupMenuItem<int>(
                      child: Text("Cerrar Sesión"),
                      value: 1,
                    )
                  ]),
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
                _crearEspecie(),
                _crearNombre(),
                _crearSexo(),
                Row(children: [_crearEdad(), infoEtapa()]),
                // _crearEdad(),
                _crearTemperamento(),
                _crearPeso(),
                _crearTamanio(),
                _crearColor(),
                _crearRaza(),
                _crearEsterilizado(),
                _crearCaracteristicas(),
                // _crearDisponible(),
                //_crearBoton(),
                _buildChild()
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
        Navigator.pushNamed(context, 'soporte');
        break;
      case 1:
        userProvider.signOut();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      // Navigator.pushNamed(context, 'login');
    }
  }

  Widget _crearEspecie() {
    final dropdownMenuOptions = _items3
        .map((String item) =>
            new DropdownMenuItem<String>(value: item, child: new Text(item)))
        .toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Especie: ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(
          width: 150.0,
          child: DropdownButtonFormField<String>(
              hint: Text(animal.especie.toString()),
              value: seleccionEspecie(),
              items: dropdownMenuOptions,
              validator: (value) =>
                  value == null ? 'Selecciona una opción' : null,
              onChanged: (s) {
                setState(() {
                  _selection3 = s;
                  animal.especie = s!;
                });
              }),
        ),
      ],
    );
  }

  seleccionEspecie() {
    if (animal.id == '') {
      return _selection3;
    } else {
      return animal.especie.toString();
    }
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: animal.nombre,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[0-9\-=@,\.;]")),
      ],
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombre',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      onChanged: (s) {
        setState(() {
          animal.nombre = s;
        });
      },
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese el nombre de la mascota';
        } else if (value.isEmpty) {
          return campoVacio;
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearSexo() {
    final dropdownMenuOptions = _items1
        .map((String item) =>
            new DropdownMenuItem<String>(value: item, child: new Text(item)))
        .toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Seleccione el sexo: ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(
          width: 150.0,
          child: DropdownButtonFormField<String>(
              hint: Text(animal.sexo.toString()),
              value: seleccionSexo(),
              items: dropdownMenuOptions,
              validator: (value) =>
                  value == null ? 'Selecciona una opción' : null,
              onChanged: (s) {
                setState(() {
                  _selection1 = s;
                  animal.sexo = s!;
                });
              }),
        ),
      ],
    );
  }

  seleccionSexo() {
    if (animal.id == '') {
      return _selection1;
    } else {
      return animal.sexo.toString();
    }
  }

  Widget _crearEdad() {
    final dropdownMenuOptions = _items2
        .map((String item) =>
            new DropdownMenuItem<String>(value: item, child: new Text(item)))
        .toList();
    return Row(
      children: [
        Text(
          'Etapa de vida: ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(
          width: 150.0,
          child: DropdownButtonFormField<String>(
              hint: Text(animal.etapaVida.toString()),
              value: seleccionEtapa(),
              items: dropdownMenuOptions,
              validator: (value) =>
                  value == null ? 'Selecciona una opción' : null,
              onChanged: (s) {
                setState(() {
                  _selection2 = s;
                  animal.etapaVida = s!;
                });
              }),
        ),
      ],
    );
  }

  seleccionEtapa() {
    if (animal.id == '') {
      return _selection2;
    } else {
      return animal.etapaVida.toString();
    }
  }

  Widget infoEtapa() {
    return TextButton(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(
              'Cachorro: 0 a 6 meses\nJoven: 7 meses a 2 años\nAdulto: 2 a 6 años\nAnciano: 7 a 11 años\nGeriátrico: mayor a 12 años',
            ),
            title: Text('Etapas de vida'),
          ),
        );
      },
      child: Column(
        children: <Widget>[
          Icon(
            Icons.info_rounded,
            color: Colors.green,
            size: 20.0,
          ),
        ],
      ),
    );
  }

  Widget _crearTemperamento() {
    return TextFormField(
      initialValue: animal.temperamento,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[0-9\-=@,\.;]")),
      ],
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Temperamento',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      onChanged: (s) {
        setState(() {
          animal.temperamento = s;
        });
      },
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese el temperamento de la mascota';
        } else if (value.isEmpty) {
          return campoVacio;
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
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
        labelText: 'Peso en Kg.',
        labelStyle: TextStyle(fontSize: 21, color: Colors.black),
      ),
      onChanged: (s) {
        setState(() {
          animal.peso = double.parse(s);
        });
      },
      validator: (value) {
        if (utils.isNumeric(value!)) {
          return null;
        } else {
          return 'Solo números';
        }
      },
    );
  }

  Widget _crearTamanio() {
    final dropdownMenuOptions = _items
        .map((String item) =>
            new DropdownMenuItem<String>(value: item, child: new Text(item)))
        .toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Seleccione el tamaño: ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(
          width: 150.0,
          child: DropdownButtonFormField<String>(
              hint: Text(animal.tamanio.toString()),
              //value: _selection,
              value: seleccionTam(),
              items: dropdownMenuOptions,
              validator: (value) =>
                  value == null ? 'Selecciona una opción' : null,
              onChanged: (s) {
                setState(() {
                  _selection = s;
                  animal.tamanio = s!;
                });
              }),
        ),
      ],
    );
  }

  seleccionTam() {
    if (animal.id == '') {
      return _selection;
    } else {
      return animal.tamanio.toString();
    }
  }

  Widget _crearColor() {
    return TextFormField(
      initialValue: animal.color,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[0-9\-=@,\.;]")),
      ],
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Color',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      onChanged: (s) {
        setState(() {
          animal.color = s;
        });
      },
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese el color de la mascota';
        } else if (value.isEmpty) {
          return campoVacio;
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
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp("[0-9\-=@,\.;]")),
      ],
      decoration: InputDecoration(
        labelText: 'Raza',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      onChanged: (s) {
        setState(() {
          animal.raza = s;
        });
      },
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese la raza de la mascota';
        } else if (value.isEmpty) {
          return campoVacio;
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearEsterilizado() {
    final dropdownMenuOptions = _items4
        .map((String item) =>
            new DropdownMenuItem<String>(value: item, child: new Text(item)))
        .toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Esterilizado: ',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(
          width: 150.0,
          child: DropdownButtonFormField<String>(
              hint: Text(animal.esterilizado.toString()),
              value: seleccionEst(),
              items: dropdownMenuOptions,
              validator: (value) =>
                  value == null ? 'Selecciona una opción' : null,
              onChanged: (s) {
                setState(() {
                  _selection4 = s;
                  animal.esterilizado = s!;
                });
              }),
        ),
      ],
    );
  }

  seleccionEst() {
    if (animal.id == '') {
      return _selection4;
    } else {
      return animal.esterilizado.toString();
    }
  }

  Widget _crearCaracteristicas() {
    return TextFormField(
      maxLines: 6,
      initialValue: animal.caracteristicas,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Características',
        labelStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      onChanged: (s) {
        setState(() {
          animal.caracteristicas = s;
        });
      },
      validator: (value) {
        if (value!.length < 3 && value.length > 0) {
          return 'Ingrese las características especiales';
        } else if (value.isEmpty) {
          return campoVacio;
        } else {
          return null;
        }
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
      onPressed: () {
        print(editFoto);
        if (editFoto == false) {
          if (formKey.currentState!.validate()) {
            // Si el formulario es válido, queremos mostrar un Snackbar
            SnackBar(
              content: Text('Información ingresada correctamente'),
            );
            _submit();
          } else {
            utils.mostrarAlerta(
                context, 'Asegúrate de que todos los campos estén llenos.');
          }
        } else {
          if (formKey.currentState!.validate()) {
            SnackBar(
              content: Text('Información ingresada correctamente'),
            );
            animalProvider.editarAnimal(animal, foto!);
            utils.mostrarAlertaOk(
                context, 'Registro actualizado con éxito.', 'home');
          } else {
            utils.mostrarAlerta(
                context, 'Asegúrate de que todos los campos estén llenos.');
            // utils.mostrarAlerta(context,
            //     'Asegurate de que todos los campos estan llenos y de haber escogido una foto de tu mascota.');
          }
        }
      },
    );
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
          utils.mostrarAlertaBorrar(context,
              '¿Estás seguro de borrar el registro?', animal.id.toString());
        });
  }

  void _submit() async {
    if (animal.id == "") {
      if (foto != null) {
        animal.estado = "En Adopción";
        animalProvider.crearAnimal1(animal, foto!);
        utils.mostrarAlertaOk(context, 'Registro guardado con éxito.', 'home');
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                    Text('Información incorrecta'),
                  ],
                ),
                content: Text('Ingrese la foto de la mascota.'),
                actions: [
                  TextButton(
                      child: Text('Aceptar'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              );
            });
      }

      //mostrarSnackbar('Registro guardado');
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 50,
                  ),
                  Text('Información correcta'),
                ],
              ),
              content: Text('Desea actualizar la foto de la mascota?'),
              actions: [
                TextButton(
                    child: Text('Si'),
                    onLongPress: () {
                      editFoto = true;
                    },
                    onPressed: () {
                      editFoto = true;
                      Navigator.pop(context);
                    }),
                TextButton(
                    child: Text('No'),
                    onPressed: () {
                      animalProvider.editarAnimalSinFoto(
                          animal, animal.fotoUrl);
                      utils.mostrarAlertaOk(
                          context, 'Registro actualizado con éxito.', 'home');
                    }),
              ],
            );
          });
    }
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
    if (animal.id == "") {
      editFoto = false;
      final pickedFile = await _picker.pickImage(
          source: origen,
          maxHeight: 720,
          maxWidth: 720); //cambio de getImage a pickImage
      foto = File(pickedFile!.path);
      if (foto != null) {
        animal.fotoUrl = '';
      }
      setState(() {});
    } else {
      editFoto = true;
      final pickedFile = await _picker.pickImage(
          source: origen,
          maxHeight: 720,
          maxWidth: 720); //cambio de getImage a pickImage
      foto = File(pickedFile!.path);
      if (foto != null) {
        animal.fotoUrl = '';
      }
      setState(() {});
    }
  }

  Widget _buildChild() {
    if (animal.id == "") {
      return _crearBoton();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _crearBoton(),
          Padding(padding: EdgeInsets.only(right: 10.0)),
          _crearBotonEliminar()
        ],
      );
    }
  }
}
