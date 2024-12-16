import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LanguageSwitch extends StatelessWidget {
  final Function(String) onLanguageChange;
  final String selectedLanguage;

  const LanguageSwitch({
    super.key,
    required this.onLanguageChange,
    required this.selectedLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: _buildLanguageButton('he', 'assets/flags/il_flag.png'),
          ),
          const SizedBox(height: 16), // Space between buttons
          SizedBox(
            width: double.infinity,
            child: _buildLanguageButton('en', 'assets/flags/us_flag.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String languageCode, String flagAsset) {
    bool isSelected = selectedLanguage == languageCode;

    return ElevatedButton.icon(
      onPressed: () => onLanguageChange(languageCode),
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected)
            const Icon(Icons.check, size: 18, color: Colors.white),
          if (isSelected) const SizedBox(width: 5),
          Text(
            translate('welcome.${languageCode == 'he' ? 'hebrew' : 'english'}'),
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 21,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(flagAsset),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      label: const Text(''),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        backgroundColor:
            isSelected ? const Color(0xff4C52CC) : const Color(0xffC1C3EE),
        foregroundColor: isSelected ? Colors.white : const Color(0xff4C52CC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(21),
        ),
      ),
    );
  }
}
