import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int filledIndex;
  final bool isHebrew;
  final bool displayIndex;

  const ProgressIndicatorWidget({
    required this.filledIndex,
    required this.isHebrew,
    required this.displayIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                isHebrew ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                child: IconButton(
                  icon: Icon(
                    isHebrew ? Icons.arrow_back : Icons.arrow_forward,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          if (displayIndex)
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    5,
                    (index) => Container(
                      height: 11,
                      width: 70,
                      decoration: BoxDecoration(
                        color: isHebrew
                            ? (index < filledIndex
                                ? const Color(0xFF4C52CC)
                                : const Color(0xFFC1C3EE))
                            : (index >= 5 - filledIndex
                                ? const Color(0xFF4C52CC)
                                : const Color(0xFFC1C3EE)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 5.5),
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
