import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Icon? prefixIcon;
  final void Function(String)? onChanged;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.obscureText = false,
    this.prefixIcon,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.disabled,
      onChanged: onChanged,
      maxLines: maxLines,
      textAlignVertical:
          maxLines == 1 ? TextAlignVertical.center : TextAlignVertical.top,
      decoration: InputDecoration(
        labelText: labelText,
        alignLabelWithHint: true,
        labelStyle: const TextStyle(
          fontFamily: 'Rubik',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF999999),
        ),
        hintText: labelText,
        hintStyle: const TextStyle(
          color: Color(0xFF999999),
          fontFamily: 'Rubik',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(
            color: Color(0xFFC1C3EE),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(
            color: Color(0xFFC1C3EE),
            width: 1.5,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
      obscureText: obscureText,
      style: const TextStyle(
        fontFamily: 'Rubik',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF606060),
      ),
    );
  }
}
