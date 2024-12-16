import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/Player/home_page/widgets/bottom_sheet.dart';
import 'package:hadadi/pages/authentication/login_page/login_page.dart';
import 'package:hadadi/pages/authentication/signup_page/signup_page_player.dart';
import 'package:hadadi/services/DB/notification_service.dart';
import 'package:hadadi/services/DB/product_service.dart';
import 'package:hadadi/services/DB/spam_service.dart';
import 'package:hadadi/services/DB/transaction_service.dart';
import 'package:hadadi/services/DB/user_service.dart';
import 'package:hadadi/utils/widgets/guest_login_prompt.dart';
import 'package:share_plus/share_plus.dart';

import 'buyer_detail_dialog.dart';
import 'guarantee_request_card_widget.dart';

class GuaranteeRequestCard extends StatefulWidget {
  final Map<String, dynamic> transaction;
  final String buyerName;
  final String buyerProfile;
  final double buyerCredits;
  final int buyerGuaranteesAmount;
  final String buyerFCM;
  final String buyerPreferredLanguage;
  final bool isGuest;

  const GuaranteeRequestCard({
    super.key,
    required this.transaction,
    required this.buyerName,
    required this.buyerProfile,
    required this.buyerCredits,
    required this.buyerGuaranteesAmount,
    required this.buyerFCM,
    required this.buyerPreferredLanguage,
    required this.isGuest,
  });

  @override
  _GuaranteeRequestCardState createState() => _GuaranteeRequestCardState();
}

class _GuaranteeRequestCardState extends State<GuaranteeRequestCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final notificationService = NotificationService();
  final spamService = SpamService();
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _productService.getProductData(widget.transaction['itemID']),
      builder: (context, productSnapshot) {
        if (productSnapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        if (!productSnapshot.hasData) {
          return const SizedBox.shrink();
        }

        final productData = productSnapshot.data!;
        String productImage = productData['image'] ?? '';

        return GuaranteeRequestCardWidget(
          transaction: widget.transaction,
          isGuest: widget.isGuest,
          buyerName: widget.buyerName,
          buyerProfile: widget.buyerProfile,
          productImg: productImage,
          onSlideConfirmation: _handleSlideConfirmation,
          onShowBuyerDetails: _showBuyerDetails,
          onShareWithFriends: _shareWithFriends,
          onReportSpam: _reportSpam,
        );
      },
    );
  }

  void _reportSpam() async {
    try {
      await spamService.reportSpam(
        transactionId: widget.transaction['transactionID'],
        buyerId: widget.transaction['buyerID'],
        productName: widget.transaction['itemName'],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translate('share.report_spam')),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translate('share.report_spam_failed')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _confirmGuarantee(BuildContext context, Map<String, dynamic> transaction,
      String symbol) async {
    final userService = UserService();
    final transactionService = TransactionService();
    final notificationService = NotificationService();
    final now = DateTime.now();

    try {
      String? currentUserId = await userService.getCurrentUserId();
      if (currentUserId == null) {
        throw 'User not logged in';
      }
      Map<String, dynamic>? currentUserData =
          await userService.getUserData(currentUserId);
      String displayName = currentUserData?['name'] ?? 'Anonymous';

      // Update guarantees for the transaction
      await transactionService.addGuarantee(
        transactionId: transaction['transactionID'],
        guarantorId: currentUserId,
      );

      // Update user guarantees
      await userService.updateUserGuarantees(
        guarantorId: currentUserId,
        buyerId: transaction['buyerID'],
        transactionId: transaction['transactionID'],
      );

      // Add notification for the buyer
      final newGuaranteeNotification = {
        "type": "newGuarantee",
        "timestamp": now.toIso8601String(),
        "name": displayName,
        "uid": currentUserId,
        "product": transaction['itemName'],
        "symbol": symbol,
      };
      await notificationService.addNotification(
        userId: transaction['buyerID'],
        notification: newGuaranteeNotification,
      );

      // Send FCM notification to the buyer
      String newGuaranteeTitle = widget.buyerPreferredLanguage == 'he'
          ? "ערבות חדשה"
          : "New Guarantee";
      String newGuaranteeMessage = widget.buyerPreferredLanguage == 'he'
          ? "$displayName אישר את הערבות עבור ${transaction['name']}."
          : "$displayName has confirmed the guarantee for ${transaction['name']}.";
      await notificationService.sendFCMNotification(
        widget.buyerFCM,
        newGuaranteeTitle,
        newGuaranteeMessage,
      );

      // Check if all guarantees are fulfilled
      bool isGuaranteeComplete = await transactionService.isGuaranteeComplete(
        transactionId: transaction['transactionID'],
      );

      if (isGuaranteeComplete) {
        final finishNotification = {
          "type": "finishGuarantee",
          "timestamp": now.toIso8601String(),
          "name": "",
          "uid": "",
          "product": transaction['itemName'],
          "symbol": "",
        };
        await notificationService.addNotification(
          userId: transaction['buyerID'],
          notification: finishNotification,
        );

        // Send congratulations notification to the buyer
        String congratulationsTitle = widget.buyerPreferredLanguage == 'he'
            ? "מזל טוב!"
            : "Congratulations!";
        String congratulationsMessage = widget.buyerPreferredLanguage == 'he'
            ? "כל הערבויות למוצר ${transaction['name']} אושר לקניה."
            : "All guarantees for ${transaction['name']} have been confirmed for purchase.";
        await notificationService.sendFCMNotification(
          widget.buyerFCM,
          congratulationsTitle,
          congratulationsMessage,
        );
      }
    } catch (e) {
      print('Error in confirming guarantee: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translate('error.generic')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _shareWithFriends() {
    if (widget.transaction['itemName'] != null &&
        widget.transaction['price'] != null) {
      _shareViaAnyApp(
        widget.buyerName,
        widget.transaction['itemName']!,
        widget.transaction['price']!,
      );
    } else {
      print("Error: Missing required fields for sharing.");
    }
  }

  void _handleSlideConfirmation(BuildContext context) {
    if (widget.isGuest) {
      _showGuestLoginPrompt(context);
    } else {
      String? selectedSymbol;

      showModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withOpacity(0.7),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        enableDrag: true,
        builder: (BuildContext context) {
          return AnimatedBottomSheet(onSymbolSelected: (symbol) {
            selectedSymbol = symbol;
            _confirmGuarantee(context, widget.transaction, symbol ?? '');
          });
        },
      ).whenComplete(() {
        if (selectedSymbol == null) {
          _confirmGuarantee(context, widget.transaction, '');
        }
      });
    }
  }

  _showGuestLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => GuestLoginPrompt(
        onSignup: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignupPage()),
        ),
        onLogin: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        ),
      ),
    );
  }

  void _showBuyerDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BuyerDetailsDialog(
        buyerName: widget.buyerName,
        buyerProfile: widget.buyerProfile,
        buyerCredits: widget.buyerCredits,
        buyerGuaranteesAmount: widget.buyerGuaranteesAmount,
      ),
    );
  }

  Future<void> _shareViaAnyApp(
      String buyerName, String productName, int amount) async {
    final String message = translate(
      'share.message',
      args: {
        'productName': productName,
        'buyerName': buyerName,
        'amount': amount.toString(),
      },
    );
    Share.share(message);
  }
}
