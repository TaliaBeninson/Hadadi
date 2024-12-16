import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/progress_indicator_widget.dart';
import 'package:hadadi/utils/widgets/custom_button.dart';
import 'package:hadadi/utils/widgets/custom_text_field.dart';

class BankInfoWidget extends StatefulWidget {
  final bool isHebrew;
  const BankInfoWidget({required this.isHebrew, Key? key}) : super(key: key);

  @override
  State<BankInfoWidget> createState() => _BankInfoWidgetState();
}

class _BankInfoWidgetState extends State<BankInfoWidget> {
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchNumberController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _firebaseVerificationError;

  @override
  void dispose() {
    _bankNameController.dispose();
    _branchNumberController.dispose();
    _accountNumberController.dispose();
    super.dispose();
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
            filledIndex: 3,
            isHebrew: isHebrew,
            displayIndex: true,
          ),
          const SizedBox(height: 70),
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
                          Text(
                            translate('store_details_signup.bank_details'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF000089),
                              fontFamily: 'Rubik',
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _bankNameController,
                            labelText:
                                translate('store_details_signup.bank_name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return translate('signup.required');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _branchNumberController,
                            labelText:
                                translate('store_details_signup.branch_number'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return translate('signup.required');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _accountNumberController,
                            labelText: translate(
                                'store_details_signup.account_number'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return translate('signup.required');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            text:
                                translate('store_details_signup.save_details'),
                            onPressed: () {},
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
}
