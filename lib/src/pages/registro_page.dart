import 'package:aministrador_app_v1/src/models/usuarios_model.dart';
import 'package:aministrador_app_v1/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:aministrador_app_v1/src/bloc/login_bloc.dart';
import 'package:aministrador_app_v1/src/bloc/provider.dart';
import 'package:aministrador_app_v1/src/providers/usuario_provider.dart';
import 'package:aministrador_app_v1/src/utils/utils.dart';
import 'package:flutter/services.dart';

class RegistroPage extends StatefulWidget {
  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  //const RegistroPage({Key? key}) : super(key: key);
  final usuarioProvider = new UsuarioProvider();

  final usuario = new UsuariosModel();

  late bool _passwordVisible;
  late bool _passwordVisible1;
  //TextEditingController _nombreUs = new TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
    _passwordVisible1 = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: MenuWidget(),
      body: Stack(
        children: [
          //Drawer(child: MenuWidget()),
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 230.0, //230
            ),
          ),
          Container(
            width: 390.0, //390
            height: 560.0, //540
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding: EdgeInsets.symmetric(vertical: 50.0), //80
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: [
                Text(
                  'Crear cuenta',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8.0, //60
                ),
                _crearNombreUs(bloc),
                SizedBox(
                  height: 8.0, //60
                ),
                _crearCedula(bloc),
                SizedBox(
                  height: 8.0, //60
                ),
                _crearEmail(bloc),
                SizedBox(
                  height: 8.0, //30
                ),
                _crearPassword(bloc),
                SizedBox(
                  height: 8.0,
                ),
                create_password_confirm(bloc),
                SizedBox(
                  height: 50.0,
                ),
                _crearBoton(bloc),
              ],
            ),
          ),
          //Text('Olvido la contrasena?'),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, 'home'),
            child: Text(
              'Cancelar registro.',
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.green),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electrónico',
              //counterText: snapshot.data,
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _crearNombreUs(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp("[0-9\-=@,\.;]")),
            ],
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              icon: Icon(Icons.person, color: Colors.green),
              //hintText: 'dany',
              labelText: 'Nombre de usuario',
              //counterText: snapshot.data,
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onChanged: bloc.changeName,
          ),
        );
      },
    );
  }

  Widget _crearCedula(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.cedulaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10)
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              icon: Icon(Icons.numbers, color: Colors.green),
              //hintText: 'dany',
              labelText: 'Número de cédula',
              //counterText: snapshot.data,
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onChanged: bloc.changeCedula,
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            //obscureText: true,
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.green),
              labelText: 'Contraseña',
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.green,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  //Crear nuevo text para confirmar la contasena
  Widget create_password_confirm(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordConfirmStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            //obscureText: true,
            obscureText: !_passwordVisible1,
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.green),
              labelText: 'Confirmar contraseña',
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible1 ? Icons.visibility : Icons.visibility_off,
                  color: Colors.green,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _passwordVisible1 = !_passwordVisible1;
                  });
                },
              ),
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onChanged: (value) => bloc.changePasswordConfirm(value),
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc) {
    //formValidStream
    //snapshot.hasData
    //true ? algo asi si true: algo asi si false
    return StreamBuilder(
      stream: bloc.formValidStream5,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Registrar'),
          ),
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 0.0,
              primary: Colors.green,
              textStyle: TextStyle(color: Colors.white)),
          onPressed: snapshot.hasData ? () => _register(bloc, context) : null,
        );
      },
    );
  }

  _register(LoginBloc bloc, BuildContext context) async {
    final info = await usuarioProvider.nuevoUsuario(
        bloc.email, bloc.password, bloc.name);
    if (info['ok']) {
      print(bloc.name);
      usuario.id = info['uid'];
      usuario.nombre = bloc.name;
      usuario.cedula = bloc.cedula;
      usuario.email = bloc.email;
      usuario.rol = Roles.administrador;
      usuarioProvider.crearUsuario(usuario);
      //Navigator.pushNamed(context, 'home');
      mostrarAlertaOk1(context, 'Se ha registrado con éxito.', 'home',
          'Información correcta');
    } else {
      //mostrarAlerta(context, info['mensaje']);
      mostrarAlerta(context, 'El correo electrónico ya existe.');
    }

    //Navigator.pushReplacementNamed(context, 'home');
  }

  Widget _crearFondo(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: 400.0,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
          Color.fromARGB(255, 22, 182, 62),
          Color.fromARGB(255, 25, 184, 64),
        ]),
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );
    return Stack(
      children: [
        fondoMorado,
        Positioned(top: 90.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, left: -30.0, child: circulo),
        Positioned(bottom: -50.0, right: -10.0, child: circulo),
        Positioned(bottom: 120.0, right: 20.0, child: circulo),
        Positioned(bottom: -50.0, left: -20.0, child: circulo),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: [
              Image.asset('assets/pet-care.png', height: 190),
              //Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
              SizedBox(height: 10.0, width: double.infinity),
            ],
          ),
        ),
      ],
    );
  }
}
