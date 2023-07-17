import 'package:flutter/material.dart';
class OurMaterialButton extends StatelessWidget {
  String? label;
  VoidCallback onPressed;

   OurMaterialButton({super.key, required this.label, required this.onPressed});



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(40, 15, 40, 15),
      child: MaterialButton(
        elevation: 10,
        color: Colors.blueGrey,
        height: 50,
        minWidth: 500,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40)),
        onPressed: onPressed,
        child: Text(
          label!,
          style: TextStyle(color: Colors.white, fontSize: 20),

        ),
      ),
    );
  }
}