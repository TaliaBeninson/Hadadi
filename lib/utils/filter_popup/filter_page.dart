import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/utils/filter_popup/price_filter_widget.dart';

class FilterPage extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final Set<String> selectedCategories;
  final String selectedStatus;
  final Function(String, Set<String>, double, double) onApplyFilters;
  final bool isFromMyProductsPage;

  const FilterPage({
    super.key,
    required this.minPrice,
    required this.maxPrice,
    required this.selectedCategories,
    required this.selectedStatus,
    required this.onApplyFilters,
    required this.isFromMyProductsPage,
  });

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late double _minPrice;
  late double _maxPrice;
  late String _selectedStatus;
  late Set<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _minPrice = widget.minPrice;
    _maxPrice = widget.isFromMyProductsPage
        ? 50000
        : widget.maxPrice; // Conditionally set max price
    _selectedStatus = widget.selectedStatus;
    _selectedCategories = Set.from(widget.selectedCategories);
  }

  void _applyFilters() {
    widget.onApplyFilters(
        _selectedStatus, _selectedCategories, _minPrice, _maxPrice);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _selectedStatus = translate('filter.all_statuses');
      _selectedCategories = {translate('filter.all_categories')};
      _minPrice = 0;
      _maxPrice = 1000;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Directionality(
      textDirection: isHebrew ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF2F2F2),
            borderRadius: BorderRadius.vertical(top: Radius.circular(39)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(isHebrew),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStyledHeadline(translate('filter.sort_by_status')),
                      _buildStatusFilter(),
                      const Divider(
                        color: Color(0xffC1C3EE),
                        thickness: 1,
                        indent: 24,
                        endIndent: 24,
                      ),
                      _buildStyledHeadline(
                          translate('filter.sort_by_guarantee_price')),
                      _buildPriceFilter(),
                      const Divider(
                        color: Color(0xffC1C3EE),
                        thickness: 1,
                        indent: 24,
                        endIndent: 24,
                      ),
                      _buildStyledHeadline(
                          translate('filter.sort_by_category')),
                      _buildCategoryFilter(isHebrew),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: ElevatedButton(
                          onPressed: _applyFilters,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff000089),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                            elevation: 0,
                          ),
                          child: Center(
                            child: Text(
                              translate('filter.filter'),
                              style: const TextStyle(
                                color: Color(0xffF2F2F2),
                                fontFamily: 'Rubik',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isHebrew) {
    return Container(
      width: double.infinity,
      height: 68,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(39)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(227, 227, 227, 0.8),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: isHebrew ? 16.0 : 0.0,
              left: isHebrew ? 0.0 : 16.0,
            ),
            child: Text(
              translate('filter.filters'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000089),
                fontFamily: 'Rubik',
              ),
              textAlign: isHebrew ? TextAlign.right : TextAlign.left,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextButton(
              onPressed: _resetFilters,
              child: Text(
                translate('filter.reset'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000089),
                  decoration: TextDecoration.underline,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: [
              _buildStatusButton(translate('filter.all_statuses')),
              _buildStatusButton(translate('filter.basic_status')),
              _buildStatusButton(translate('filter.turbo_status')),
              if (widget.isFromMyProductsPage)
                _buildStatusButton(translate('filter.payment')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String label) {
    bool isSelected = _selectedStatus == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff4C52CC) : const Color(0xFFC1C3EE),
          borderRadius: BorderRadius.circular(21),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Allow Row to wrap its content
          children: [
            if (isSelected)
              const Icon(Icons.check, size: 15, color: Colors.white)
            else
              Icon(
                label == translate('filter.basic_status')
                    ? Icons.link
                    : label == translate('filter.turbo_status')
                        ? Icons.bolt
                        : label == translate('filter.payment')
                            ? Icons.credit_card
                            : Icons.help,
                size: 15,
              ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF0F0F14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceFilter() {
    return PriceFilterWidget(
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      onPriceRangeChanged: (double min, double max) {
        setState(() {
          _minPrice = min;
          _maxPrice = max;
        });
      },
    );
  }

  Widget _buildCategoryFilter(bool isHebrew) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Topics').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text('No categories available');
              }

              List<Widget> categoryChips = [];
              categoryChips.add(_buildCategoryChip(
                translate('filter.all_categories'),
                _selectedCategories
                    .contains(translate('filter.all_categories')),
              ));

              List<DocumentSnapshot> sortedDocs = snapshot.data!.docs;
              sortedDocs.sort((a, b) {
                String categoryA =
                    a['name'][isHebrew ? 'he' : 'en'] ?? 'Unknown';
                String categoryB =
                    b['name'][isHebrew ? 'he' : 'en'] ?? 'Unknown';
                return categoryA.compareTo(categoryB);
              });
              for (var doc in sortedDocs) {
                String category =
                    doc['name'][isHebrew ? 'he' : 'en'] ?? 'Unknown';
                categoryChips.add(
                  _buildCategoryChip(
                    category,
                    _selectedCategories.contains(category),
                  ),
                );
              }
              return Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: categoryChips,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStyledHeadline(String title) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Padding(
      padding: EdgeInsets.only(
        bottom: 24,
        top: 20,
        right: isHebrew ? 26 : 0,
        left: isHebrew ? 0 : 26,
      ),
      child: Text(
        title,
        textAlign: isHebrew ? TextAlign.right : TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xff4C52CC),
          fontFamily: 'Rubik',
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String categoryName, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (categoryName == translate('filter.all_categories')) {
            _selectedCategories = {translate('filter.all_categories')};
          } else {
            _selectedCategories.remove(translate('filter.all_categories'));
            if (_selectedCategories.contains(categoryName)) {
              _selectedCategories.remove(categoryName);
            } else {
              _selectedCategories.add(categoryName);
            }
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff4C52CC) : Colors.transparent,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(color: const Color(0xff4C52CC)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(Icons.check, size: 16, color: Colors.white),
            Text(
              categoryName,
              style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xff4C52CC),
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
