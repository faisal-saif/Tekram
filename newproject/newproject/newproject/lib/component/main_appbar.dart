import 'package:flutter/material.dart';

AppBar mainAppBar(Size size, String title) {
  return AppBar(
    toolbarHeight: size.height * 0.2,
    backgroundColor: Colors.white,
    elevation: 1,
    title: Container(
      height: size.height * 0.2,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.13),
            child: Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 19),
            ),
          ),
        ],
      ),
    ),
  );
}
