import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: screenWidth * 0.35,
          height: 1,
          color: const Color(0xffC1C3EE),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Rubik',
              color: Color(0xff4C52CC),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Container(
          width: screenWidth * 0.35,
          height: 1,
          color: const Color(0xffC1C3EE),
        ),
      ],
    );
  }
}
