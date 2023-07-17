import 'package:flutter/material.dart';

import '../constants/constants.dart';

void showSnack(context, message) {
  if (context != null) {
    final snackBar = SnackBar(
      content: Text(message.toString()),
      // shape: const CircleBorder(eccentricity: 76),
      // backgroundColor: kMainThemeAppColor,
      duration: Duration(seconds: 2),

    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
