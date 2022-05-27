import 'dart:async';

import 'package:aministrador_app_v1/src/providers/animales_provider.dart';
import 'package:aministrador_app_v1/src/widgets/menu_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UbicacionPage extends StatefulWidget {
  // const UbicacionPage({Key? key}) : super(key: key);
  var data;
  final firestoreInstance = FirebaseFirestore.instance;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-0.29732374301539083, -78.48033408388217),
    zoom: 14.4746,
  );

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  _UbicacionPageState createState() => _UbicacionPageState();
}

class _UbicacionPageState extends State<UbicacionPage> {
  Completer<GoogleMapController> _controller = Completer();

  late double latitude, longitude;
  final animalProvider = new AnimalesProvider();
  late DocumentSnapshot datosUbic;

  List<Marker> myMarker = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicacion Page'),
      ),
      drawer: MenuWidget(),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: UbicacionPage._kGooglePlex,
        markers: Set.from(myMarker),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: _handleTap,
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
      floatingActionButton: _crearBoton(),
    );
  }

  _handleTap(LatLng tappedPoint) {
    //if (tappedPoint != null) {
    print(tappedPoint);
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
      ));
      latitude = tappedPoint.latitude;

      longitude = tappedPoint.longitude;
    });
    //}
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller
  //       .animateCamera(CameraUpdate.newCameraPosition(UbicacionPage._kLake));
  // }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          return Colors.deepPurple;
        }),
      ),
      label: Text('Ver ubicacion'),
      icon: Icon(Icons.room),
      autofocus: true,
      onPressed: () {
        //setGPS(1, "65iRhtvZxeKT9DUb8aUu");
        leerUbicacion();
      },
    );
  }

  void setGPS(int getData, String id) {
    //ProductoModel producto;
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseReference prodRef = ref.child("gps");
    DatabaseReference urlRef = prodRef.child("Test");
    urlRef.update({"GetDataGPS": getData, "id": id});
  }

  void leerUbicacion() async {
    final GoogleMapController controller = await _controller.future;
    var data;

    FirebaseFirestore.instance
        .collection('clients')
        .doc('65iRhtvZxeKT9DUb8aUu')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        print('Document data: ${documentSnapshot.data()}');
        data = documentSnapshot.data();
        print(data['posicionActual']);
        var posicion = data['posicionActual'];
        var latlong = LatLng(posicion['lat'], posicion['long']);
        _handleTap(latlong);
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: LatLng(posicion['lat'], posicion['long']),
            zoom: 17.0,
          ),
        ));
      }
    });
  }

  // CameraPosition _verUbicacionR() {
  //   //final GoogleMapController controller = await _controller.future;
  //   var data;
  //   var posicion;

  //   FirebaseFirestore.instance
  //       .collection('clients')
  //       .doc('65iRhtvZxeKT9DUb8aUu')
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       print('Document exists on the database');
  //       print('Document data: ${documentSnapshot.data()}');
  //       data = documentSnapshot.data();
  //       print(data['posicionRegistrada']);
  //       posicion = data['posicionRegistrada'];
  //     }
  // //   });
  //   return CameraPosition(
  //     target: LatLng(posicion['lat'], posicion['long']),
  //     zoom: 14.4746,
  //   );
  // }
}
