import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool outlined;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: outlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: textColor, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                text,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                text,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
