import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureWidget extends StatelessWidget {
  final File? selectedImage;
  final Function(File?) onImageSelected;
  final bool isLogo;

  const ProfilePictureWidget({
    super.key,
    required this.selectedImage,
    required this.onImageSelected,
    required this.isLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => _pickImage(context),
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey.shade200,
              backgroundImage:
                  selectedImage != null ? FileImage(selectedImage!) : null,
              child: selectedImage == null
                  ? Icon(Icons.person, size: 80, color: Colors.grey.shade400)
                  : null,
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => _pickImage(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(
                    Icons.edit,
                    color: Color(0xff4C52CC),
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      onImageSelected(File(pickedFile.path));
    }
  }
}
