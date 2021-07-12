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
          ListTile(
            leading: Icon(
              Icons.meeting_room,
              color: Colors.blue,
            ),
            title: Text('Ver citas'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.assignment,
              color: Colors.blue,
            ),
            title: Text('Ver solicitudes de adopcion'),
            onTap: () {},
          ),
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
