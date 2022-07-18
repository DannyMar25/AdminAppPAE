import 'package:aministrador_app_v1/src/bloc/provider.dart';
import 'package:aministrador_app_v1/src/pages/agendarCitas_page.dart';
import 'package:aministrador_app_v1/src/pages/animal_page.dart';
import 'package:aministrador_app_v1/src/pages/bienvenida_page.dart';
import 'package:aministrador_app_v1/src/pages/donacionesIn_page.dart';
import 'package:aministrador_app_v1/src/pages/donacionesOutAdd_page.dart';
import 'package:aministrador_app_v1/src/pages/donacionesOut_page.dart';
import 'package:aministrador_app_v1/src/pages/forgotPassword_page.dart';
import 'package:aministrador_app_v1/src/pages/horariosR_page.dart';
import 'package:aministrador_app_v1/src/pages/horarios_page.dart';
import 'package:aministrador_app_v1/src/pages/home_page.dart';
import 'package:aministrador_app_v1/src/pages/login_page.dart';
import 'package:aministrador_app_v1/src/pages/perfilUsuario_page.dart';
import 'package:aministrador_app_v1/src/pages/registro_page.dart';
import 'package:aministrador_app_v1/src/pages/seguimiento_archivos_page.dart';
import 'package:aministrador_app_v1/src/pages/seguimiento_desparasitacion_page.dart';
import 'package:aministrador_app_v1/src/pages/seguimiento_fotos_page.dart';
import 'package:aministrador_app_v1/src/pages/seguimiento_informacion_page.dart.dart';
import 'package:aministrador_app_v1/src/pages/seguimiento_page.dart';
import 'package:aministrador_app_v1/src/pages/seguimiento_vacunas_page.dart';
import 'package:aministrador_app_v1/src/pages/solicitud_datosPer_page.dart';
import 'package:aministrador_app_v1/src/pages/solicitud_domicilio_page.dart';
import 'package:aministrador_app_v1/src/pages/solicitud_observacion_page.dart';
import 'package:aministrador_app_v1/src/pages/solicitud_pdf_page.dart';
import 'package:aministrador_app_v1/src/pages/solicitud_relacionAn_page.dart';
import 'package:aministrador_app_v1/src/pages/solicitud_situacionFam_page.dart';
import 'package:aministrador_app_v1/src/pages/solicitudesMain_page.dart';
import 'package:aministrador_app_v1/src/pages/solicitudes_aprobadasMain_page.dart';
import 'package:aministrador_app_v1/src/pages/solicitudes_aprobadas_page.dart';
import 'package:aministrador_app_v1/src/pages/solicitudes_page.dart';
import 'package:aministrador_app_v1/src/pages/solicitudes_rechazadasMain_page.dart';
import 'package:aministrador_app_v1/src/pages/solicitudes_rechazadas_page.dart';
import 'package:aministrador_app_v1/src/pages/soporte_page.dart';
import 'package:aministrador_app_v1/src/pages/ubicacion_page.dart';
import 'package:aministrador_app_v1/src/pages/verCitasAt_page.dart';
import 'package:aministrador_app_v1/src/pages/verCitasR.dart';
import 'package:aministrador_app_v1/src/pages/verCitas_page.dart';
import 'package:aministrador_app_v1/src/pages/verDonacionesIn1_page.dart';
import 'package:aministrador_app_v1/src/pages/verDonacionesIn_page.dart';
import 'package:aministrador_app_v1/src/pages/verDonacionesOut1_page.dart';
import 'package:aministrador_app_v1/src/pages/verDonacionesOut_page.dart';
import 'package:aministrador_app_v1/src/pages/ver_archivo_page.dart';
import 'package:aministrador_app_v1/src/pages/ver_foto_page.dart';
import 'package:aministrador_app_v1/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //Antes
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    print(prefs.token);
    final email = prefs.email;
    final rol = prefs.rol;

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
            Locale('en', 'US'),
            Locale('es', 'ES'),
          ],
          initialRoute: email == '' ? 'login' : 'home',
          routes: {
            'login': (_) => LoginPage(),
            'registro': (_) => RegistroPage(),
            'home': (_) => HomePage(),
            'animal': (_) => AnimalPage(),
            'bienvenida': (_) => BienvenidaPage(),
            'ubicacion': (_) => UbicacionPage(),
            'citasAdd': (_) => HorariosPage(),
            'horariosAdd': (_) => HorariosAgregados(),
            'verCitasAg': (_) => VerCitasPage(),
            'verCitasR': (_) => VerCitasRegistradas(),
            'agendarCita': (_) => AgendarCitasPage(),
            'verCitasAt': (_) => VerCitasAtendidasPage(),
            'donacionesInAdd': (_) => IngresoDonacionesInPage(),
            'verDonacionesInAdd': (_) => VerDonacionesInAddPage(),
            'verDonacionesIn1': (_) => VerDonacionesIn1Page(),
            ForgotPassword.id: (context) => ForgotPassword(),
            'donacionesOutAdd': (_) => IngresoDonacionesOutPage(),
            //'enviarMail': (_) => EmailSender(),
            'enviarMail': (_) => SoportePage(),
            'perfilUser': (_) => PerfilUsuarioPage(),
            'DonacionesOutAdd1': (_) => IngresoDonacionesOutAddPage(),
            'verDonacionesOutAdd': (_) => VerDonacionesOutAddPage(),
            'verDonacionesOutAdd1': (_) => VerDonacionesOut1Page(),
            'seguimientoPrincipal': (_) => SeguimientoPrincipalPage(),
            'solicitudes': (_) => SolicitudesPage(),
            'verSolicitudesMain': (_) => SolicitudesMainPage(),
            'solicitudesAprobadas': (_) => SolicitudesAprobadasPage(),
            'verSolicitudAprobada': (_) => SolicitudAprobadaMainPage(),
            'solicitudesRechazadas': (_) => SolicitudesRechazadasPage(),
            'verSolicitudRechazada': (_) => SolicitudRechazadaMainPage(),
            'datosPersonales': (_) => DatosPersonalesPage(),
            'situacionFam': (_) => SituacionFamiliarPage(),
            'domicilio': (_) => DomicilioPage(),
            'relacionAnim': (_) => RelacionAnimalPage(),
            'observacionSolicitud': (_) => ObservacionFinalPage(),
            'seguimientoInfo': (_) => InformacionSeguimientoPage(),
            'verRegistroVacunas': (_) => VerRegistroVacunasPage(),
            'verRegistroDesp': (_) => VerRegistroDespPage(),
            'verEvidenciaP1': (_) => VerEvidenciaFotosPage(),
            'verFotoEvidencia': (_) => VerFotoEvidenciaPage(),
            'verEvidenciaP2': (_) => VerEvidenciaArchivosPage(),
            'verArchivoEvidencia': (_) => VerArchivoEvidenciaPage(),
            'crearPDF': (_) => CrearSolicitudPdfPage(),
            'soporte': (_) => SoportePage(),
          },
          theme: ThemeData(primaryColor: Colors.deepPurple)),
    );
  }
}
