import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TopBarWidget extends StatelessWidget {
  final String titleText;
  final VoidCallback onBackPress;

  const TopBarWidget({
    super.key,
    required this.titleText,
    required this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    bool isRtl =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFF5A1F),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(38),
          bottomRight: Radius.circular(38),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(255, 203, 187, 0.4),
            offset: Offset(0, 10),
            blurRadius: 20,
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        statusBarHeight + 5,
        20,
        25,
      ),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          GestureDetector(
            onTap: onBackPress,
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              titleText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Rubik',
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
