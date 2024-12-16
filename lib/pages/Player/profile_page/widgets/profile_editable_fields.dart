import 'package:flutter/material.dart';

class EditableField extends StatelessWidget {
  final String label;
  final String content;
  final TextEditingController controller;
  final bool isEditing;
  final VoidCallback onEdit;
  final VoidCallback onSave;

  const EditableField({
    super.key,
    required this.label,
    required this.content,
    required this.controller,
    required this.isEditing,
    required this.onEdit,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF767676),
            fontFamily: 'Rubik',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (isEditing)
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onSubmitted: (_) => onSave(),
                ),
              )
            else
              Expanded(
                child: Text(
                  content,
                  style: const TextStyle(
                    color: Color(0xFF0F0F14),
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            GestureDetector(
              onTap: isEditing ? onSave : onEdit,
              child: Icon(
                isEditing ? Icons.check_circle_outline : Icons.edit_outlined,
                size: 20,
                color: const Color(0xFF4C52CC),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 1,
          decoration: BoxDecoration(
            color: const Color(0xFFC1C3EE),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
