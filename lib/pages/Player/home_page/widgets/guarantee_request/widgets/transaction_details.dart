import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TransactionDetails extends StatelessWidget {
  final int guarantees;
  final int guaranteesAmount;
  final String type;
  final bool isHebrew;

  const TransactionDetails({
    super.key,
    required this.guarantees,
    required this.guaranteesAmount,
    required this.type,
    required this.isHebrew,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isHebrew ? Alignment.centerLeft : Alignment.centerRight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: type == 'basic'
                    ? const Color(0xFFF7B500)
                    : const Color(0xFFFF5A1F),
                borderRadius: BorderRadius.only(
                  bottomRight:
                      isHebrew ? const Radius.circular(22) : Radius.zero,
                  bottomLeft:
                      isHebrew ? Radius.zero : const Radius.circular(22),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: isHebrew ? 11 : 0,
                      left: isHebrew ? 0 : 11,
                    ),
                    child: type == 'basic'
                        ? const Icon(
                            Icons.link,
                            size: 16,
                            color: Color(0xFFF2F2F2),
                          )
                        : const Icon(
                            Icons.bolt,
                            size: 16,
                            color: Color(0xFFF2F2F2),
                          ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    type == 'basic'
                        ? translate('widget.hadadi_mode')
                        : translate('widget.turbo_mode'),
                    style: const TextStyle(
                      color: Color(0xFFF2F2F2),
                      fontFamily: 'Rubik',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            // Purple Container
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 21,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF4C52CC),
                borderRadius: BorderRadius.only(
                  topLeft: isHebrew ? const Radius.circular(22) : Radius.zero,
                  topRight: isHebrew ? Radius.zero : const Radius.circular(22),
                ),
              ),
              child: Center(
                child: Text(
                  '$guarantees/$guaranteesAmount ${translate('widget.guarantees_text')}',
                  style: const TextStyle(
                    color: Color(0xFFF2F2F2),
                    fontFamily: 'Rubik',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
