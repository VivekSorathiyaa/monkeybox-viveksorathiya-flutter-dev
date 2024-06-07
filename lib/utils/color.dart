import 'package:flutter/material.dart';

// Function to generate a MaterialColor from a single color
MaterialColor generateMaterialColor(Color color) {
  final Map<int, Color> swatch = {
    50: color.withOpacity(.1),
    100: color.withOpacity(.2),
    200: color.withOpacity(.3),
    300: color.withOpacity(.4),
    400: color.withOpacity(.5),
    500: color.withOpacity(.6),
    600: color.withOpacity(.7),
    700: color.withOpacity(.8),
    800: color.withOpacity(.9),
    900: color.withOpacity(1),
  };
  return MaterialColor(color.value, swatch);
}

final MaterialColor primaryBlack = generateMaterialColor(Colors.black);

final MaterialColor primaryWhite = generateMaterialColor(Colors.white);

const Color backgroundColor = Color(0xffF7F7FB);
const Color primaryOrange = Color(0xffFA7F3A);
const Color primaryLightGrey = Color(0xffEEEEF2);
const Color lightGreyColor = Color(0xffE9E9E9);
