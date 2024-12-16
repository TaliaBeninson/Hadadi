import 'package:flutter/material.dart';

class StatusOptionTile extends StatelessWidget {
  final String statusKey;
  final String translatedStatus;
  final bool isSelected;
  final Function(String) toggleStatus;

  const StatusOptionTile({
    super.key,
    required this.statusKey,
    required this.translatedStatus,
    required this.isSelected,
    required this.toggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => toggleStatus(statusKey),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2 - 24,
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4C52CC)
                    : const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color.fromRGBO(118, 118, 118, 0.09)),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromRGBO(255, 255, 255, 0.3),
                      offset: Offset(1, 1),
                      blurRadius: 2),
                  BoxShadow(
                      color: Color.fromRGBO(209, 209, 209, 0.5),
                      offset: Offset(-1, -1),
                      blurRadius: 2),
                ],
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                translatedStatus,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.visible,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
