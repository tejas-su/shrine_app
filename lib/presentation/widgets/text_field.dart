import 'package:flutter/material.dart';

import '../themes/theme.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconButton? suffixIcon;
  final Function(String)? onSubmitted;

  ///Bottom Padding
  final double bottom;

  ///Padding left
  final double left;

  ///Padding Right
  final double right;

  ///Hint text
  final String hintText;

  ///Hide Password
  final bool obscureText;

  ///Color of the text field
  final Color? color;

  ///max Lines for the text
  final int maxLines;
  const InputTextField(
      {super.key,
      this.onSubmitted,
      this.controller,
      this.bottom = 0,
      this.left = 80,
      this.right = 80,
      required this.hintText,
      this.suffixIcon,
      this.color = whiteBG,
      this.maxLines = 1,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: left, right: right, bottom: bottom),
      child: Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: TextField(
          onSubmitted: onSubmitted,
          maxLines: maxLines,
          controller: controller,
          showCursor: true,
          obscureText: obscureText,
          decoration: InputDecoration(
              labelStyle: const TextStyle(color: black),
              label: Text(hintText),
              suffixIcon: suffixIcon,
              hintText: hintText,
              border: const OutlineInputBorder(borderSide: BorderSide.none)),
        ),
      ),
    );
  }
}
