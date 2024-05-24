import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;


   CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,


  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 43,
      child: MaterialButton(
        onPressed: onPressed,
        color: Color(0xff071390),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(text, style: TextStyle(fontSize: 20),),
      ),
    );
  }
}
