import 'package:flutter/material.dart';
import '../core/text_styles.dart';

class AppBarWidget {

  static AppBar appBarPersonalizado(String title, double size, Color color, [TextAlign? align = TextAlign.start, FontWeight? grosor = FontWeight.normal]) {
    return AppBar(
      title: TextConstructor.styleTxt(title, size, color, align, grosor),
      backgroundColor: Colors.pink,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}
