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
              Icons.pages,
              color: Colors.green,
            ),
            title: Text('Ver mascotas registradas'),
            onTap: () => Navigator.pushReplacementNamed(context, 'home'),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.app_registration,
              color: Colors.green,
            ),
            title: Text('Registrar nueva mascota'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'animal');
            },
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
                title: Text('Horarios registrados'),
                onTap: () {
                  //Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, 'horariosAdd');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.list_alt,
                  color: Colors.green,
                ),
                title: Text('Agendar citas'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'agendarCita');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.list_alt,
                  color: Colors.green,
                ),
                title: Text('Ver citas pendientes'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'verCitasAg');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: Text('Ver citas atendidas'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'verCitasAt');
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
                  Navigator.pushReplacementNamed(context, 'solicitudes');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: Text('Solicitudes Aprobadas'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, 'solicitudesAprobadas');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.clear,
                  color: Colors.green,
                ),
                title: Text('Solicitudes Rechazadas'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, 'solicitudesRechazadas');
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
              Navigator.pushReplacementNamed(context, 'seguimientoPrincipal');
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
                  Navigator.pushReplacementNamed(context, 'donacionesInAdd');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: Text('Ver donaciones recibidas'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'verDonacionesInAdd');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.add,
                  color: Colors.green,
                ),
                title: Text('Registrar donaciones salientes'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'donacionesOutAdd');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                title: Text('Ver donaciones salientes'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, 'verDonacionesOutAdd');
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
                    Navigator.pushReplacementNamed(context, 'registro');
                  },
                )
              : SizedBox(),
          ListTile(
            leading: Icon(
              Icons.app_registration,
              color: Colors.green,
            ),
            title: Text('Inicio'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'bienvenida');
            },
          ),
        ],
      ),
    );
  }
}
