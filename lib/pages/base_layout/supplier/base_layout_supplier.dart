import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/Supplier/store_dashboard_page/store_dashboard.dart';
import 'package:hadadi/pages/Supplier/store_purchases/store_purchases.dart';
import 'package:hadadi/pages/base_layout/supplier/widgets/supplier_bottom_navigation_bar.dart';
import 'package:hadadi/pages/base_layout/supplier/widgets/supplier_drawer_widget.dart';
import 'package:hadadi/pages/welcome_page/welcome_page.dart';
import 'package:hadadi/services/DB/store_service.dart';
import 'package:hadadi/services/auth_service.dart';

class BaseLayoutSupplier extends StatefulWidget {
  final String? userID;

  const BaseLayoutSupplier({super.key, required this.userID});

  @override
  _BaseLayoutSupplierState createState() => _BaseLayoutSupplierState();
}

class _BaseLayoutSupplierState extends State<BaseLayoutSupplier> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();
  final StoreService _storeService = StoreService();
  Map<String, dynamic>? _storeData;
  bool _isLoading = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStoreDetails();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      SupplierDashboardPage(storeData: _storeData),
      const Center(child: Text('My Products Page')),
      const Center(child: Text('Add Product Page')),
      const PurchasesPage(),
      const Center(child: Text('Notifications Page')),
    ];

    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';
    return Directionality(
      textDirection: isHebrew ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFF5A1F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(38),
                bottomRight: Radius.circular(38),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(255, 203, 187, 0.40),
                  offset: Offset(-8, -8),
                  blurRadius: 16,
                ),
                BoxShadow(
                  color: Color.fromRGBO(255, 149, 128, 0.40),
                  offset: Offset(8, 8),
                  blurRadius: 16,
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          _storeData != null
                              ? _storeData!['storeName'] ?? 'Store Name'
                              : '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rubik',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.network(
                          'https://via.placeholder.com/40',
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        drawer: SupplierDrawerWidget(
            name: _storeData?['storeName'] ?? "",
            email: _storeData?['email'] ?? "example@gmail.com",
            profileImageUrl:
                _storeData?['logo'] ?? 'https://via.placeholder.com/40',
            role: "קונה",
            onLogout: _logout,
            onNavigate: _onItemTapped),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : IndexedStack(
                index: _selectedIndex,
                children: pages,
              ),
        bottomNavigationBar: StoreBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }

  Future<void> _fetchStoreDetails() async {
    setState(() {
      _isLoading = true;
    });
    final storeData =
        await _storeService.fetchStoreDetailsByOwnerID(widget.userID);
    setState(() {
      _storeData = storeData;
      _isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await _authService.signOut();
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const WelcomePage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(translate('auth.logout_failed'))),
      );
    }
  }
}
