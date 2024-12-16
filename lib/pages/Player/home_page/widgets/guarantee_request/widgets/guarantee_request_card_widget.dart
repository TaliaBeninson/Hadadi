import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/Player/home_page/widgets/guarantee_request/widgets/product_details_widget.dart';
import 'package:hadadi/pages/Player/home_page/widgets/guarantee_request/widgets/reason_widget.dart';
import 'package:hadadi/pages/Player/home_page/widgets/guarantee_request/widgets/transaction_details.dart';

import '../../confirmation_slider.dart';
import 'countdown_timer.dart';

class GuaranteeRequestCardWidget extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final bool isGuest;
  final String? buyerName;
  final String buyerProfile;
  final String productImg;
  final Function(BuildContext) onSlideConfirmation;
  final Function(BuildContext) onShowBuyerDetails;
  final Function() onShareWithFriends;
  final Function() onReportSpam;

  const GuaranteeRequestCardWidget({
    super.key,
    required this.transaction,
    required this.isGuest,
    required this.buyerName,
    required this.buyerProfile,
    required this.productImg,
    required this.onSlideConfirmation,
    required this.onShowBuyerDetails,
    required this.onShareWithFriends,
    required this.onReportSpam,
  });

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color(0xFFF8F8F8),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
              boxShadow: [
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
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: isHebrew
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: TransactionDetails(
                              guarantees: transaction['guarantees'].length,
                              guaranteesAmount: transaction['guaranteesAmount'],
                              type: transaction['type'] ?? 'Unknown',
                              isHebrew: isHebrew,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CountdownTimerWidget(endTime: transaction['endDate']),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        onShowBuyerDetails(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: buyerProfile.isNotEmpty
                              ? NetworkImage(buyerProfile) as ImageProvider
                              : const AssetImage('assets/robot0.png'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          onShowBuyerDetails(context);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              buyerName ?? 'Unknown Buyer',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              translate('widget.product_request', args: {
                                'guaranteePayment':
                                    transaction['guaranteePayment'].toString(),
                              }),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Color(0xFF000089),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      color: const Color(0xFFE4E5FF),
                      elevation: 4, // Shadow depth
                      onSelected: (String value) {
                        if (value == 'share') {
                          onShareWithFriends();
                        } else if (value == 'report') {
                          onReportSpam();
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'share',
                          child: ListTile(
                            leading: const Icon(
                              Icons.share,
                              color: Color(0xFF000089),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Text(
                                translate('widget.share_with_friends'),
                                style: const TextStyle(
                                  color: Color(0xFF000089),
                                  fontFamily: 'Rubik',
                                  fontSize: 16,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  textBaseline: TextBaseline.alphabetic,
                                ),
                              ),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'report',
                          child: ListTile(
                            leading: const Icon(
                              Icons.report,
                              color: Color(0xFF000089),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Text(
                                translate('widget.report_spam'),
                                style: const TextStyle(
                                  color: Color(0xFF000089),
                                  fontFamily: 'Rubik',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  textBaseline: TextBaseline.alphabetic,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black12,
                    image: DecorationImage(
                      image: NetworkImage(productImg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Product Details Widget
                Expanded(
                  child: ProductDetailsWidget(transaction: transaction),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if ((transaction['reasonHeadline'] ?? '').isNotEmpty)
            ReasonWidget(
              reasonHeadline: transaction['reasonHeadline'],
              reasonInfo: transaction['reasonInfo'],
              isHebrew: isHebrew,
            ),
          if ((transaction['reasonHeadline'] ?? '').isNotEmpty)
            const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: RTLSConfirmationSlider(
              onConfirmation: () => onSlideConfirmation(context),
            ),
          )
        ],
      ),
    );
  }
}
