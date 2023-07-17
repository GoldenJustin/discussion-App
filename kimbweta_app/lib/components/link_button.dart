import 'package:flutter/material.dart';

import '../constants/constants.dart';
class LinkButton extends StatelessWidget {
  String? normaltext;
  String? linkedText;
  VoidCallback onTap;


  LinkButton({
    this.normaltext,
    this.linkedText,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          style: const TextStyle(
            color: kMainWhiteColor,

          ),
          normaltext!,
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            linkedText!,
            style: const TextStyle(
                color: kMainThemeAppColor,
                fontWeight: FontWeight.bold

            ),
          ),
        ),
      ],
    );
  }
}