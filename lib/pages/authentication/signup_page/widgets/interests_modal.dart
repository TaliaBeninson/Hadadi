import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/progress_indicator_widget.dart';
import 'package:hadadi/pages/authentication/signup_page/widgets/signup_form_widget.dart';
import 'package:hadadi/utils/widgets/custom_button.dart';

class InterestSelectionPage extends StatefulWidget {
  const InterestSelectionPage({super.key});

  @override
  _InterestSelectionPageState createState() => _InterestSelectionPageState();
}

class _InterestSelectionPageState extends State<InterestSelectionPage> {
  final List<String> _availableInterests = [
    translate('signup.categories.books'),
    translate('signup.categories.electronics'),
    translate('signup.categories.sports'),
    translate('signup.categories.art'),
    translate('signup.categories.toys'),
    translate('signup.categories.household'),
    translate('signup.categories.furniture'),
    translate('signup.categories.beauty'),
    translate('signup.categories.fashion'),
    translate('signup.categories.jewelry'),
    translate('signup.categories.appliances'),
    translate('signup.categories.computers'),
    translate('signup.categories.phones'),
    translate('signup.categories.photography'),
    translate('signup.categories.health'),
    translate('signup.categories.pets'),
    translate('signup.categories.video_games'),
    translate('signup.categories.events'),
    translate('signup.categories.courses'),
    translate('signup.categories.software'),
    translate('signup.categories.eco_friendly'),
    translate('signup.categories.gardening'),
    translate('signup.categories.baby_products'),
    translate('signup.categories.kitchen_products'),
    translate('signup.categories.water_sports'),
    translate('signup.categories.sound'),
    translate('signup.categories.musical_instruments'),
    translate('signup.categories.car_accessories'),
    translate('signup.categories.office_products'),
    translate('signup.categories.lighting'),
  ];

  final Set<String> _selectedInterests = {};

  Widget _buildCategoryChip(String categoryName, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedInterests.contains(categoryName)) {
            _selectedInterests.remove(categoryName);
          } else {
            _selectedInterests.add(categoryName);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff4C52CC) : Colors.transparent,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: const Color(0xff4C52CC), width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(Icons.check, size: 16, color: Colors.white),
            SizedBox(width: isSelected ? 6 : 0),
            Text(
              categoryName,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xff4C52CC),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
            filledIndex: 3,
            isHebrew: isHebrew,
            displayIndex: true,
          ),
          const SizedBox(height: 70),
          Directionality(
            textDirection: textDirection,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableInterests
                        .map((interest) => _buildCategoryChip(
                            interest, _selectedInterests.contains(interest)))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: translate('signup.next'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupForm(
                      selectedInterests: _selectedInterests.toList(),
                    ),
                  ),
                );
              },
              backgroundColor: const Color(0xff000089),
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
