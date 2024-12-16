import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/authentication/signup_page/signup_page_player.dart';
import 'package:hadadi/pages/authentication/signup_page/signup_page_supplier.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/divider_with_text.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/progress_indicator_widget.dart';

class SignUpSelectPage extends StatelessWidget {
  const SignUpSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ProgressIndicatorWidget(
            filledIndex: 1,
            isHebrew: isHebrew,
            displayIndex: true,
          ),
          const SizedBox(height: 10),

          // Options
          Expanded(
            child: ListView(
              children: [
                buildOptionCard(
                  title: translate('signup_select.customer_registration.title'),
                  description: translate(
                      'signup_select.customer_registration.description'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupPage()),
                    );
                  },
                ),
                const SizedBox(height: 40),
                DividerWithText(text: translate('welcome.or')),
                const SizedBox(height: 40),
                buildOptionCard(
                  title: translate('signup_select.supplier_registration.title'),
                  description: translate(
                      'signup_select.supplier_registration.description'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupPageSupplier()),
                    );
                  },
                ),
                const SizedBox(height: 40),
                DividerWithText(text: translate('welcome.or')),
                const SizedBox(height: 40),
                buildOptionCard(
                  title: translate('signup_select.both_registration.title'),
                  description:
                      translate('signup_select.both_registration.description'),
                  onTap: () {},
                ),
                const SizedBox(height: 60),
                Image.asset(
                  'assets/TopDesign.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionCard({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  offset: const Offset(-8, -8),
                  blurRadius: 16,
                ),
                BoxShadow(
                  color: Colors.grey.shade400.withOpacity(0.8),
                  offset: const Offset(8, 8),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 28, bottom: 28, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000089),
                      fontFamily: 'Rubik',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF767676),
                      fontFamily: 'Rubik',
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDecorativeOval(Color color) {
    return Container(
      width: 40,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
