import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/services/DB/user_service.dart';
import 'package:hadadi/services/auth_service.dart';
import 'package:hadadi/utils/widgets/custom_button.dart';
import 'package:hadadi/utils/widgets/custom_text_field.dart';

import '../signup_page/widgets/progress_indicator_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  bool _isLoading = false;

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
                            controller: _emailController,
                            labelText: translate('login.email'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return translate('login.error.enter_email');
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 0),
                          child: CustomTextField(
                            controller: _passwordController,
                            labelText: translate('login.password'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return translate('login.error.enter_password');
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
                        ],
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CustomButton(
                            text: translate('login.login_button'),
                            onPressed: () async {
                              await _handleLogin();
                            },
                            backgroundColor: const Color(0xff000089),
                            textColor: Colors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (_emailController.text.isNotEmpty) {
                              await _authService
                                  .resetPassword(_emailController.text);
                              setState(() {
                                _errorMessage =
                                    translate('login.reset_link_sent');
                              });
                            } else {
                              setState(() {
                                _errorMessage =
                                    translate('login.error.enter_email');
                              });
                            }
                          },
                          child: Text(
                            translate('login.forgot_password'),
                            style: const TextStyle(color: Color(0xff000089)),
                          ),
                        ),
                      ],
                    ),
                  )),
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
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xff000089),
                strokeWidth: 5,
              ),
            ),
          ),
      ],
    );
  }

  Future _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        final bool isPendingApproval =
            await _userService.isUserPendingApproval(email);
        if (isPendingApproval) {
          setState(() {
            _errorMessage = translate('login.error.pending_approval');
            _isLoading = false;
          });
          return;
        }
        final user = await _authService.signIn(email, password);
        if (user != null) {
          final bool isPasswordTemporary =
              await _userService.isPasswordTemporary(user.uid);

          if (isPasswordTemporary) {
            Navigator.pushReplacementNamed(context, '/changePassword');
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      } catch (e) {
        setState(() {
          _errorMessage = translate('login.error.invalid_credentials');
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
