import 'package:flutter/material.dart';
import 'package:kimbweta_app/constants/constants.dart';




class CustomInputField extends StatelessWidget {
  const CustomInputField({super.key,
    this.textInputAction,
    this.onSubmitted,
    this.controller,
    this.keyboardType,
    this.isPassword = false,
    this.hintText,
  });

  final bool isPassword;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      controller: controller,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      cursorColor: kMainThemeAppColor,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: kMainThemeAppColor,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      ),
    );
  }
}
