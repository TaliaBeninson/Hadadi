import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/Supplier/store_dashboard_page/widgets/date_navigator.dart';
import 'package:hadadi/pages/Supplier/store_dashboard_page/widgets/louder_or_error.dart';
import 'package:hadadi/pages/Supplier/store_dashboard_page/widgets/sales_data.dart';
import 'package:hadadi/pages/Supplier/store_dashboard_page/widgets/sales_trend_chart.dart';
import 'package:hadadi/pages/Supplier/store_dashboard_page/widgets/stat_card.dart';
import 'package:hadadi/pages/Supplier/store_dashboard_page/widgets/time_frame.dart';
import 'package:hadadi/services/DB/transaction_service.dart';
import 'package:hadadi/services/DB/user_service.dart';

class SupplierDashboardPage extends StatefulWidget {
  final Map<String, dynamic>? storeData;

  const SupplierDashboardPage({super.key, this.storeData});

  @override
  _SupplierDashboardPageState createState() => _SupplierDashboardPageState();
}

class _SupplierDashboardPageState extends State<SupplierDashboardPage> {
  final UserService _userService = UserService();
  final TransactionService transactionService = TransactionService();
  String? _currentUserId;
  String _selectedTimeframe = translate('dashboard.timeframe.days');
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Directionality(
      textDirection: isHebrew ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: isHebrew ? Alignment.topRight : Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                  child: Text(
                    translate('store_layout.dashboard'),
                    style: const TextStyle(
                      color: Color(0xFF000089),
                      fontFamily: 'Rubik',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              DateNavigator(
                  selectedDate: _selectedDate,
                  selectedTimeframe: _selectedTimeframe,
                  onDateChange: _adjustSelectedDate,
                  isHebrew: isHebrew),
              const SizedBox(height: 20),
              Timeframe(
                selectedTimeframe: _selectedTimeframe,
                onTimeframeChange: (String newTimeframe) {
                  setState(() {
                    _selectedTimeframe = newTimeframe;
                    _selectedDate = DateTime.now();
                  });
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<Map<String, dynamic>>(
                future: fetchTransactionData(
                  _currentUserId,
                  _selectedTimeframe,
                  _selectedDate,
                  transactionService,
                  isHebrew,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text(translate('error_loading_data')));
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    final salesData = data['salesData'] as List<SalesData>;
                    final totalSales = formatPrice(data['totalSales']);
                    final lastMonthSales = formatPrice(data['lastMonthSales']);
                    final totalTransactions = data['totalTransactions'];

                    return Column(
                      children: [
                        LoaderOrError(
                          snapshot: snapshot,
                          child: (data) => SalesTrendChart(
                              data: salesData, isHebrew: isHebrew),
                        ),
                        const SizedBox(height: 20),
                        Row(children: [
                          Expanded(
                            child: StatCard(
                              number: "₪$totalSales",
                              assetPath: 'assets/supplier/income.png',
                              mainColor: const Color(0xFF000089),
                              bottomText: translate('dashboard.total_revenue'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: StatCard(
                              number: "$totalTransactions",
                              assetPath: 'assets/supplier/deals.png',
                              mainColor: const Color(0xFFF7B500),
                              bottomText: translate('dashboard.total_orders'),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                number: "₪$lastMonthSales",
                                assetPath: 'assets/supplier/future.png',
                                mainColor: const Color(0xFFFF5A1F),
                                bottomText:
                                    translate('dashboard.outstanding_payments'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: StatCard(
                                number: "54%",
                                assetPath: 'assets/supplier/success.png',
                                mainColor: const Color(0xFF4C52CC),
                                bottomText:
                                    translate('dashboard.successful_orders'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Center(child: Text(translate('no_data')));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializeUserId() async {
    String? userId = await _userService.getCurrentUserId();
    setState(() {
      _currentUserId = userId;
    });
  }

  void _adjustSelectedDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  String formatPrice(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }
}
