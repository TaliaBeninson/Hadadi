import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/authentication/login_page/login_page.dart';

class LoginPrompt extends StatelessWidget {
  final String haveAccountText;
  final String loginText;

  const LoginPrompt({
    super.key,
    required this.haveAccountText,
    required this.loginText,
  });

  @override
  Widget build(BuildContext context) {
    bool isRtl =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Wrap(
        spacing: 5,
        alignment: WrapAlignment.center,
        children: [
          Text(
            haveAccountText,
            style: const TextStyle(
              fontSize: 14,
              decoration: TextDecoration.none,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: Text(
              loginText,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF000089),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF000089),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
