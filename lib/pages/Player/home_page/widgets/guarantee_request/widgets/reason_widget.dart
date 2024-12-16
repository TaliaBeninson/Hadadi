import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/utils/widgets/custom_button.dart';

class ReasonWidget extends StatelessWidget {
  final String reasonHeadline;
  final String reasonInfo;
  final bool isHebrew;

  const ReasonWidget({
    Key? key,
    required this.reasonHeadline,
    required this.reasonInfo,
    required this.isHebrew,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (reasonInfo.isNotEmpty) {
          _showPopup(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFF2F2F2),
                offset: Offset(-8, -8),
                blurRadius: 16,
              ),
              BoxShadow(
                color: Color(0x80D7D7D7),
                offset: Offset(8, 8),
                blurRadius: 16,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                isHebrew ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                '"$reasonHeadline"',
                style: const TextStyle(
                  color: Color(0xFF0F0F14),
                  fontFamily: 'Rubik',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              if (reasonInfo.isNotEmpty)
                Center(
                  child: GestureDetector(
                    onTap: () => _showPopup(context),
                    child: Text(
                      translate('guarantee_requests.read_more'),
                      style: const TextStyle(
                        color: Color(0xFF000089),
                        fontFamily: 'Rubik',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x80E3E3E3),
                  offset: Offset(8, 8),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Section
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                  ),
                  padding: const EdgeInsets.all(12), // Reduced padding
                  child: Column(
                    crossAxisAlignment: isHebrew
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!isHebrew)
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.close,
                                color: Color(0xFF767676),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              translate('guarantee_requests.reason'),
                              style: const TextStyle(
                                color: Color(0xFF000089),
                                fontFamily: 'Rubik',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign:
                                  isHebrew ? TextAlign.start : TextAlign.end,
                            ),
                          ),
                          if (isHebrew)
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.close,
                                color: Color(0xFF767676),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        '"$reasonHeadline"',
                        style: const TextStyle(
                          color: Color(0xFF0F0F14),
                          fontFamily: 'Rubik',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textDirection:
                            isHebrew ? TextDirection.rtl : TextDirection.ltr,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                // Scrollable Content Section
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x80FFFFFF),
                              offset: Offset(-8, -8),
                              blurRadius: 16,
                            ),
                            BoxShadow(
                              color: Color(0x80D7D7D7),
                              offset: Offset(8, 8),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '"$reasonInfo"',
                          style: const TextStyle(
                            color: Color(0xFF0F0F14),
                            fontFamily: 'Rubik',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textDirection:
                              isHebrew ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ),
                    ),
                  ),
                ),
                // Always Visible Close Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: CustomButton(
                    text: translate('guarantee_requests.close'),
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Colors.white,
                    textColor: const Color(0xFF000089),
                    outlined: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
