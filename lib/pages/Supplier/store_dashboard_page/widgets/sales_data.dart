import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/services/DB/transaction_service.dart';
import 'package:intl/intl.dart';

class SalesData {
  SalesData(this.date, this.formattedDate, this.sales);

  final DateTime date;
  final String formattedDate;
  double sales;

  @override
  String toString() {
    return 'SalesData(formattedDate: $formattedDate, sales: $sales)';
  }
}

Future<Map<String, dynamic>> fetchTransactionData(
  String? currentUserId,
  String selectedTimeframe,
  DateTime selectedDate,
  TransactionService transactionService,
  bool isHebrew,
) async {
  if (currentUserId == null) {
    return {
      'salesData': [],
      'totalSales': 0.0,
      'lastMonthSales': 0.0,
      'totalTransactions': 0
    };
  }

  List<Map<String, dynamic>> transactions =
      await transactionService.getTransactionsForSeller(currentUserId);

  List<SalesData> salesData = [];
  double totalSales = 0.0;
  double lastMonthSales = 0.0;
  int totalTransactions = 0;

  DateTime startDate;
  DateTime endDate;

  if (selectedTimeframe == translate('dashboard.timeframe.days')) {
    startDate =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    endDate = startDate.add(const Duration(days: 1));
    for (int i = 0; i < 24; i += 2) {
      DateTime segmentTime = startDate.add(Duration(hours: i));
      salesData.add(SalesData(segmentTime, '${segmentTime.hour}:00', 0));
    }
  } else if (selectedTimeframe == translate('dashboard.timeframe.weeks')) {
    int daysToSunday = (selectedDate.weekday % 7);
    startDate = selectedDate.subtract(Duration(days: daysToSunday));
    endDate = startDate.add(const Duration(days: 6));
    for (int i = 0; i < 7; i++) {
      DateTime day = startDate.add(Duration(days: i));
      String formattedDay =
          DateFormat('dd.MM', isHebrew ? 'he' : 'en').format(day);
      salesData.add(SalesData(day, formattedDay, 0));
    }
  } else if (selectedTimeframe == translate('dashboard.timeframe.months')) {
    startDate = DateTime(selectedDate.year, selectedDate.month, 1);
    endDate = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    for (int i = 0; i < 4; i++) {
      DateTime weekStart = startDate.add(Duration(days: i * 7));
      salesData.add(
          SalesData(weekStart, '${translate('dashboard.week')} ${i + 1}', 0));
    }
  } else {
    startDate = DateTime(selectedDate.year, 1, 1);
    endDate = DateTime(selectedDate.year, 12, 31);
    for (int i = 1; i <= 12; i++) {
      DateTime monthStart = DateTime(selectedDate.year, i, 1);
      String formattedMonth =
          DateFormat('MMM', isHebrew ? 'he' : 'en').format(monthStart);
      salesData.add(SalesData(monthStart, formattedMonth, 0));
    }
  }

  DateTime lastMonthStart =
      DateTime(selectedDate.year, selectedDate.month - 1, 1);
  DateTime lastMonthEnd = DateTime(selectedDate.year, selectedDate.month, 1)
      .subtract(const Duration(days: 1));

  for (var transaction in transactions) {
    DateTime? date = (transaction['purchaseDate'] as Timestamp?)?.toDate();
    double price = (transaction['price'] is int)
        ? (transaction['price'] as int).toDouble()
        : (transaction['price'] as double? ?? 0);
    if (date != null) {
      totalSales += price;
      totalTransactions++;
      if (date.isAfter(lastMonthStart) && date.isBefore(lastMonthEnd)) {
        lastMonthSales += price;
      }
      if (date.isAfter(startDate) &&
          date.isBefore(endDate.add(const Duration(days: 1)))) {
        String formattedDate;

        if (selectedTimeframe == translate('dashboard.timeframe.days')) {
          int hourSegment = date.hour ~/ 2;
          formattedDate = '${hourSegment * 2}:00';
        } else if (selectedTimeframe ==
            translate('dashboard.timeframe.weeks')) {
          formattedDate =
              DateFormat('dd.MM', isHebrew ? 'he' : 'en').format(date);
        } else if (selectedTimeframe ==
            translate('dashboard.timeframe.months')) {
          int weekInMonth = ((date.day - 1) ~/ 7) + 1;
          formattedDate = '${translate('dashboard.week')} $weekInMonth';
        } else {
          formattedDate =
              DateFormat('MMM', isHebrew ? 'he' : 'en').format(date);
        }
        var existingIndex = salesData
            .indexWhere((element) => element.formattedDate == formattedDate);

        if (existingIndex != -1) {
          salesData[existingIndex].sales += price;
        }
      }
    }
  }

  salesData.sort((a, b) => a.date.compareTo(b.date));

  return {
    'salesData': salesData,
    'totalSales': totalSales,
    'lastMonthSales': lastMonthSales,
    'totalTransactions': totalTransactions,
  };
}
