import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/providers/animales_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class GaleriaMascotasPage extends StatefulWidget {
  @override
  State<GaleriaMascotasPage> createState() => _GaleriaMascotasPageState();
}

class _GaleriaMascotasPageState extends State<GaleriaMascotasPage> {
  //const HomePage({Key? key}) : super(key: key);
  final animalesProvider = new AnimalesProvider();

  final userProvider = new UsuarioProvider();
  bool busqueda = false;
  final _textController = TextEditingController();
  String? nombre;
  String? nombreBusqueda;
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    //backgroundColor: Colors.green,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    //final bloc = Provider.of(context);
    return RefreshIndicator(
      displacement: 250,
      backgroundColor: Colors.green,
      color: Colors.white,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        await Future.delayed(Duration(milliseconds: 1500));
        setState(() {
          _buildChildBusqueda(context);
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mascotas registradas'),
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
        //body: _crearListado(),
        body: Column(
          children: [
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            _busqueda(),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            _botonBusqueda(),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            //Expanded(child: _crearListado())
            Expanded(child: _buildChildBusqueda(context))
            //_crearListado(),
          ],
        ),
        floatingActionButton: _crearBoton(context),
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

//Implementacion para busqueda
  Widget _busqueda() {
    return TextField(
      controller: _textController,
      autocorrect: false,
      onChanged: (s) {
        setState(() {
          nombre = s;
          nombreBusqueda = nombre![0].toUpperCase() + s.substring(1);
          busqueda = true;
          print(nombreBusqueda);
        });
      },
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 2.0),
        ),
        prefixIcon: Icon(Icons.search),
        suffixIcon: GestureDetector(
          child: Icon(Icons.clear),
          onTap: _onClearTapped,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(10, 10))),
        hintText: 'Ingresa el nombre de la mascota',
      ),
    );
  }

  void _onClearTapped() {
    setState(() {
      _textController.text = '';
      busqueda = false;
    });
  }

  Widget _crearListadoBusqueda() {
    return FutureBuilder(
        future: animalesProvider.cargarAnimalBusqueda(nombreBusqueda!),
        builder:
            (BuildContext context, AsyncSnapshot<List<AnimalModel>> snapshot) {
          if (snapshot.hasData) {
            final animales = snapshot.data;
            return GridView.count(
              childAspectRatio: 50 / 100,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(animales!.length, (index) {
                return _crearItem(context, animales[index]);
              }),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildChildBusqueda(BuildContext context) {
    if (busqueda == false) {
      return _crearListado();
    } else {
      return _crearListadoBusqueda();
    }
  }

//
  Widget _crearListado() {
    return FutureBuilder(
        future: animalesProvider.cargarAnimal1(),
        builder:
            (BuildContext context, AsyncSnapshot<List<AnimalModel>> snapshot) {
          if (snapshot.hasData) {
            final animales = snapshot.data;
            return GridView.count(
              childAspectRatio: 50 / 100,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(animales!.length, (index) {
                return _crearItem(context, animales[index]);
              }),

              /* ListView.builder(
                itemCount: animales!.length,
                itemBuilder: (context, i) => _crearItem(context, animales[i]),
              ), */
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(BuildContext context, AnimalModel animal) {
    return Container(
      height: 100.0,
      width: 200.0,
      child: Card(
        color: Color.fromARGB(248, 202, 241, 170),
        elevation: 4.0,
        margin: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 80.0), //90
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
                          height: 250.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                _buildChild(animal, context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.green,
      onPressed: () => Navigator.pushNamed(context, 'animal'),
    );
  }

  Widget _botonBusqueda() {
    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        //cardB.currentState?.collapse();
        Navigator.pushNamed(context, 'busqueda');
      },
      child: Column(
        children: <Widget>[
          Icon(
            Icons.search,
            color: Colors.green,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
          ),
          Text(
            'Busqueda personalizada',
            style: TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildChild(AnimalModel animal, BuildContext context) {
    if (animal.estado == 'En Adopción') {
      return ListTile(
        title: Text(
          '${animal.nombre} - ${animal.etapaVida}',
          textAlign: TextAlign.center,
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Color: ${animal.color}',
              textAlign: TextAlign.start,
            ),
            Text(
              'Tamaño: ${animal.tamanio}',
            ),
            SizedBox(
              width: 200,
              height: 35,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    '${animal.estado}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
                color: Colors.green,
              ),
            )
          ],
        ),
        onTap: () => Navigator.pushNamed(context, 'animal', arguments: animal),
      );
    } else if (animal.estado == 'Adoptado') {
      return ListTile(
        title: Text(
          '${animal.nombre} - ${animal.etapaVida}',
          textAlign: TextAlign.center,
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Color: ${animal.color}',
              textAlign: TextAlign.start,
            ),
            Text(
              'Tamaño: ${animal.tamanio}',
            ),
            SizedBox(
              width: 200,
              height: 35,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    '${animal.estado}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
                color: Colors.blue,
              ),
            )
          ],
        ),
        onTap: () => Navigator.pushNamed(context, 'animal', arguments: animal),
      );
    } else {
      return ListTile(
        title: Text(
          '${animal.nombre} - ${animal.etapaVida}',
          textAlign: TextAlign.center,
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Color: ${animal.color}',
              textAlign: TextAlign.start,
            ),
            Text(
              'Tamaño: ${animal.tamanio}',
            ),
            SizedBox(
              width: 200,
              height: 35,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    '${animal.estado}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
                color: Colors.orange,
              ),
            )
          ],
        ),
        onTap: () => Navigator.pushNamed(context, 'animal', arguments: animal),
      );
    }
  }
}
