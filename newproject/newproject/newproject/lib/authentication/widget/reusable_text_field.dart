import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/authentication_repository.dart';

// ignore: must_be_immutable
class ReusableTextField extends StatelessWidget {
  ReusableTextField(
      {Key? key,
      this.suffixIcon,
      this.validator,
      required this.controller,
      required this.icon,
      required this.text,
      required this.forPaswword,
      required this.textInputType})
      : super(key: key);
  final TextEditingController controller;
  String? Function(String?)? validator;
  final String text;
  final IconData icon;
  final bool forPaswword;
  final TextInputType textInputType;
  Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: forPaswword
          ? Provider.of<AuthenticationRepository>(context, listen: false)
                  .isSecure
              ? true
              : false
          : false,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),
        labelText: text,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
      keyboardType: textInputType,
      validator: validator,
    );
  }
}
