import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ButtonRound extends StatelessWidget {
  VoidCallback? onPressed;
  Icon? icon;
  String? btnText;
  double? iconWidth;


  ButtonRound({super.key, required this.onPressed,  this.icon, this.iconWidth, required this.btnText });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0,),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.blueGrey,
          // padding: EdgeInsets.symmetric(horizontal: 16),
          shape:  const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              side: BorderSide(
                color: Colors.blueGrey,
              )

          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(child: icon,),
            SizedBox(width: iconWidth),
            Text(btnText!,
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