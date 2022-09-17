import 'package:flutter/material.dart';

import '../../component/const.dart';

// ignore: must_be_immutable
class PrimaryBottom extends StatelessWidget {
  PrimaryBottom(
      {Key? key, required this.name, this.fontSize, required this.onPressed})
      : super(key: key);

  final String name;
  final VoidCallback onPressed;
  double? fontSize;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.08,
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.064, vertical: size.height * 0.03),
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black38;
              }

              return const Color(mainColor);
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            name,
            style: TextStyle(color: Colors.white, fontSize: fontSize ?? 17),
          )),
    );
  }
}
