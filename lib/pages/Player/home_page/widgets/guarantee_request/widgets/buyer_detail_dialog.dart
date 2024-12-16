import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class BuyerDetailsDialog extends StatelessWidget {
  final String buyerName;
  final String buyerProfile;
  final double buyerCredits;
  final int buyerGuaranteesAmount;

  const BuyerDetailsDialog({
    required this.buyerName,
    required this.buyerProfile,
    required this.buyerCredits,
    required this.buyerGuaranteesAmount,
    super.key,
  });

  List<Widget> _buildStars(double points) {
    int fullStars = (points / 10).floor();
    bool hasHalfStar = (points % 10) >= 5;
    List<Widget> stars = [];

    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(const Icon(Icons.star, color: Colors.amber, size: 30));
      } else if (i == fullStars && hasHalfStar) {
        stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 30));
      } else {
        stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 30));
      }
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Directionality(
      textDirection: isHebrew ? TextDirection.rtl : TextDirection.ltr,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        titlePadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        title: Align(
          alignment: isHebrew ? Alignment.topRight : Alignment.topLeft,
          child: IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF767676)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 64.5,
              backgroundImage: buyerProfile.isNotEmpty
                  ? NetworkImage(buyerProfile)
                  : const AssetImage('assets/robot0.png') as ImageProvider,
            ),
            const SizedBox(height: 12),
            // Buyer Name
            Text(
              buyerName,
              style: const TextStyle(
                color: Color(0xFF0F0F14),
                fontFamily: 'Rubik',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildStars(buyerCredits),
            ),
            const SizedBox(height: 16),
            // Scrollable Details
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(255, 255, 255, 0.8),
                            offset: Offset(-8, -8),
                            blurRadius: 16,
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(215, 215, 215, 0.8),
                            offset: Offset(8, 8),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.shield_outlined,
                            color: Color(0xFF4C52CC)),
                        title: Text(
                          translate('buyer_details.guarantees_provided'),
                          style: const TextStyle(
                            color: Color(0xFF0F0F14),
                            fontFamily: 'Rubik',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Text(
                          '$buyerGuaranteesAmount',
                          style: const TextStyle(
                            color: Color(0xFF000089),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rubik',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: ListTile(
                        leading:
                            const Icon(Icons.check, color: Color(0xFF4C52CC)),
                        title: Text(
                          translate('buyer_details.credits'),
                          style: const TextStyle(
                            color: Color(0xFF0F0F14),
                            fontFamily: 'Rubik',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Text(
                          '$buyerCredits',
                          style: const TextStyle(
                            color: Color(0xFF000089),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rubik',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              translate('buyer_details.close'),
              style: const TextStyle(
                color: Color(0xFF000089),
                fontFamily: 'Rubik',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
