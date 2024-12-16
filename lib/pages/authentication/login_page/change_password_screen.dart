import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/progress_indicator_widget.dart';
import 'package:hadadi/services/DB/user_service.dart';
import 'package:hadadi/services/auth_service.dart';
import 'package:hadadi/utils/widgets/custom_button.dart';
import 'package:hadadi/utils/widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';
    TextDirection textDirection =
        isHebrew ? TextDirection.rtl : TextDirection.ltr;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              ProgressIndicatorWidget(
                filledIndex: 4,
                isHebrew: isHebrew,
                displayIndex: false,
              ),
              Directionality(
                textDirection: textDirection,
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Image.asset(
                            'assets/TopDesign.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          const SizedBox(height: 100),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CustomTextField(
                              controller: _passwordController,
                              labelText:
                                  translate('change_password.new_password'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return translate(
                                      'change_password.error.enter_new_password');
                                } else if (value.length < 6) {
                                  return translate(
                                      'change_password.error.password_too_short');
                                }
                                return null;
                              },
                              obscureText: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 0),
                            child: CustomTextField(
                              controller: _confirmPasswordController,
                              labelText:
                                  translate('change_password.confirm_password'),
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return translate(
                                      'change_password.error.password_mismatch');
                                }
                                return null;
                              },
                              obscureText: true,
                            ),
                          ),
                          if (_errorMessage != null) ...[
                            Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                          ],
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CustomButton(
                              text: translate('change_password.submit'),
                              onPressed: () async {
                                await _handleChangePassword();
                              },
                              backgroundColor: const Color(0xff000089),
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Image.asset(
                  'assets/logo.png',
                  height: 60,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = null;
      });

      final newPassword = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      if (newPassword == confirmPassword) {
        try {
          await _authService.updatePassword(newPassword);
          final userId = await _userService.getCurrentUserId();
          if (userId != null) {
            await _userService.updateUserData({'isPasswordTemporary': false});
          }

          Navigator.pushReplacementNamed(context, '/home');
        } catch (e) {
          setState(() {
            _errorMessage = translate('change_password.error.update_failed');
          });
        }
      }
    }
  }
}
