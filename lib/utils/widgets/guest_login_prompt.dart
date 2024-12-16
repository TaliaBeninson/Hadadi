import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class GuestLoginPrompt extends StatelessWidget {
  final VoidCallback onSignup;
  final VoidCallback onLogin;

  const GuestLoginPrompt({
    super.key,
    required this.onSignup,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      title: Text(
        translate('login_prompt.title'),
        textAlign: TextAlign.center,
        style:
            const TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        Column(
          children: [
            ElevatedButton(
              onPressed: onSignup,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xff355c93),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(translate('login_prompt.signup')),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: onLogin,
              child: Text(
                translate('login_prompt.login_existing'),
                style: const TextStyle(color: Color(0xff355c93)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
