import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class RTLSConfirmationSlider extends StatefulWidget {
  final VoidCallback onConfirmation;

  const RTLSConfirmationSlider({
    super.key,
    required this.onConfirmation,
  });

  @override
  _RTLSConfirmationSliderState createState() => _RTLSConfirmationSliderState();
}

class _RTLSConfirmationSliderState extends State<RTLSConfirmationSlider> {
  double _dragPosition = 0.0;
  bool _isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    bool isRTL =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';
    double sliderWidth = MediaQuery.of(context).size.width - 49 - 52;
    double buttonSizeWidth = 47;
    double sliderHeight = 50;
    double endBuffer = 10.0;

    double maxDragPosition = sliderWidth - buttonSizeWidth - endBuffer;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (_isConfirmed) return;

        setState(() {
          if (isRTL) {
            _dragPosition -= details.delta.dx;
          } else {
            _dragPosition += details.delta.dx;
          }
          _dragPosition = _dragPosition.clamp(0.0, maxDragPosition);
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragPosition >= maxDragPosition) {
          setState(() {
            _isConfirmed = true;
            _dragPosition = maxDragPosition;
          });
          widget.onConfirmation();
        } else {
          setState(() {
            _dragPosition = 0.0;
            _isConfirmed = false;
          });
        }
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Container(
              width: sliderWidth,
              height: sliderHeight,
              decoration: BoxDecoration(
                color: _isConfirmed
                    ? const Color(0xFF39A844)
                    : const Color(0xFF000089),
                borderRadius: BorderRadius.circular(21),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: const Offset(-8, -8),
                    blurRadius: 16,
                  ),
                  BoxShadow(
                    color: const Color(0xFFD7D7D7).withOpacity(0.8),
                    offset: const Offset(8, 8),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _isConfirmed
                      ? translate('widget.approve_success')
                      : translate('widget.approve_guarantee'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            left: isRTL ? null : _dragPosition,
            right: isRTL ? _dragPosition : null,
            top: (sliderHeight - buttonSizeWidth) / 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: buttonSizeWidth,
                height: 41,
                decoration: BoxDecoration(
                  color: _isConfirmed
                      ? const Color(0xFF41C34E)
                      : const Color(0xFF4C52CC),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _isConfirmed ? Icons.check : Icons.arrow_forward,
                    color: const Color(0xFFF2F2F2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
