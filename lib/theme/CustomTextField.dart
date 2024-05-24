import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Icon icon;


  const CustomTextField({
    Key? key,
    required this.title,
    required this.icon,

  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      child: TextField(
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.black),
          ),
          labelText: title,
          labelStyle: TextStyle(fontSize: 20, color: Colors.black),
          prefixIcon: icon,
          contentPadding: EdgeInsets.only(top: 12, bottom: 12),

        ),
      ),
    );
  }
}
