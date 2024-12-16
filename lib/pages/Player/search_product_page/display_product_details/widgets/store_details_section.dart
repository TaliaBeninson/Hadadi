import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/services/DB/store_service.dart';

class StoreDetailsWidget extends StatelessWidget {
  final String storeID;
  final StoreService _storeService = StoreService();

  StoreDetailsWidget({super.key, required this.storeID});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _storeService.fetchStoreDetails(storeID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return Center(
            child: Text(
              translate('store_details.error_fetching'),
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          return _buildStoreDetails(context, snapshot.data!);
        }
      },
    );
  }

  Widget _buildStoreDetails(BuildContext context, Map<String, dynamic> store) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return IntrinsicHeight(
      child: Row(
        textDirection: isHebrew ? TextDirection.rtl : TextDirection.ltr,
        children: [
          _buildLogoSection(store, isHebrew),
          _buildDetailsSection(context, store, isHebrew),
        ],
      ),
    );
  }

  Widget _buildLogoSection(Map<String, dynamic> store, bool isHebrew) {
    return Expanded(
      flex: 1,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: isHebrew
              ? const BorderRadius.only(
                  topRight: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  bottomLeft: Radius.circular(22),
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: const Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.network(
                store['logo'] ?? '',
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, size: 50),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              store['storeName'] ?? 'לא זמין',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF4C52CC),
                fontFamily: 'Rubik',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(
      BuildContext context, Map<String, dynamic> store, bool isHebrew) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: isHebrew
              ? const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  bottomLeft: Radius.circular(22),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: const Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: isHebrew
              ? const EdgeInsets.only(right: 40, top: 25, bottom: 25)
              : const EdgeInsets.only(left: 40, top: 25, bottom: 25),
          child: Column(
            crossAxisAlignment:
                isHebrew ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              _buildDetail('כתובת', store['address'] ?? 'לא זמין'),
              const SizedBox(height: 8),
              _buildDetail('מספר טלפון', store['phone'] ?? 'לא זמין'),
              const SizedBox(height: 8),
              _buildDetail('דוא״ל', store['email'] ?? 'לא זמין'),
              const SizedBox(height: 8),
              _buildDetail('WhatsApp', store['whatsapp'] ?? 'לא זמין'),
              const SizedBox(height: 8),
              _buildDetail('מספר עסק', store['businessNumber'] ?? 'לא זמין'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String title, String value) {
    return Row(
      children: [
        Flexible(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF000089),
              fontFamily: 'Rubik',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0F0F14),
              fontFamily: 'Rubik',
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
