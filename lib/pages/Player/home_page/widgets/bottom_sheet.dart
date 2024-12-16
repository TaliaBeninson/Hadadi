import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AnimatedBottomSheet extends StatefulWidget {
  final Function(String?) onSymbolSelected;

  const AnimatedBottomSheet({super.key, required this.onSymbolSelected});

  @override
  _AnimatedBottomSheetState createState() => _AnimatedBottomSheetState();
}

class _AnimatedBottomSheetState extends State<AnimatedBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  String? selectedSymbol;
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
    _autoCloseTimer = Timer(const Duration(seconds: 3), () {
      _controller.reverse();
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color(0xFFC1C3EE),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(182, 182, 182, 0.7),
              offset: Offset(-3, -3),
              blurRadius: 16,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                translate('support_request.title'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Rubik',
                  color: Color(0xFF000089),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildEmojiIcon(
                    Icons.favorite, const Color(0xFFFF5A1F), 'heart', context),
                const SizedBox(width: 20),
                _buildEmojiIcon(Icons.emoji_emotions, const Color(0xFF4C52CC),
                    'smile', context),
                const SizedBox(width: 20),
                _buildEmojiIcon(Icons.emoji_events, const Color(0xFFF7B500),
                    'victory', context),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                _cancelAutoClose();
                _closeBottomSheet();
              },
              child: Text(
                translate('support_request.skip'),
                style: const TextStyle(
                  color: Color(0xFF000089),
                  fontFamily: 'Rubik',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiIcon(
      IconData icon, Color color, String symbol, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _cancelAutoClose();
        setState(() {
          selectedSymbol = symbol;
        });
        _closeBottomSheet();
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFCDCEEE),
              offset: Offset(-8, -8),
              blurRadius: 16,
            ),
            BoxShadow(
              color: Color(0xFFA7AAEE),
              offset: Offset(8, 8),
              blurRadius: 16,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }

  void _cancelAutoClose() {
    _autoCloseTimer?.cancel();
    _autoCloseTimer = null;
  }

  void _closeBottomSheet() {
    _controller.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }
}
