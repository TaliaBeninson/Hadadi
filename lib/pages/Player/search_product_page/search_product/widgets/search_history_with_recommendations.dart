import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class SearchHistoryWithRecommendations extends StatelessWidget {
  final List<String> searchHistory;
  final List<Map<String, dynamic>> recommendedProducts;
  final Function(String) onRemoveTerm;
  final Function(String) onHistoryTap;
  final Function(Map<String, dynamic>) onProductTap;

  const SearchHistoryWithRecommendations({
    Key? key,
    required this.searchHistory,
    required this.recommendedProducts,
    required this.onRemoveTerm,
    required this.onHistoryTap,
    required this.onProductTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (searchHistory.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              translate('search_product.recent_searches'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000089),
                fontFamily: 'Rubik',
              ),
              textAlign: isHebrew ? TextAlign.right : TextAlign.left,
            ),
          ),
        ...searchHistory.map((term) {
          return Column(
            children: [
              GestureDetector(
                onTap: () => onHistoryTap(term),
                child: Row(
                  children: [
                    const Icon(Icons.history,
                        color: Color(0xFF0F0F14), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Align(
                        alignment: isHebrew
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          term,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F0F14),
                            fontFamily: 'Rubik',
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => onRemoveTerm(term),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Color(0xFFC1C3EE),
                thickness: 0.5,
                indent: 16,
                endIndent: 16,
              ),
            ],
          );
        }),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            translate('search_product.Recommendations'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000089),
              fontFamily: 'Rubik',
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Column(
          children: recommendedProducts.map((product) {
            return GestureDetector(
              onTap: () => onProductTap(product),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
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
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade300,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          product['image'] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        product['name'] ?? '',
                        textAlign: isHebrew ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(
                          color: Color(0xFF0F0F14),
                          fontFamily: 'Rubik',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '₪${product['price']}',
                      style: const TextStyle(
                        color: Color(0xFF000089),
                        fontFamily: 'Rubik',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
