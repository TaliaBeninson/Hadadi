import 'package:flutter/material.dart';

class ProfileImageSection extends StatelessWidget {
  final String? profileImageUrl;
  final VoidCallback updateProfilePicture;
  final bool isGuest;
  final double size;

  const ProfileImageSection({
    super.key,
    required this.profileImageUrl,
    required this.updateProfilePicture,
    required this.isGuest,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(2, 2),
                ),
              ],
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: CircleAvatar(
              radius: size / 2,
              backgroundColor: Colors.grey[300],
              child: ClipOval(
                child: profileImageUrl != null && profileImageUrl!.isNotEmpty
                    ? Image.network(
                        profileImageUrl!,
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/robot0.png',
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          if (!isGuest)
            Positioned(
              top: 0,
              left: 0,
              child: GestureDetector(
                onTap: updateProfilePicture,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: size * 0.15,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.edit,
                      size: size * 0.18,
                      color: const Color(0xFF4C52CC),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
