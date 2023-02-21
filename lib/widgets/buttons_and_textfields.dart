import 'dart:ui';
import 'package:flutter/material.dart';

TextStyle buildTextStyle({required Color? color}) {
  return TextStyle(
      color: color,
      fontStyle: FontStyle.italic,
      wordSpacing: 30,
      fontSize: 20);
}

ButtonStyle myBuildButtonStyle() {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.orange),
    shape: MaterialStateProperty.all(
        const StadiumBorder(side: BorderSide(style: BorderStyle.solid))),
    side:
    MaterialStateProperty.all(const BorderSide(color: Colors.deepOrange)),
    padding: MaterialStateProperty.all(const EdgeInsetsDirectional.all(8)),
  );
}

InputDecoration textInputDecoration(
    {required String labelText, required Widget? icon}) {
  return InputDecoration(
    labelText: labelText,
    //hintText: '',
    fillColor: Colors.orangeAccent,
    filled: true,
    prefixIcon: icon,
    border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(40))),
  );
}

