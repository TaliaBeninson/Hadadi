import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TopBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? profileImageUrl;
  final VoidCallback onProfileTap;
  final VoidCallback onSearchTap;

  const TopBarWidget({
    super.key,
    required this.profileImageUrl,
    required this.onProfileTap,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFF5A1F),
      elevation: 0,
      toolbarHeight: 82,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(38),
          bottomRight: Radius.circular(38),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white, size: 28),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: GestureDetector(
        onTap: onSearchTap,
        child: Container(
          height: 39,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(21),
          ),
          child: Center(
            child: Text(
              translate('base_layout.search_placeholder'),
              style: const TextStyle(
                color: Color(0xFF767676),
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: profileImageUrl != null
              ? CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(profileImageUrl!),
          )
              : const Icon(Icons.person, color: Colors.white),
          onPressed: onProfileTap,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(82);
}
