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
                  Icons.list_alt,
                  color: Colors.blue,
                ),
                title: Text('Ver citas agendadas'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                title: Text('Ver citas atendidas'),
                onTap: () {},
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
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                title: Text('Solicitudes Aprobadas'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.clear,
                  color: Colors.blue,
                ),
                title: Text('Solicitudes Rechazadas'),
                onTap: () {},
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
            title: Text('Regresar'),
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
