// import 'package:flutter/material.dart';
// import 'package:mecapp/components/resourcesDesing.dart';
// import 'dart:async';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:search_map_place/search_map_place.dart';
// import 'package:mecapp/components/color.dart';

// class Mapa extends StatefulWidget {
//   MapaState createState() => MapaState();
// }

// class MapaState extends State<Mapa> {
//   Completer<GoogleMapController> _controller = Completer();
//   //Location location = Location();
//   var currentLocation, destinationLocation;
//   Location location = new Location();
//   bool _serviceEnabled;
//   PermissionStatus _permissionGranted;
//   LocationData _locationData;
//   List<Marker> myMarker = [];
//   double latitude, longitude;
//   GoogleMapController mapController;
//   //List<double> coord = [];
//   LatLng coord;
//   //LatLng tappedPoint2;

//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );

//   static final CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);

//   Future<void> _goToMyLocation() async {
//     final GoogleMapController controller = await _controller.future;
//     LocationData currentLocation;
//     var location = new Location();
//     try {
//       currentLocation = await location.getLocation();
//       _handleTap(LatLng(currentLocation.latitude, currentLocation.longitude));
//     } on Exception {
//       currentLocation = null;
//     }
//     controller.animateCamera(CameraUpdate.newCameraPosition(
//       CameraPosition(
//         bearing: 0,
//         target: LatLng(currentLocation.latitude, currentLocation.longitude),
//         zoom: 17.0,
//       ),
//     ));
//   }

//   Future<void> _goToLocation(Geolocation geolocation) async {
//     final GoogleMapController controller = await _controller.future;
//     try {
//       controller.animateCamera(CameraUpdate.newLatLng(geolocation.coordinates));
//       /* controller
//           .animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0)); */
//       _handleTap(geolocation.coordinates);
//     } on Exception {
//       currentLocation = null;
//     }
//   }

//   getLocation() async {
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }

//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//     _locationData = await location.getLocation();
//   }

//   _handleTap(LatLng tappedPoint) {
//     //if (tappedPoint != null) {
//     print(tappedPoint);
//     setState(() {
//       myMarker = [];
//       myMarker.add(Marker(
//         markerId: MarkerId(tappedPoint.toString()),
//         position: tappedPoint,
//       ));
//       latitude = tappedPoint.latitude;
//       longitude = tappedPoint.longitude;
//     });
//     //}
//   }

//   @override
//   void initState() {
//     super.initState();
//     getLocation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: header('Ubicacion', context),
//         body: ListView(
//           children: [
//             SearchMapPlaceWidget(
//                 language: 'es',
//                 hasClearButton: true,
//                 placeType: PlaceType.address,
//                 placeholder: 'Buscar direccion',
//                 apiKey: "AIzaSyC-Q_fA_wCFeSGtvpdhsAjRu02HcjZwXqw",
//                 onSelected: (Place place) async {
//                   Geolocation geolocation = await place.geolocation;
//                   //print(geolocation.coordinates);
//                   _goToLocation(geolocation);
//                 }),
//             /* Padding(padding: EdgeInsets.symmetric(vertical: 10.0)), */
//             Container(
//               //color: Colors.blue,
//               alignment: Alignment.centerRight,
//               child: IconButton(
//                   icon: Icon(
//                     Icons.my_location,
//                     size: 30.0,
//                   ),
//                   onPressed: _goToMyLocation),
//             ),
//             Container(
//               height: MediaQuery.of(context).size.height * 0.6,
//               child: GoogleMap(
//                 mapType: MapType.normal,
//                 initialCameraPosition: _kGooglePlex,
//                 markers: Set.from(myMarker),
//                 onMapCreated: (GoogleMapController controller) {
//                   //mapController = controller;
//                   _controller.complete(controller);
//                 },
//                 //myLocationEnabled: true,
//                 onTap: _handleTap,
//               ),
//             ),
//             Text('Tus coordenadas'),
//             Container(
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: <Widget>[
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text('Latitud'),
//                         Text(latitude == null
//                             ? 'Sin ubicacion'
//                             : latitude.toString()),
//                         //Text('${tappedPoint2.latitude}'),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text('Longitud'),
//                         Text(longitude == null
//                             ? 'Sin ubicacion'
//                             : longitude.toString()),
//                         //Text('${tappedPoint2.longitude}'),
//                       ],
//                     )
//                   ]),
//             ),
//             Center(
//               child: Container(
//                   width: MediaQuery.of(context).size.width * 0.35,
//                   //padding: EdgeInsets.symmetric(vertical: 20.0),
//                   child: RaisedButton.icon(
//                     color: Theme.of(context).colorScheme.colorTur,
//                     onPressed: () async {
//                       if (myMarker.length != 0) {
//                         coord = LatLng(latitude, longitude);
//                         Navigator.of(context).pop(coord);
//                       } else {
//                         warningMessage('No ha seleccionado ninguna direccion');
//                       }
//                     },
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         side: BorderSide(
//                             color: Theme.of(context).colorScheme.colorTur,
//                             width: 1.0)),
//                     icon: Icon(
//                       Icons.save,
//                       color: Theme.of(context).colorScheme.colorBeige,
//                     ),
//                     label: Container(
//                         padding: EdgeInsets.symmetric(vertical: 10.0),
//                         child: Text('Guardar',
//                             style: TextStyle(
//                                 fontSize: 18.0,
//                                 color:
//                                     Theme.of(context).colorScheme.colorBeige))),
//                   )),
//             ),
//           ],
//         ));
//   }
// }