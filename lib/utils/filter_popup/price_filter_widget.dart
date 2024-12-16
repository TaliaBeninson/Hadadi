import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class PriceFilterWidget extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final Function(double, double) onPriceRangeChanged;

  const PriceFilterWidget({
    super.key,
    this.minPrice = 0,
    this.maxPrice = 5000,
    required this.onPriceRangeChanged,
  });

  @override
  _PriceFilterWidgetState createState() => _PriceFilterWidgetState();
}

class _PriceFilterWidgetState extends State<PriceFilterWidget> {
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    _minPriceController =
        TextEditingController(text: widget.minPrice.toInt().toString());
    _maxPriceController =
        TextEditingController(text: widget.maxPrice.toInt().toString());
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _onPriceChanged(String value) {
    final minPrice =
        double.tryParse(_minPriceController.text) ?? widget.minPrice;
    final maxPrice =
        double.tryParse(_maxPriceController.text) ?? widget.maxPrice;
    widget.onPriceRangeChanged(minPrice, maxPrice);
  }

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Min Price Column
            Column(
              children: [
                Text(
                  "${translate('filter.minimum')} ₪",
                  style: const TextStyle(
                    color: Color(0xFF767676),
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                _buildPriceInputBox(
                  controller: _minPriceController,
                  hintText: isHebrew ? 'מינימום' : 'Minimum',
                  onChanged: _onPriceChanged,
                ),
              ],
            ),
            const SizedBox(width: 16),
            const Text(
              '-',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                Text(
                  "${translate('filter.maximum')} ₪",
                  style: const TextStyle(
                    color: Color(0xFF767676),
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                _buildPriceInputBox(
                  controller: _maxPriceController,
                  hintText: isHebrew ? 'מקסימום' : 'Maximum',
                  onChanged: _onPriceChanged,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPriceInputBox({
    required TextEditingController controller,
    required String hintText,
    required Function(String) onChanged,
  }) {
    return Container(
      width: 120,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xff4C52CC),
              fontWeight: FontWeight.bold,
            ),
            contentPadding: EdgeInsets.zero,
          ),
          style: const TextStyle(
            color: Color(0xff4C52CC),
            fontWeight: FontWeight.bold,
          ),
          onChanged: (value) => onChanged(value),
        ),
      ),
    );
  }
}
