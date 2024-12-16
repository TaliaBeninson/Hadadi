import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/interests_modal.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/progress_indicator_widget.dart';
import 'package:hadadi/pages/welcome_page/welcome_page.dart';
import 'package:hadadi/utils/widgets/custom_button.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';
    TextDirection textDirection =
        isHebrew ? TextDirection.rtl : TextDirection.ltr;

    return Scaffold(
      body: Column(
        children: [
          ProgressIndicatorWidget(
            filledIndex: 2,
            isHebrew: isHebrew,
            displayIndex: true,
          ),
          const SizedBox(height: 70),
          Directionality(
            textDirection: textDirection,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate('signup.terms_conditions'),
                        style: const TextStyle(
                          color: Color(0xff000089),
                          fontFamily: 'Rubik',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        translate('signup.terms_conditions_text'),
                        style: const TextStyle(
                          color: Color(0xff000089),
                          fontFamily: 'Rubik',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        translate('signup.deposit_payment'),
                        style: const TextStyle(
                          color: Color(0xff000089),
                          fontFamily: 'Rubik',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        translate('signup.deposit_payment_text'),
                        style: const TextStyle(
                          color: Color(0xff000089),
                          fontFamily: 'Rubik',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Accept Button
                CustomButton(
                  text: translate('signup.accept_terms'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InterestSelectionPage()),
                    );
                  },
                  backgroundColor: const Color(0xff000089),
                  textColor: Colors.white,
                ),
                const SizedBox(height: 16),
                // Decline Text
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage(),
                      ),
                    );
                  },
                  child: Text(
                    translate('signup.decline_terms'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xff000089),
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
