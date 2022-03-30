import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/menu-img.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.pages,
              color: Colors.blue,
            ),
            title: Text('Ver mascotas registradas'),
            onTap: () => Navigator.pushReplacementNamed(context, 'home'),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.app_registration,
              color: Colors.blue,
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
            title: Text('Citas'),
            children: [
              ListTile(
                leading: Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
                title: Text('Agregar horarios para visitas'),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, 'citasAdd'),
              ),
              ListTile(
                leading: Icon(
                  Icons.app_registration,
                  color: Colors.blue,
                ),
                title: Text('Ver Horarios registrados'),
                onTap: () {
                  //Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, 'horariosAdd');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.list_alt,
                  color: Colors.blue,
                ),
                title: Text('Agendar nueva cita'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'agendarCita');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.list_alt,
                  color: Colors.blue,
                ),
                title: Text('Ver citas agendadas'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'verCitasAg');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                title: Text('Ver citas atendidas'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'verCitasAt');
                },
              ),
            ],
            leading: Icon(
              Icons.meeting_room,
              color: Colors.blue,
            ),
          ),
          //aqui termina el nuevo codigo
          Divider(),
          ExpansionTile(
            title: Text('Solicitudes de adopcion'),
            children: [
              ListTile(
                leading: Icon(
                  Icons.inventory,
                  color: Colors.blue,
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
                  color: Colors.blue,
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
                  color: Colors.blue,
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
              color: Colors.blue,
            ),
          ),
          Divider(),
          ExpansionTile(
            title: Text('Seguimiento'),
            children: [
              ListTile(
                leading: Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
                title: Text('Adopciones'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, 'seguimientoPrincipal');
                },
              ),
              // ListTile(
              //   leading: Icon(
              //     Icons.check,
              //     color: Colors.blue,
              //   ),
              //   title: Text('Verificar seguiemiento'),
              //   onTap: () {
              //     Navigator.pushReplacementNamed(context, 'seguimientoP2');
              //   },
              // ),
            ],
            leading: Icon(
              Icons.assignment,
              color: Colors.blue,
            ),
          ),

          Divider(),
          ExpansionTile(
            title: Text('Donaciones'),
            children: [
              ListTile(
                leading: Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
                title: Text('Registrar donaciones recibidas'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'donacionesInAdd');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                title: Text('Ver donaciones recibidas'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'verDonacionesInAdd');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
                title: Text('Registrar donaciones salientes'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'donacionesOutAdd');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.check,
                  color: Colors.blue,
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
              color: Colors.blue,
            ),
          ),
          Divider(),

          ListTile(
            leading: Icon(
              Icons.room,
              color: Colors.blue,
            ),
            title: Text('Ver ubicacion'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'ubicacion');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.app_registration,
              color: Colors.blue,
            ),
            title: Text('Registrar administrador'),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'registro');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.app_registration,
              color: Colors.blue,
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
