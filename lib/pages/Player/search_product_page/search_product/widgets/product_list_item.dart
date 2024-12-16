import 'package:flutter/material.dart';

class ProductListItem extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const ProductListItem({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                style: const TextStyle(
                  color: Color(0xFF0F0F14),
                  fontFamily: 'Rubik',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '₪${product['price'] ?? '0'}',
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
  }
}
