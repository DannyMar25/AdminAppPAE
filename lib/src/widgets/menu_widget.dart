import 'package:aministrador_app_v1/src/pages/forgotPassword_page.dart';
import 'package:aministrador_app_v1/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  final prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    final rol = prefs.rol;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/pet-care.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.green,
            ),
            title: Text('Inicio'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushNamed(context, 'bienvenida');
            },
          ),
          ExpansionTile(
            title: Text('Mascotas'),
            leading: Icon(
              Icons.pets,
              color: Colors.green,
            ),
            children: [
              ListTile(
                leading: Icon(
                  Icons.app_registration,
                  color: Colors.green,
                ),
                title: Text('Registrar nueva mascota'),
                onTap: () {
                  //Navigator.pop(context);
                  Navigator.pushNamed(context, 'animal');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.pages,
                  color: Colors.green,
                ),
                title: Text('Ver mascotas registradas'),
                onTap: () => Navigator.pushNamed(context, 'home'),
              ),
            ],
          ),

          Divider(),
          //Creacion de un submenu dentro
          ExpansionTile(
            //textColor: Colors.green,
            title: Text('Citas'),
            children: [
              ListTile(
                leading: Icon(
                  Icons.app_registration,
                  color: Colors.green,
                ),
                title: Text('Ver horarios registrados'),
                onTap: () {
                  //Navigator.pop(context);
                  Navigator.pushNamed(context, 'horariosAdd');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.list_alt,
                  color: Colors.green,
                ),
                title: Text('Agendar cita'),
                onTap: () {
                  Navigator.pushNamed(context, 'agendarCita');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.list_alt,
                  color: Colors.green,
                ),
                title: Text('Ver citas pendientes'),
                onTap: () {
                  Navigator.pushNamed(context, 'verCitasAg');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: Text('Ver citas atendidas'),
                onTap: () {
                  Navigator.pushNamed(context, 'verCitasAt');
                },
              ),
            ],
            leading: Icon(
              Icons.meeting_room,
              color: Colors.green,
            ),
          ),
          //aqui termina el nuevo codigo
          Divider(),
          ExpansionTile(
            title: Text('Solicitudes de adopción'),
            children: [
              ListTile(
                leading: Icon(
                  Icons.inventory,
                  color: Colors.green,
                ),
                title: Text('Solicitudes Pendientes'),
                onTap: () {
                  // Navigator.pushReplacementNamed(context, 'enviarMail');
                  Navigator.pushNamed(context, 'solicitudes');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: Text('Solicitudes Aprobadas'),
                onTap: () {
                  Navigator.pushNamed(context, 'solicitudesAprobadas');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.clear,
                  color: Colors.green,
                ),
                title: Text('Solicitudes Rechazadas'),
                onTap: () {
                  Navigator.pushNamed(context, 'solicitudesRechazadas');
                },
              ),
            ],
            leading: Icon(
              Icons.assignment,
              color: Colors.green,
            ),
          ),
          Divider(),
          // ExpansionTile(
          //   title: Text('Seguimiento'),
          //   children: [
          ListTile(
            leading: Icon(
              Icons.assignment,
              color: Colors.green,
            ),
            title: Text('Seguimiento'),
            onTap: () {
              Navigator.pushNamed(context, 'seguimientoPrincipal');
            },
          ),
          //  ],
          //   leading: Icon(
          //     Icons.assignment,
          //     color: Colors.green,
          //   ),
          // ),

          Divider(),
          ExpansionTile(
            title: Text('Donaciones'),
            children: [
              ListTile(
                leading: Icon(
                  Icons.add,
                  color: Colors.green,
                ),
                title: Text('Registrar donaciones recibidas'),
                onTap: () {
                  Navigator.pushNamed(context, 'donacionesInAdd');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: Text('Ver donaciones recibidas'),
                onTap: () {
                  Navigator.pushNamed(context, 'verDonacionesInAdd');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.add,
                  color: Colors.green,
                ),
                title: Text('Registrar donaciones salientes'),
                onTap: () {
                  Navigator.pushNamed(context, 'donacionesOutAdd');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: Text('Ver donaciones salientes'),
                onTap: () {
                  Navigator.pushNamed(context, 'verDonacionesOutAdd');
                },
              ),
            ],
            leading: Icon(
              Icons.assignment,
              color: Colors.green,
            ),
          ),
          Divider(),
          rol == 'SuperAdministrador'
              ? ListTile(
                  leading: Icon(
                    Icons.app_registration,
                    color: Colors.green,
                  ),
                  title: Text('Registrar administrador'),
                  onTap: () {
                    //Navigator.pop(context);
                    Navigator.pushNamed(context, 'registro');
                  },
                )
              : SizedBox(),
          rol == 'Administrador'
              ? ListTile(
                  leading: Icon(
                    Icons.app_registration,
                    color: Colors.green,
                  ),
                  title: Text('Restablecer contraseña'),
                  onTap: () {
                    //Navigator.pop(context);
                    Navigator.pushNamed(context, 'perfilUser');
                  },
                )
              : SizedBox(),

          Padding(padding: EdgeInsets.only(top: 160.0)),
          Text(
            '2022 Versión: 0.0.1',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
