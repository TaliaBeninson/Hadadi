import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/services/DB/user_service.dart';
import 'package:intl/intl.dart';

class GuarantorsExpansionTile extends StatefulWidget {
  final List<dynamic>? guarantees;

  const GuarantorsExpansionTile({
    super.key,
    this.guarantees,
  });

  @override
  _GuarantorsExpansionTileState createState() =>
      _GuarantorsExpansionTileState();
}

class _GuarantorsExpansionTileState extends State<GuarantorsExpansionTile> {
  final UserService _userService = UserService();

  bool _isExpanded = false;
  List<Map<String, dynamic>> _guarantors = [];

  @override
  void initState() {
    super.initState();
    if (_isExpanded && _guarantors.isEmpty) {
      _fetchGuarantors();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        title: Text(
          translate('my_products.view_guarantors'),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xff4C52CC),
          ),
        ),
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          size: 30,
          color: const Color(0xFF4C52CC),
        ),
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
          if (expanded && _guarantors.isEmpty) {
            _fetchGuarantors();
          }
        },
        children: _guarantors.isEmpty
            ? [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    translate('my_products.no_guarantors'),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ]
            : _guarantors.map((guarantor) {
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: guarantor['profilePic'] != null
                            ? NetworkImage(guarantor['profilePic'])
                            : null,
                        child: guarantor['profilePic'] == null
                            ? const Icon(Icons.person, color: Colors.grey)
                            : null,
                      ),
                      title: Text(
                        guarantor['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('dd-MM-yyyy HH:mm')
                            .format(guarantor['timestamp'].toDate()),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      tileColor: Colors.transparent,
                    ),
                    if (guarantor != _guarantors.last)
                      const Divider(
                        thickness: 1,
                        color: Color(0xffE0E0E0),
                        indent: 16,
                        endIndent: 16,
                      ),
                  ],
                );
              }).toList(),
      ),
    );
  }

  Future<void> _fetchGuarantors() async {
    try {
      List<Map<String, dynamic>> guarantorDetails = [];
      List<Map<String, dynamic>> guarantees = [];

      if (widget.guarantees != null) {
        guarantees = widget.guarantees!
            .map((g) => {
                  'guarantorID': g['guarantorID'],
                  'timestamp': g['timestamp'],
                })
            .toList();
      }

      // Fetch guarantor details
      for (var guarantee in guarantees) {
        String guarantorID = guarantee['guarantorID'];
        Timestamp timestamp = guarantee['timestamp'];

        var guarantorData = await _userService.getUserData(guarantorID);
        if (guarantorData != null) {
          guarantorDetails.add({
            'name': guarantorData['name'],
            'profilePic': guarantorData['profilePic'],
            'timestamp': timestamp,
          });
        }
      }

      setState(() {
        _guarantors = guarantorDetails;
      });
    } catch (e) {
      print('Failed to fetch guarantors: $e');
    }
  }
}
