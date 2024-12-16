import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/utils/widgets/profile_image_section.dart';

class HeaderWidget extends StatelessWidget {
  final String? name;
  final String? email;
  final String? profileImageUrl;
  final VoidCallback onProfileTap;

  const HeaderWidget({
    super.key,
    this.name,
    this.email,
    this.profileImageUrl,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 20.0, left: 20.0, top: 35, bottom: 10),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFF5A1F),
              borderRadius: BorderRadius.circular(22.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFFFFF).withOpacity(0.8),
                  offset: const Offset(-8, -8),
                  blurRadius: 16,
                ),
                BoxShadow(
                  color: const Color(0xFFD1D1D1).withOpacity(0.8),
                  offset: const Offset(8, 8),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileImageSection(
                    profileImageUrl: profileImageUrl,
                    updateProfilePicture: onProfileTap,
                    isGuest: false,
                    size: 100,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            name ?? translate('base_layout.profile'),
                            style: const TextStyle(
                              color: Color(0xFFF2F2F2),
                              fontFamily: 'Rubik',
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            email ?? 'guest@example.com',
                            style: const TextStyle(
                              color: Color(0xFFF2F2F2),
                              fontFamily: 'Rubik',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 15,
            left: 15,
            child: InkWell(
              onTap: onProfileTap,
              child: Image.asset('assets/drawer/bell.png'),
            ),
          ),
        ],
      ),
    );
  }
}
