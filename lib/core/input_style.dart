import 'package:flutter/material.dart';

class InputStyleWidget {
  static InputDecoration inputDecorationStyle(text, variable) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black),
      suffixIcon: variable
          ? const Icon(Icons.check_circle_outlined, color: Colors.green)
          : const Icon(Icons.cancel_outlined, color: Colors.red),
    );
  }
}

class InputStyleBasic {
  static InputDecoration inputDecorationSimple(text) {

    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black),
    );
  }
}
