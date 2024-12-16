import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/authentication/login_page/login_page.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/city_street_dropdown_widget.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/profile_picture_widget.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/progress_indicator_widget.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/verify_email_and_submit.dart';
import 'package:hadadi/services/auth_service.dart';
import 'package:hadadi/utils/widgets/custom_button.dart';
import 'package:hadadi/utils/widgets/custom_text_field.dart';

class SignupForm extends StatefulWidget {
  final List<String> selectedInterests;

  const SignupForm({super.key, required this.selectedInterests});

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _socialMediaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedCity;
  String? _selectedStreet;
  File? _profileImage;
  String? _profileImageError;
  String? _firebaseVerificationError;
  Set<String> _selectedInterests = {};

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _selectedInterests = widget.selectedInterests.toSet();
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
            filledIndex: 4,
            isHebrew: isHebrew,
            displayIndex: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Directionality(
                textDirection: textDirection,
                child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(height: 16),
                          ProfilePictureWidget(
                              selectedImage: _profileImage,
                              onImageSelected: (image) {
                                setState(() {
                                  _profileImage = image;
                                });
                              },
                              isLogo: false),
                          if (_profileImageError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Center(
                                child: Text(
                                  _profileImageError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 40),
                          CustomTextField(
                            controller: _emailController,
                            labelText: translate('signup.email'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return translate('signup.required');
                              }
                              if (!_isValidEmail(value)) {
                                return translate('signup.invalid_email');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _fullNameController,
                            labelText: translate('signup.full_name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return translate('signup.required');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _phoneController,
                            labelText: translate('signup.phone_number'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return translate('signup.required');
                              }
                              if (!_isValidPhoneNumber(value)) {
                                return translate('signup.invalid_phone');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CityStreetDropdown(
                              onSelectionChanged: (city, street) {
                                setState(() {
                                  _selectedCity = city;
                                  _selectedStreet = street;
                                });
                              },
                              isHebrew: isHebrew),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _idController,
                            labelText: translate('signup.id_number'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return translate('signup.required');
                              }
                              if (!_isValidIsraeliId(value)) {
                                return translate('signup.invalid_id');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _socialMediaController,
                            labelText: translate('signup.social_media_link'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return translate('signup.required');
                              }
                              if (!_isValidUrl(value)) {
                                return translate('signup.invalid_url');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: translate('signup.submit'),
                            onPressed: () async {
                              await _handleSignup();
                            },
                            backgroundColor: const Color(0xff000089),
                            textColor: Colors.white,
                          ),
                          if (_firebaseVerificationError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Center(
                                child: Text(
                                  _firebaseVerificationError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            },
                            child: Text(
                              translate('signup.already_have_account'),
                              style: const TextStyle(color: Color(0xff000089)),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidPhoneNumber(String phone) {
    final RegExp phoneRegExp = RegExp(r'^05\d{8}$');
    return phoneRegExp.hasMatch(phone);
  }

  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && uri.hasAbsolutePath;
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  bool _isValidIsraeliId(String id) {
    if (id.length != 9 || !RegExp(r'^\d+$').hasMatch(id)) {
      return false;
    }
    List<int> idDigits = id.split('').map((d) => int.parse(d)).toList();
    int sum = 0;
    for (int i = 0; i < idDigits.length; i++) {
      int digit = idDigits[i];
      if (i % 2 == 1) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      sum += digit;
    }
    return sum % 10 == 0;
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        String? userId = await _authService.signUp(
          _emailController.text,
          "temporaryPassword",
        );
        if (userId == null) {
          throw Exception("Failed to create a new user.");
        }

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyEmailAndSubmit(
              userId: userId,
              fullName: _fullNameController.text,
              phone: _phoneController.text,
              id: _idController.text,
              socialMediaLink: _socialMediaController.text,
              profileImage: _profileImage,
              interests: _selectedInterests.toList(),
              city: _selectedCity!,
              street: _selectedStreet!,
            ),
          ),
        );
      } catch (e) {
        Navigator.pop(context);
        setState(() {
          _firebaseVerificationError = e.toString();
        });
      }
    }
  }
}
