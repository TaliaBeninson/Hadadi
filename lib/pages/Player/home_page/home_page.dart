import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/Player/home_page/widgets/guarantee_request/guarantee_request.dart';
import 'package:hadadi/services/DB/transaction_service.dart';
import 'package:hadadi/utils/filter_popup/filter_page.dart';

class HomePage extends StatefulWidget {
  final bool isGuest;

  const HomePage({super.key, required this.isGuest});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TransactionService _transactionService = TransactionService();

  List<Map<String, dynamic>> _allTransactions = [];
  List<Map<String, dynamic>> _filteredTransactions = [];
  String _selectedStatus = translate('filter.all_statuses');
  Set<String> _selectedCategories = {translate('filter.all_categories')};
  double _minPrice = 0;
  double _maxPrice = 1000;

  @override
  void initState() {
    super.initState();
    _fetchAndCacheData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  translate('guarantee_requests.headline'),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xff000089),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Rubik',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.tune, color: Color(0xff000089)),
                onPressed: _showFilterPage,
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _fetchAndCacheData,
            child: GuaranteeRequests(transactions: _filteredTransactions),
          ),
        ),
      ],
    );
  }

  Future<void> _fetchAndCacheData() async {
    try {
      List<Map<String, dynamic>> transactions =
          await _transactionService.fetchTransactions();

      if (mounted) {
        setState(() {
          _allTransactions = transactions;
          _applyFiltersAndSorting();
        });
      }
    } catch (e) {
      print('Failed to fetch and cache data: $e');
    }
  }

  void _applyFiltersAndSorting() {
    String allStatuses = translate("filter.all_statuses");
    String basicStatus = translate("filter.basic_status");
    String turboStatus = translate("filter.turbo_status");
    String allCategories = translate("filter.all_categories");

    String getTypeForStatus(String status) {
      if (status == allStatuses) {
        return 'all';
      } else if (status == basicStatus) {
        return 'basic';
      } else if (status == turboStatus) {
        return 'Turbo';
      } else {
        return 'all';
      }
    }

    String selectedType = getTypeForStatus(_selectedStatus);

    setState(() {
      _filteredTransactions = _allTransactions.where((transaction) {
        bool typeMatches = (selectedType == 'all' ||
            (transaction['type'] ?? '').toLowerCase() == selectedType);

        bool categoryMatches = (_selectedCategories.contains(allCategories) ||
            _selectedCategories.contains(transaction['category'] ?? ''));

        double guaranteePayment =
            (transaction['guaranteePayment'] ?? 0).toDouble();
        bool priceMatches =
            (guaranteePayment >= _minPrice && guaranteePayment <= _maxPrice);

        return typeMatches && categoryMatches && priceMatches;
      }).toList();
    });
  }

  void _showFilterPage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(39)),
          ),
          child: FilterPage(
            minPrice: _minPrice,
            maxPrice: _maxPrice,
            selectedCategories: _selectedCategories,
            selectedStatus: _selectedStatus,
            isFromMyProductsPage: false,
            onApplyFilters: (status, categories, minPrice, maxPrice) {
              setState(() {
                _selectedStatus = status;
                _selectedCategories = categories;
                _minPrice = minPrice;
                _maxPrice = maxPrice;
              });
              _applyFiltersAndSorting();
            },
          ),
        );
      },
    );
  }
}
