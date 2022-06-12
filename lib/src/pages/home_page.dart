import 'package:aministrador_app_v1/src/models/animales_model.dart';
import 'package:aministrador_app_v1/src/providers/animales_provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/utils/utils.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

//import 'package:formvalidation/src/bloc/provider.dart';

class HomePage extends StatelessWidget {
  //const HomePage({Key? key}) : super(key: key);
  final animalesProvider = new AnimalesProvider();
  final userProvider = new UsuarioProvider();
  @override
  Widget build(BuildContext context) {
    //final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mascotas Registradas'),
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
      drawer: MenuWidget(),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
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
                return _crearItem(context, animales![index]);
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
    return Card(
      child: Column(
        children: [
          (animal.fotoUrl == "")
              ? Image(image: AssetImage('assets/no-image.png'))
              : FadeInImage(
                  image: NetworkImage(animal.fotoUrl),
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  height: 270.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
          ListTile(
            title: Text(
              '${animal.nombre} - ${animal.edad}',
              textAlign: TextAlign.center,
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Color: ${animal.color}',
                  textAlign: TextAlign.start,
                ),
                Text('Tamaño: ${animal.tamanio}'),
              ],
            ),
            onTap: () =>
                Navigator.pushNamed(context, 'animal', arguments: animal),
          ),
        ],
      ),
    );

    // child: ListTile(
    //   title: Text('${animal.nombre} - ${animal.edad} meses'),
    //   subtitle: Text('${animal.color} - ${animal.id}'),
    //   onTap: () => Navigator.pushNamed(context, 'animal', arguments: animal),
    // ),
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.green,
      onPressed: () => Navigator.pushNamed(context, 'animal'),
    );
  }
}
