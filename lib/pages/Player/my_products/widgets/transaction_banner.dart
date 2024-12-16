import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

Widget transactionTypeLabel(String type, bool isHebrew) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
    decoration: BoxDecoration(
      color: (type == 'Turbo' ? const Color(0xFFFF5A1F) : const Color(0xFFF7B500)),
      borderRadius: isHebrew
          ? const BorderRadius.only(
        topLeft: Radius.circular(22),
        bottomRight: Radius.circular(22),
      )
          : const BorderRadius.only(
        topRight: Radius.circular(22),
        bottomLeft: Radius.circular(22),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          (type == 'Turbo' ? Icons.flash_on : Icons.link),
          color: Colors.white,
          size: 16,
        ),
        const SizedBox(width: 5),
        Text(
          (type == 'Turbo'
              ? translate('widget.turbo_mode')
              : translate('widget.hadadi_mode')),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Rubik',
          ),
        ),
      ],
    ),
  );
}
