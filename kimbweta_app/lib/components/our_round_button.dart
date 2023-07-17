import 'package:flutter/material.dart';

class OurRoundButton extends StatelessWidget {
  String? label;
  Icon? icon;
  VoidCallback onPressed;

  OurRoundButton({required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 3.5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          elevation: 20,
          backgroundColor: Colors.blueGrey,
          // padding: EdgeInsets.symmetric(horizontal: 16),
          shape:  const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              side: BorderSide(
                  color: Colors.blueGrey,
                  width: 3
              )

          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(child: icon, width: 35,),
            Text(label!,
              style: TextStyle(
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
