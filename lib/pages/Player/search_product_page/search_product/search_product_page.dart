import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/player/search_product_page/display_product_details/product_details_page.dart';
import 'package:hadadi/pages/player/search_product_page/search_product/widgets/category_grid.dart';
import 'package:hadadi/pages/player/search_product_page/search_product/widgets/product_list_item.dart';
import 'package:hadadi/pages/player/search_product_page/search_product/widgets/search_history_with_recommendations.dart';
import 'package:hadadi/services/DB/notification_service.dart';
import 'package:hadadi/services/DB/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchProductPage extends StatefulWidget {
  const SearchProductPage({super.key});

  @override
  _SearchProductPageState createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  final notificationService = NotificationService();
  final ProductService _productService = ProductService();
  String? _selectedCategory;

  Future<void> loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> saveSearchTerm(String term) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!_searchHistory.contains(term)) {
      setState(() {
        _searchHistory.insert(0, term);
        if (_searchHistory.length > 5) {
          _searchHistory = _searchHistory.sublist(0, 5);
        }
      });
      await prefs.setStringList('searchHistory', _searchHistory);
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      filterProducts();
    });
    fetchProductsFromFirestore();
    loadSearchHistory();
  }

  void fetchProductsFromFirestore() async {
    try {
      final products = await _productService.getActiveProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void filterProducts() {
    List<Map<String, dynamic>> results = [];

    if (_searchController.text.isNotEmpty) {
      results = _products
          .where((product) =>
              product['name']
                  ?.toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ??
              false)
          .toList();
    } else if (_selectedCategory != null) {
      results = _products.where((product) {
        final List<dynamic> productCategories = product['category'] ?? [];
        return productCategories.contains(_selectedCategory);
      }).toList();
    } else {
      results = _products;
    }

    setState(() {
      _filteredProducts = results;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      filterProducts();
    });
  }

  List<Map<String, dynamic>> getRecommendedProducts() {
    if (_searchHistory.isNotEmpty) {
      List<Map<String, dynamic>> recommended = _products.where((product) {
        return _searchHistory.any((term) =>
            product['name']?.toLowerCase().contains(term.toLowerCase()) ??
            false);
      }).toList();

      if (recommended.length >= 2) {
        return recommended.take(2).toList();
      } else {
        return recommended +
            _products
                .where((product) => !recommended.contains(product))
                .take(2 - recommended.length)
                .toList();
      }
    } else {
      _products.shuffle();
      return _products.take(2).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5A1F),
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(38),
            bottomRight: Radius.circular(38),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                bottom: 32.0,
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(21),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      filterProducts();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: translate('base_layout.search_placeholder'),
                    hintStyle: const TextStyle(
                      color: Color(0xFF767676),
                      fontFamily: 'Rubik',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF2F2F2),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF767676),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_searchController.text.isNotEmpty ||
                  _selectedCategory != null)
                Align(
                  alignment: LocalizedApp.of(context)
                              .delegate
                              .currentLocale
                              .languageCode ==
                          'he'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = null;
                        _searchController.clear();
                        _filteredProducts = [];
                      });
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Color(0xFF000089),
                    ),
                    label: Text(
                      translate('search_product.reset'),
                      style: const TextStyle(
                        color: Color(0xFF000089),
                      ),
                    ),
                  ),
                ),
              if (_searchController.text.isEmpty && _selectedCategory == null)
                SearchHistoryWithRecommendations(
                  searchHistory: _searchHistory,
                  recommendedProducts: getRecommendedProducts(),
                  onRemoveTerm: (term) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() {
                      _searchHistory.remove(term);
                      prefs.setStringList('searchHistory', _searchHistory);
                    });
                  },
                  onHistoryTap: (term) {
                    setState(() {
                      _searchController.text = term;
                      filterProducts();
                    });
                  },
                  onProductTap: (product) {
                    saveSearchTerm(product['name'] ?? '');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(
                          product: product,
                          saveSearchTerm: saveSearchTerm,
                        ),
                      ),
                    );
                  },
                ),
              if (_searchController.text.isEmpty && _selectedCategory == null)
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: CategoryGridPage(
                    onCategorySelected: _filterByCategory,
                  ),
                ),
              if (_filteredProducts.isNotEmpty)
                Column(
                  children: _filteredProducts.map((product) {
                    return ProductListItem(
                      product: product,
                      onTap: () {
                        saveSearchTerm(_searchController.text.trim());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsPage(
                              product: product,
                              saveSearchTerm: saveSearchTerm,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
