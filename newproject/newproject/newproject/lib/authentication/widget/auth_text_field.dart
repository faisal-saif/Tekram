import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repository/authentication_repository.dart';

class AuthTextField extends StatelessWidget {
  AuthTextField(
      {Key? key,
      required this.controller,
      required this.forPassword,
      this.suffixIcon,
      this.validator,
      required this.labelText,
      required this.textInputType})
      : super(key: key);
  final TextEditingController controller;
  final String labelText;
  final TextInputType textInputType;
  Widget? suffixIcon;
  final bool forPassword;
  String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.064, vertical: size.height * 0.01),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(0, 10),
            blurRadius: 10,
            color: Colors.black.withAlpha(8))
      ]),
      child: TextFormField(
        controller: controller,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: forPassword
            ? Provider.of<AuthenticationRepository>(context, listen: false)
                    .isSecure
                ? true
                : false
            : false,
        keyboardType: textInputType,
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.black38),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12)),
            //label: Text(labelText),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12))),
      ),
    );
  }
}
