import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/utils/widgets/custom_button.dart';
import 'package:hadadi/utils/widgets/custom_text_field.dart';

class ReasonBottomBar extends StatefulWidget {
  final VoidCallback onCancel;
  final Future<void> Function(String reasonHeadline, String reasonInfo)
      onConfirm;

  const ReasonBottomBar({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  _ReasonBottomBarState createState() => _ReasonBottomBarState();
}

class _ReasonBottomBarState extends State<ReasonBottomBar> {
  late TextEditingController reasonController;
  late TextEditingController optionalInfoController;

  @override
  void initState() {
    super.initState();
    reasonController = TextEditingController();
    optionalInfoController = TextEditingController();
  }

  @override
  void dispose() {
    reasonController.dispose();
    optionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(39),
          topRight: Radius.circular(39),
        ),
        color: const Color(0xFFF2F2F2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB6B6B6).withOpacity(0.7),
            offset: const Offset(-3, -3),
            blurRadius: 16,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(39),
                  topRight: Radius.circular(39),
                ),
                color: const Color(0xFFF8F8F8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE3E3E3).withOpacity(0.8),
                    offset: const Offset(8, 8),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Text(
                translate('search_product.reason.title'),
                style: const TextStyle(
                  color: Color(0xFF000089),
                  fontFamily: 'Rubik',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: reasonController,
                    labelText: translate('search_product.reason.headline'),
                    onChanged: (value) {
                      if (value.length > 45) {
                        reasonController.text = value.substring(0, 45);
                        reasonController.selection = TextSelection.fromPosition(
                          const TextPosition(offset: 45),
                        );
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: reasonController,
                      builder: (context, value, child) {
                        final currentLength = value.text.length;
                        final isMaxReached = currentLength == 45;

                        return Text(
                          '$currentLength/45',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isMaxReached
                                ? Colors.red
                                : const Color(0xFF999999),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: optionalInfoController,
                    labelText: translate('search_product.reason.hint'),
                    onChanged: (value) {},
                    maxLines: 7,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    translate('search_product.reason.optional_info'),
                    style: const TextStyle(
                      color: Color(0xFF767676),
                      fontFamily: 'Rubik',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      CustomButton(
                        text: translate('search_product.reason.confirm'),
                        onPressed: () async {
                          final reasonHeadline = reasonController.text.trim();
                          final reasonInfo = optionalInfoController.text.trim();
                          try {
                            await widget.onConfirm(reasonHeadline, reasonInfo);
                            Navigator.of(context).pop();
                          } catch (e) {
                            throw ('Error: $e');
                          }
                        },
                        backgroundColor: const Color(0xFF000089),
                        textColor: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: translate('search_product.reason.cancel'),
                        onPressed: widget.onCancel,
                        backgroundColor: Colors.white,
                        textColor: const Color(0xFF000089),
                        outlined: true,
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
