import 'dart:ui';
import 'package:flutter/material.dart';

class TextStylesWidget {

  static TextStyle styleWithOut(double size, Color color, [FontWeight? grosor = FontWeight.normal]) {
    return TextStyle(fontSize: size, color: color, fontWeight: grosor);
  }
}


class TextConstructor{
  static Text styleTxt(String title, double size, Color color, [TextAlign? align = TextAlign.start, FontWeight? grosor = FontWeight.normal]) {
    return Text(
      title,
      style: TextStylesWidget.styleWithOut(size, color, grosor),
      textAlign: align,
    );
  }
}
