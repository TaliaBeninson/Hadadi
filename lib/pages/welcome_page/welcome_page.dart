import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/authentication/signup_page/sinup_select.dart';
import 'package:hadadi/pages/base_layout/player/base_layout.dart';
import 'package:hadadi/utils/widgets/custom_button.dart';

import '../authentication/signup_page/widgets/divider_with_text.dart';
import 'widgets/language_switch.dart';
import 'widgets/login_prompt.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _selectedLanguage = 'he';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SafeArea(
              child: Image.asset(
                'assets/TopDesign.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SizedBox(height: screenWidth * 0.2),
            Image.asset(
              'assets/logo.png',
              width: screenWidth * 0.7,
              height: screenWidth * 0.2,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                text: translate('welcome.signup'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignUpSelectPage()),
                ),
                backgroundColor: const Color(0xff000089),
                textColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            LoginPrompt(
              haveAccountText: translate('welcome.haveAccount'),
              loginText: translate('welcome.login'),
            ),
            const SizedBox(height: 20),
            DividerWithText(text: translate('welcome.or')),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                text: translate('welcome.guest_login'),
                onPressed: () => _navigateToHomePage(true),
                backgroundColor: Colors.white,
                textColor: const Color(0xFF000089),
                outlined: true,
              ),
            ),
            SizedBox(height: screenWidth * 0.2),
            LanguageSwitch(
              onLanguageChange: _changeLanguage,
              selectedLanguage: _selectedLanguage,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _navigateToHomePage(bool isGuest) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BaseLayout(isGuest: true)),
    );
  }

  void _changeLanguage(String languageCode) async {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    await localizationDelegate.changeLocale(Locale(languageCode));
    setState(() {
      _selectedLanguage = languageCode;
    });
  }
}
