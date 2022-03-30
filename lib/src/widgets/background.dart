import 'dart:math';

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final boxDecoration = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [
          0.2,
          0.8
        ],
        colors: [
          Color(0xff2E305F),
          Color(0xff8CC63F)
        ]), //color rosa Color(0xff202333)
  );
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Purple gradient
        Container(decoration: boxDecoration),

        //Pink box
        Positioned(
          top: -100,
          //left: -2,
          child: _PinkBox(),
        )
      ],
    );
  }
}

class _PinkBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 5,
      child: Container(
        width: 360,
        height: 360,
        decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.circular(80),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(140, 198, 63, 1),
            Color.fromRGBO(140, 198, 63, 1),
          ]),
        ),
      ),
    );
  }
}
