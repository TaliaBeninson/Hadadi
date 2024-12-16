import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart';

class PermissionService {
  // Method to open app settings
  Future<void> openAppSettings(BuildContext context) async {
    const String url = 'app-settings:';
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      print(translate('signup.permission_permanently_denied'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translate('signup.permission_permanently_denied')),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Method to show permission dialog
  Future<bool> showPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translate('signup.permission_required')),
          content: Text(translate('signup.permission_request_settings')),
          actions: <Widget>[
            TextButton(
              child: Text(translate('signup.open_settings')),
              onPressed: () {
                Navigator.of(context).pop(true); // User agrees
              },
            ),
            TextButton(
              child: Text(translate('signup.cancel')),
              onPressed: () {
                Navigator.of(context).pop(false); // User declines
              },
            ),
          ],
        );
      },
    ) ??
        false; // Return false if dismissed without selection
  }
}
