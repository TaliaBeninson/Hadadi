import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/progress_indicator_widget.dart';
import 'package:hadadi/services/DB/image_upload_service.dart';
import 'package:hadadi/services/DB/user_service.dart';
import 'package:hadadi/services/auth_service.dart';
import 'package:hadadi/utils/widgets/custom_button.dart';
import 'package:hadadi/utils/widgets/custom_text_field.dart';

class VerifyEmailAndSubmit extends StatefulWidget {
  final String userId;
  final String fullName;
  final String phone;
  final String id;
  final String socialMediaLink;
  final File? profileImage;
  final List<String> interests;
  final String city;
  final String street;

  const VerifyEmailAndSubmit({
    super.key,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.id,
    required this.socialMediaLink,
    required this.profileImage,
    required this.interests,
    required this.city,
    required this.street,
  });

  @override
  _VerifyEmailAndSubmitState createState() => _VerifyEmailAndSubmitState();
}

class _VerifyEmailAndSubmitState extends State<VerifyEmailAndSubmit> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final ImageUploadService _imageUploadService = ImageUploadService();

  String? _verificationMessage;
  bool _isUpdatingEmail = false;
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = _authService.currentUser?.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';
    TextDirection textDirection =
        isHebrew ? TextDirection.rtl : TextDirection.ltr;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ProgressIndicatorWidget(
            filledIndex: 5,
            isHebrew: isHebrew,
            displayIndex: true,
          ),
          const SizedBox(height: 70),
          Directionality(
            textDirection: textDirection,
            child: Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      if (_isEmailVerified) ...[
                        Text(
                          translate('signup.success_signup_title'),
                          style: const TextStyle(
                            color: Color(0xff000089),
                            fontFamily: 'Rubik',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          translate('signup.success_signup_message'),
                          style: const TextStyle(
                            color: Color(0xff000089),
                            fontFamily: 'Rubik',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: translate('signup.return_to_home'),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/welcome');
                          },
                          backgroundColor: const Color(0xff000089),
                          textColor: Colors.white,
                        ),
                      ] else ...[
                        Text(
                          '${translate('signup.email_sent_to')} ${_emailController.text}',
                          style: const TextStyle(
                            color: Color(0xff000089),
                            fontFamily: 'Rubik',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          translate('signup.check_email'),
                          style: const TextStyle(
                            color: Color(0xff000089),
                            fontFamily: 'Rubik',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        if (_isUpdatingEmail) ...[
                          CustomTextField(
                            controller: _emailController,
                            labelText: translate('signup.email'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return translate('signup.required');
                              }
                              if (!isValidEmail(value)) {
                                return translate('signup.invalid_email');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: translate('signup.update_email'),
                            onPressed: _updateEmailAndResendVerification,
                            backgroundColor: const Color(0xff000089),
                            textColor: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: translate('signup.cancel'),
                            onPressed: () {
                              setState(() {
                                _isUpdatingEmail = false;
                                _emailController.text = _emailController.text;
                              });
                            },
                            backgroundColor: Colors.white,
                            textColor: const Color(0xFF000089),
                            outlined: true,
                          ),
                        ] else ...[
                          CustomButton(
                            text: translate('signup.check_verification'),
                            onPressed: _checkVerification,
                            backgroundColor: const Color(0xff000089),
                            textColor: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isUpdatingEmail = true;
                              });
                            },
                            child: Text(
                              translate('signup.wrong_email'),
                              style: const TextStyle(color: Color(0xff000089)),
                            ),
                          ),
                        ],
                        if (_verificationMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              _verificationMessage!,
                              style: TextStyle(
                                color: _verificationMessage ==
                                        translate('signup.email_verified')
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
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
    );
  }

  Future<void> _checkVerification() async {
    try {
      final isVerified = await _authService.checkEmailVerification();
      if (isVerified) {
        setState(() {
          _isEmailVerified = true;
          _verificationMessage = translate('signup.email_verified');
        });

        await _storeUserData();
      } else {
        setState(() {
          _verificationMessage = translate('signup.email_not_verified');
        });
      }
    } catch (e) {
      setState(() {
        _verificationMessage = translate('signup.error_checking_verification');
      });
    }
  }

  Future<void> _updateEmailAndResendVerification() async {
    if (_emailController.text.isEmpty || !isValidEmail(_emailController.text)) {
      setState(() {
        _verificationMessage = translate('signup.invalid_email');
      });
      return;
    }

    if (_emailController.text != _authService.currentUser?.email) {
      setState(() {
        _isUpdatingEmail = true;
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        final oldEmail = _authService.currentUser?.email;
        if (oldEmail != null) {
          await _authService.deleteOldUserAndCreateNewUser(
            oldEmail: oldEmail,
            newEmail: _emailController.text,
            tempPassword: "temporaryPassword",
          );

          setState(() {
            _verificationMessage = translate('signup.verification_email_sent');
          });
        } else {
          setState(() {
            _verificationMessage =
                translate('signup.error_no_authenticated_user');
          });
        }
      } catch (e) {
        setState(() {
          _verificationMessage = translate('signup.error_updating_email');
        });
      } finally {
        Navigator.pop(context);
        setState(() {
          _isUpdatingEmail = false;
        });
      }
    } else {
      setState(() {
        _verificationMessage = translate('signup.same_email');
      });
    }
  }

  Future<void> _storeUserData() async {
    String? profileImageUrl;
    if (widget.profileImage != null) {
      profileImageUrl =
          await _imageUploadService.uploadProfileImage(widget.profileImage!);
      if (profileImageUrl == null) {
        throw Exception("Image upload failed.");
      }
    }

    try {
      await _userService.addToPendingUsers(
        userId: widget.userId,
        email: _emailController.text,
        fullName: widget.fullName,
        phone: widget.phone,
        id: widget.id,
        socialMediaLink: widget.socialMediaLink,
        profileImageUrl: profileImageUrl ?? '',
        interests: widget.interests,
        city: widget.city,
        street: widget.street,
      );
    } catch (e) {
      setState(() {
        _verificationMessage = translate('signup.data_save_error');
      });
    }
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }
}
