import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/Player/home_page/widgets/guarantee_request/widgets/guarantee_request_card.dart';
import 'package:hadadi/services/DB/user_service.dart';

class GuaranteeRequests extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final UserService _userService = UserService();

  GuaranteeRequests({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(child: Text(translate('widget.no_results')));
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return FutureBuilder<Map<String, dynamic>?>(
          future: _userService.getUserData(transaction['buyerID']),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return const SizedBox.shrink();
            }

            var userData = snapshot.data!;

            String buyerName = userData['name'] ?? 'Unknown Buyer';
            String buyerProfile = userData['profilePic'] ?? '';
            double buyerCredits = userData['credits']?.toDouble() ?? 0.0;
            int buyerGuaranteesAmount =
                (userData['guarantees'] as List?)?.length ?? 0;
            String buyerFCM = userData['fcmToken'] ?? '';
            String buyerPreferredLanguage =
                userData['preferredLanguage'] ?? "he";

            return GuaranteeRequestCard(
              transaction: transaction,
              buyerName: buyerName,
              buyerProfile: buyerProfile,
              buyerCredits: buyerCredits,
              buyerGuaranteesAmount: buyerGuaranteesAmount,
              buyerFCM: buyerFCM,
              buyerPreferredLanguage: buyerPreferredLanguage,
              isGuest: false,
            );
          },
        );
      },
    );
  }
}
