import 'package:flutter/material.dart';

import '../../colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ScrollController scrollController;

  const CustomTextField({
    super.key,
    required this.scrollController,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: bgColor),
      onEditingComplete: () {
        scrollController.jumpTo(0.5);
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: logoColor,
        hintText: hintText,
        hintStyle: const TextStyle(color: secondaryColor),
        border: const UnderlineInputBorder(),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: secondaryColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: bgColor),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
      ),
      cursorColor: secondaryColor,
    );
  }
}
