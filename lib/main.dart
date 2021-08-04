import 'package:aministrador_app_v1/src/bloc/provider.dart';
import 'package:aministrador_app_v1/src/pages/animal_page.dart';
import 'package:aministrador_app_v1/src/pages/bienvenida_page.dart';
import 'package:aministrador_app_v1/src/pages/horariosR_page.dart';
import 'package:aministrador_app_v1/src/pages/horarios_page.dart';
import 'package:aministrador_app_v1/src/pages/home_page.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/pages/registro_page.dart';
import 'package:aministrador_app_v1/src/pages/ubicacion_page.dart';
import 'package:aministrador_app_v1/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter/material.dart';
//import 'package:formvalidation/src/pages/producto_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    print(prefs.token);

    return Provider(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', 'US'), // English, no country code
            Locale('es', 'ES'), // Spanish, no country code
          ],
          initialRoute: 'login',
          routes: {
            'login': (_) => LoginPage(),
            'registro': (_) => RegistroPage(),
            'home': (_) => HomePage(),
            'animal': (_) => AnimalPage(),
            'bienvenida': (_) => BienvenidaPage(),
            'ubicacion': (_) => UbicacionPage(),
            'citasAdd': (_) => HorariosPage(),
            'horariosAdd': (_) => HorariosAgregados()
          },
          theme: ThemeData(primaryColor: Colors.deepPurple)),
    );
  }
}
