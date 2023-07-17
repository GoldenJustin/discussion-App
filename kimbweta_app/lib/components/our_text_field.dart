import 'package:flutter/material.dart';
import '../constants/constants.dart';

class OurTextField extends StatelessWidget {

  String? hintText;
  Icon? prefixIcon;
  Widget? suffixIcon;
  TextEditingController? controller;
  TextStyle textStyle =  const TextStyle(color: kMainWhiteColor);
  String? Function(String?)? validator;
  TextInputType? keyboardType;
  String? Function(String?)? onChanged;
  bool obscuredText;



  OurTextField({
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    required this.obscuredText,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        style: const TextStyle(
            color: kMainWhiteColor
        ),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: textStyle,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
            borderSide: BorderSide(
                width: 3,
                color:kMainThemeAppColor,
                style: BorderStyle.solid,
            ),
          ),
          border: OutlineInputBorder(

            borderRadius: BorderRadius.circular(40.0),
            borderSide:  const BorderSide(
                color: Colors.red,
                width: 5.0,
                style: BorderStyle.solid,
            ),
          ),

        ),

        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        onChanged: onChanged,
        obscureText: obscuredText,


      ),
    );
  }
}

