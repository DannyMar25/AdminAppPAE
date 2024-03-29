import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:aministrador_app_v1/src/providers/animales_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

//import 'package:formvalidation/src/bloc/provider.dart';

class ResultadosBusquedaPage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);
  @override
  _ResultadosBusquedaPageState createState() => _ResultadosBusquedaPageState();
}

class _ResultadosBusquedaPageState extends State<ResultadosBusquedaPage> {
  final animalesProvider = new AnimalesProvider();
  AnimalModel animal = new AnimalModel();
  final userProvider = new UsuarioProvider();
  final prefs = new PreferenciasUsuario();

  final formKey = GlobalKey<FormState>();
  String? especie = '';
  String? sexo = '';
  String? etapaVida = '';
  String? tamanio = '';
  String? estado = '';
  List<AnimalModel> citasA = [];
  List<Future<AnimalModel>> listaC = [];
  bool busqueda = false;
  //final _textController = TextEditingController();
  String? nombre;
  String? nombreBusqueda;
  @override
  // void initState() {
  //   super.initState();
  //   showCitas();
  // }

  @override
  Widget build(BuildContext context) {
    //final bloc = Provider.of(context);
    //showCitas();
    final email = prefs.email;
    final arg = ModalRoute.of(context)?.settings.arguments as Map;
    //if (dat == arg['datosper']) {
    especie = arg['especie'];
    //print(formularios.idDatosPersonales);
    sexo = arg['sexo'];
    etapaVida = arg['etapaVida'];
    tamanio = arg['tamanio'];
    estado = arg['estado'];

    return Scaffold(
        appBar: AppBar(
          title: Text('Resultados de búsqueda'),
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
          ],
        ),
        drawer: MenuWidget(),
        body: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            _botonBusqueda(),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Expanded(
              child: _crearListadoBusqueda(),
              //child: buildChild(),
            )
            //_crearListado(),
          ],
        ));
  }

  Widget buildChild() {
    if (tamanio == null) {
      return _crearListadoBusqueda4();
    } else {
      return _crearListadoBusqueda();
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

  Widget _crearListadoBusqueda() {
    return FutureBuilder(
        future: animalesProvider.cargarBusqueda(
          especie,
          sexo,
          etapaVida,
          tamanio,
          estado,
        ),
        builder:
            (BuildContext context, AsyncSnapshot<List<AnimalModel>> snapshot) {
          if (snapshot.hasData) {
            final animales = snapshot.data;
            if (animales!.length == 0) {
              return Column(children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: AlertDialog(
                    title: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 45,
                        ),
                        Text('Resultado de búsqueda'),
                      ],
                    ),
                    content: Text(
                        'No se ha encotrado ninguna mascota con las características que buscabas.'),
                    actions: [
                      TextButton(
                          child: Text('Ok'),
                          //onPressed: () => Navigator.of(context).pop(),
                          onPressed: () {
                            Navigator.pushNamed(context, 'home');
                          })
                    ],
                  ),
                )
              ]);
            }
            return GridView.count(
              childAspectRatio: 6 / 8,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(animales.length, (index) {
                return _crearItem1(context, animales[index]);
              }),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearListadoBusqueda4() {
    return FutureBuilder(
        future: animalesProvider.cargarBusqueda4(
          especie!,
          sexo!,
          etapaVida!,
          estado!,
        ),
        builder:
            (BuildContext context, AsyncSnapshot<List<AnimalModel>> snapshot) {
          if (snapshot.hasData) {
            final animales = snapshot.data;
            if (animales!.length == 0) {
              return Column(children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: AlertDialog(
                    title: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 45,
                        ),
                        Text('Resultado de búsqueda'),
                      ],
                    ),
                    content: Text(
                        'No se ha encotrado ninguna mascota con las características que buscabas.'),
                    actions: [
                      TextButton(
                          child: Text('Ok'),
                          //onPressed: () => Navigator.of(context).pop(),
                          onPressed: () {
                            Navigator.pushNamed(context, 'home');
                          })
                    ],
                  ),
                )
              ]);
            }
            return GridView.count(
              childAspectRatio: 6 / 8,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(animales.length, (index) {
                return _crearItem1(context, animales[index]);
              }),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem1(BuildContext context, AnimalModel animal) {
    return Card(
      color: Color.fromARGB(248, 238, 250, 228),
      elevation: 4.0,
      //margin: EdgeInsets.only(bottom: 90.0, left: 5.0, right: 5.0),
      child: Flexible(
        fit: FlexFit.loose,
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, 'animal', arguments: animal),
          child: Column(
            children: [
              (animal.fotoUrl == "")
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : Expanded(
                      child: FadeInImage(
                        image: NetworkImage(animal.fotoUrl),
                        placeholder: AssetImage('assets/cat_1.gif'),
                        height: 300.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
              ListTile(
                title: Text('${animal.nombre}'),
                subtitle: Text('${animal.etapaVida} - ${animal.sexo}'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botonBusqueda() {
    return TextButton(
      onPressed: () {
        //cardB.currentState?.collapse();
        Navigator.pushNamed(context, 'home');
      },
      child: Column(
        children: <Widget>[
          Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
          ),
          Text(
            'Volver a la Galería',
            style: TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }
}
