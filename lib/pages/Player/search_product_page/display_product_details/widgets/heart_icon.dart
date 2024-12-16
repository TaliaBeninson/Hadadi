import 'package:flutter/material.dart';

class HeartIcon extends StatefulWidget {
  @override
  _HeartIconState createState() => _HeartIconState();
}

class _HeartIconState extends State<HeartIcon> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
            color: isFavorite ? Colors.red : Colors.black,
            size: 30,
          ),
        ],
      ),
    );
  }
}
