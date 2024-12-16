import 'package:flutter/material.dart';

Widget buildEmojiIcon(String emoji) {
  IconData iconData;
  Color emojiColor;

  switch (emoji) {
    case 'heart':
      iconData = Icons.favorite;
      emojiColor = const Color(0xFFFF5A1F);
      break;
    case 'smile':
      iconData = Icons.emoji_emotions;
      emojiColor = const Color(0xFF4C52CC);
      break;
    case 'victory':
      iconData = Icons.emoji_events;
      emojiColor = const Color(0xFFF7B500);
      break;
    default:
      iconData = Icons.help;
      emojiColor = Colors.grey;
  }

  return Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: const Color(0xFFF2F2F2),
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFFD7D7D7).withOpacity(0.8),
          offset: const Offset(8, 8),
          blurRadius: 16,
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.8),
          offset: const Offset(-8, -8),
          blurRadius: 16,
        ),
      ],
    ),
    child: Icon(
      iconData,
      color: emojiColor,
      size: 20,
    ),
  );
}