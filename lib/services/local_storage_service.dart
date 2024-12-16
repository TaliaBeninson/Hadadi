import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _userCountKey = 'user_count';
  static const _transactionsCountKey = 'transactions_count';
  static const _transactionsSumKey = 'transactions_sum';
  static const _productsCountKey = 'products_count';

  Future<void> saveCounts({
    required int userCount,
    required int transactionsCount,
    required double transactionsSum,
    required int productsCount,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userCountKey, userCount);
    await prefs.setInt(_transactionsCountKey, transactionsCount);
    await prefs.setDouble(_transactionsSumKey, transactionsSum);
    await prefs.setInt(_productsCountKey, productsCount);
  }

  Future<Map<String, dynamic>> getCounts() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userCount': prefs.getInt(_userCountKey) ?? 0,
      'transactionsCount': prefs.getInt(_transactionsCountKey) ?? 0,
      'transactionsSum': prefs.getDouble(_transactionsSumKey) ?? 0.0,
      'productsCount': prefs.getInt(_productsCountKey) ?? 0,
    };
  }
}
