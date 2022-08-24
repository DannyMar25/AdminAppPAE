import 'package:accordion/controllers.dart';
import 'package:aministrador_app_v1/src/pages/animal_page.dart';
import 'package:aministrador_app_v1/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';

class BienvenidaPage extends StatelessWidget {
  final userProvider = new UsuarioProvider();
  final prefs = new PreferenciasUsuario();
  final _headerStyle = const TextStyle(
      color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold);
  final _contentStyle = const TextStyle(
      color: Color.fromARGB(255, 17, 17, 17),
      fontSize: 14,
      fontWeight: FontWeight.normal);
  final _loremIpsum =
      '''PoliPet es una app dedicada a difundir la adopción de mascotas, nuestro principal objetivo es mejorar la calidad de vida de animalitos que no tienen un hogar''';
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    //backgroundColor: Colors.green,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );

  void setGPS(int getData, String id) {
    //ProductoModel producto;
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseReference prodRef = ref.child("gps");
    DatabaseReference urlRef = prodRef.child("Test");
    urlRef.update({"GetDataGPS": getData, "id": id});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagina principal'),
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
                      child: Text("Cerrar sesión"),
                      value: 1,
                    ),
                  ]),
        ],
      ),
      drawer: MenuWidget(),
      body: Container(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 15.0, bottom: 10.0)),
            Center(
              child: Text(
                'BIENVENIDO',
                style: TextStyle(
                  fontSize: 33,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4
                    ..color = Color.fromARGB(204, 160, 236, 61),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                //Padding(padding: EdgeInsets.only(bottom: 5.0)),
                // SizedBox(
                //   child: Image(image: AssetImage('assets/dog_an6.gif')),
                //   height: 130,
                // ),
                SizedBox(
                  height: 700,
                  child: Accordion(
                    maxOpenSections: 1,
                    headerBackgroundColorOpened: Colors.black54,
                    //scaleWhenAnimating: true,
                    openAndCloseAnimation: true,
                    headerPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                    sectionClosingHapticFeedback: SectionHapticFeedback.light,
                    children: [
                      AccordionSection(
                        isOpen: true,
                        leftIcon: const Icon(Icons.pets, color: Colors.white),
                        headerBackgroundColor: Colors.green,
                        headerBackgroundColorOpened: Colors.green,
                        header: Text('¿Qué es PoliPet?', style: _headerStyle),
                        content: Text(_loremIpsum, style: _contentStyle),
                        contentHorizontalPadding: 20,
                        contentBorderWidth: 1,
                        // onOpenSection: () => print('onOpenSection ...'),
                        // onCloseSection: () => print('onCloseSection ...'),
                      ),
                      AccordionSection(
                        isOpen: false,
                        leftIcon: const Icon(Icons.photo_library,
                            color: Colors.white),
                        header:
                            Text('Mascotas registradas', style: _headerStyle),
                        contentBorderColor: const Color(0xffffffff),
                        headerBackgroundColor:
                            Color.fromARGB(251, 236, 122, 193),
                        headerBackgroundColorOpened: Colors.purple,
                        content: Column(
                          children: [
                            Text(
                                'Mira los registros de todas las mascotas o crea uno nuevo.'),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                //cardB.currentState?.collapse();
                                Navigator.pushNamed(context, 'home');
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.photo_library_outlined,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'Galería',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                //cardB.currentState?.collapse();
                                Navigator.pushNamed(context, 'animal');
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.photo_library_outlined,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'Registrar nueva mascota',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      AccordionSection(
                        isOpen: false,
                        leftIcon:
                            const Icon(Icons.fact_check, color: Colors.white),
                        header: Text('Citas', style: _headerStyle),
                        headerBackgroundColor: Colors.blue,
                        content: Column(
                          children: [
                            Text(
                                "Revisa los horarios disponibles para agendamiento de citas.\nRegistra una nueva cita, revisa citas pendientes o atendidas."),
                            Padding(padding: EdgeInsets.only(bottom: 10.0)),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(context, 'horariosAdd');
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'Ver horarios registrados',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(context, 'agendarCita');
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'Registrar nueva cita',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(context, 'verCitasR');
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'Ver citas pendientes',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(context, 'verCitasAt');
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'Ver citas atendidas',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      AccordionSection(
                        isOpen: false,
                        leftIcon:
                            const Icon(Icons.list_alt, color: Colors.white),
                        header: Text('Solicitudes de adopción',
                            style: _headerStyle),
                        headerBackgroundColor:
                            Color.fromARGB(255, 170, 124, 248),
                        content: Column(
                          children: [
                            Text(
                              'Revisa las solicitudes de adopción que han sido enviadas, mira las solicitudes aprobadas y negadas.',
                              textAlign: TextAlign.justify,
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(context, 'solicitudes');
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.photo_album,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'Ver solicitudes pendientes',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, 'solicitudesAprobadas');
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.photo_album,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'Ver solicitudes aprobadas',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, 'solicitudesRechazadas');
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.photo_album,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'Ver solicitudes rechazadas',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      AccordionSection(
                        isOpen: false,
                        leftIcon: const Icon(Icons.pets, color: Colors.white),
                        header: Text('Seguimiento de mascotas',
                            style: _headerStyle),
                        content: Column(
                          children: [
                            Text(
                              "Puedes realizar el seguimiento de las mascotas que han sido adoptadas.",
                              textAlign: TextAlign.justify,
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, 'seguimientoPrincipal');
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.verified,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'Realizar seguimiento',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        headerBackgroundColor:
                            Color.fromARGB(255, 240, 160, 39),
                      ),
                      AccordionSection(
                        isOpen: false,
                        leftIcon: const Icon(Icons.pets, color: Colors.white),
                        header: Text('Donaciones', style: _headerStyle),
                        content: Column(
                          children: [
                            Text(
                              "Registra las donaciones que han llegado o han salido de la fundación",
                              textAlign: TextAlign.justify,
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(context, 'donacionesInAdd');
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.verified,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'Registrar donacion recibida',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: flatButtonStyle,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, 'donacionesOutAdd');
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.verified,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'Registrar donacion saliente',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        headerBackgroundColor:
                            Color.fromARGB(255, 59, 243, 228),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // SizedBox(
            //   child: Image(
            //     image: AssetImage('assets/dog_an2.gif'),
            //   ),
            //   width: 200,
            // )
          ],
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
        Navigator.pushNamed(context, 'login');
    }
  }
}
