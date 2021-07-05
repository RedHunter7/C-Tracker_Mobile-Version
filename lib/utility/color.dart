import 'dart:ui';
import 'package:flutter/material.dart';

Map<int, Color> greenColor = {
  50: Color.fromRGBO(45, 98, 93, .1),
  100: Color.fromRGBO(45, 98, 93, .2),
  200: Color.fromRGBO(45, 98, 93, .3),
  300: Color.fromRGBO(45, 98, 93, .4),
  400: Color.fromRGBO(45, 98, 93, .5),
  500: Color.fromRGBO(45, 98, 93, .6),
  600: Color.fromRGBO(45, 98, 93, .7),
  700: Color.fromRGBO(45, 98, 93, .8),
  800: Color.fromRGBO(45, 98, 93, .9),
  900: Color.fromRGBO(45, 98, 93, 1),
};
MaterialColor primaryColor = MaterialColor(0xFF2D625D, greenColor);

Color secondaryColor = Color.fromRGBO(7, 171, 190, .3);
Color tertiaryColor = Color.fromRGBO(158, 207, 217, .3);
Color neutralColor = Color.fromRGBO(255, 255, 255, 1);

List<Color> dataCaseColor = [
  Color.fromRGBO(213, 158, 245, 1),
  Color.fromRGBO(254, 255, 137, 1),
  Color.fromRGBO(129, 241, 220, 1),
  Color.fromRGBO(255, 150, 166, 1),
];