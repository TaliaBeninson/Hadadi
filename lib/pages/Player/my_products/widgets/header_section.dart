import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

Widget headerSection({required VoidCallback onFilterPressed}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          translate('my_products.headline'),
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xff000089),
            fontWeight: FontWeight.bold,
            fontFamily: 'Rubik',
          ),
        ),
        IconButton(
          icon: const Icon(Icons.tune, color: Color(0xff000089)),
          onPressed: onFilterPressed,
        ),
      ],
    ),
  );
}
