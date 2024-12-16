import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class StatusSection extends StatelessWidget {
  final List<String> selectedStatuses;
  final VoidCallback selectStatus;

  const StatusSection({
    super.key,
    required this.selectedStatuses,
    required this.selectStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              translate('profile.personal_status'),
              style: const TextStyle(
                color: Color(0xFF767676),
                fontFamily: 'Rubik',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            if (selectedStatuses.isEmpty)
              GestureDetector(
                onTap: selectStatus,
                child: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Color(0xFF4C52CC),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (selectedStatuses.isNotEmpty)
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: selectedStatuses.map((status) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: const Color(0xFF4C52CC), width: 1.5),
                      ),
                      child: Text(
                        translate('profile.status_options.$status'),
                        style: const TextStyle(
                          color: Color(0xFF4C52CC),
                          fontFamily: 'Rubik',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: selectStatus,
                child: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Color(0xFF4C52CC),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
