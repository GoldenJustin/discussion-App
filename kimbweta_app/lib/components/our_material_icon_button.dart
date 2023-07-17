import 'package:flutter/material.dart';

import '../constants/constants.dart';
class OurMaterialIconButton extends StatelessWidget {
  String? label;
  Icon? icon;
  VoidCallback onPressed;

  OurMaterialIconButton({super.key, required this.label, required this.icon,required this.onPressed});



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
        child: Row(
          children: [
            SizedBox(child: icon,),
            SizedBox(width: 5,),
            Text(
              label!,
              style: const TextStyle(
                  color: kMainWhiteColor,
                  letterSpacing: 3
              ),

            ),
          ],
        ),
      ),
    );
  }
}