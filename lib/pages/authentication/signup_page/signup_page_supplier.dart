import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/authentication/login_page/login_page.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/bank_info_widget.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/city_street_dropdown_widget.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/profile_picture_widget.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/progress_indicator_widget.dart';
import 'package:hadadi/utils/widgets/custom_button.dart';
import 'package:hadadi/utils/widgets/custom_text_field.dart';

class SignupPageSupplier extends StatefulWidget {
  const SignupPageSupplier({super.key});

  @override
  SignupPageSupplierState createState() => SignupPageSupplierState();
}

class SignupPageSupplierState extends State<SignupPageSupplier> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _businessNumberController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _logoImage;
  String? _logoImageError;
  String? _firebaseVerificationError;

  String? _selectedCity;
  String? _selectedStreet;

  @override
  void initState() {
    super.initState();
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
            filledIndex: 2,
            isHebrew: isHebrew,
            displayIndex: true,
          ),
          Directionality(
            textDirection: textDirection,
            child: Expanded(
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(height: 16),
                          ProfilePictureWidget(
                            selectedImage: _logoImage,
                            onImageSelected: (image) {
                              setState(() {
                                _logoImage = image;
                              });
                            },
                            isLogo: true,
                          ),
                          if (_logoImageError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Center(
                                child: Text(
                                  _logoImageError!,
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
                            labelText: translate('store_details_signup.email'),
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
                            controller: _storeNameController,
                            labelText:
                                translate('store_details_signup.store_name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return translate('signup.required');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _businessNumberController,
                            labelText: translate(
                                'store_details_signup.business_number'),
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
                            labelText: translate(
                                'store_details_signup.business_number'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return translate('signup.required');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _whatsappController,
                            labelText:
                                translate('store_details_signup.whatsapp'),
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
                          CustomButton(
                            text: translate('settings.save_changes'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BankInfoWidget(
                                          isHebrew: isHebrew,
                                        )),
                              );
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

  bool _isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }
}
