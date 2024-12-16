import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/utils//status_selector/widgets/status_option_tile.dart';
import 'package:hadadi/utils/status_selector/widgets/top_bar_widget.dart';
import 'package:hadadi/utils/status_selector/widgets/search_bar.dart';
import 'package:hadadi/utils/widgets/custom_button.dart';

class StatusSelector extends StatefulWidget {
  final List<String> initialSelectedStatuses;
  final ValueChanged<List<String>> onStatusSelected;
  final String headlineKey;
  final String saveButtonKey;
  final String topButtonKey;
  final bool isSelectAll;
  final int? maxSelection;
  final bool showLimitWarning;

  const StatusSelector({
    super.key,
    required this.initialSelectedStatuses,
    required this.onStatusSelected,
    required this.headlineKey,
    required this.saveButtonKey,
    required this.topButtonKey,
    required this.isSelectAll,
    this.maxSelection,
    this.showLimitWarning = false,
  });

  @override
  _StatusSelectorState createState() => _StatusSelectorState();
}

class _StatusSelectorState extends State<StatusSelector> {
  List<String> _selectedStatuses = [];
  String? _errorMessage;
  final List<String> _statusOptions = [
    'single_parent',
    'disabled_veteran',
    'economic_distress',
    'retiree',
    'person_with_disability',
    'homeless',
    'part_time_worker',
    'new_immigrant',
    'student',
    'active_reserve',
    'legal_dispute',
    'widow_widower',
    'small_business_owner',
    'teacher',
    'kindergarten_teacher',
    'artist',
    'writer_poet',
    'manual_worker',
    'soldier',
    'police_officer',
    'knit_kippah',
    'ultra_orthodox',
    'state_employee',
    'protest_activist',
    'northern_southern_displaced',
    'volunteer_mda_zaka',
    'Volunteer_police'
  ];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedStatuses = List.from(widget.initialSelectedStatuses);
  }

  void _toggleStatus(String statusKey) {
    setState(() {
      if (_selectedStatuses.contains(statusKey)) {
        _selectedStatuses.remove(statusKey);
        _errorMessage = null;
      } else if (widget.maxSelection == null ||
          _selectedStatuses.length < widget.maxSelection!) {
        _selectedStatuses.add(statusKey);
        _errorMessage = null;
      } else {
        _errorMessage = translate('profile.max_status_limit',
            args: {'count': '${widget.maxSelection}'});
      }
    });
    widget.onStatusSelected(_selectedStatuses);
  }

  void _selectOrClearAll() {
    setState(() {
      if (widget.isSelectAll) {
        _selectedStatuses = List.from(_statusOptions);
      } else {
        _selectedStatuses.clear();
      }
      widget.onStatusSelected(_selectedStatuses);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Directionality(
      textDirection: isHebrew ? TextDirection.rtl : TextDirection.ltr,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          color: const Color(0xFFF2F2F2),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBar(
                headlineKey: widget.headlineKey,
                topButtonKey: widget.topButtonKey,
                selectOrClearAll: _selectOrClearAll,
              ),
              const SizedBox(height: 16),
              if (_errorMessage != null && widget.showLimitWarning)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              TopSearchBar(
                searchQuery: searchQuery,
                onSearchChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      children: _statusOptions
                          .where((statusKey) =>
                              translate('profile.status_options.$statusKey')
                                  .toLowerCase()
                                  .contains(searchQuery))
                          .map((statusKey) {
                        String translatedStatus =
                            translate('profile.status_options.$statusKey');
                        bool isSelected = _selectedStatuses.contains(statusKey);

                        return StatusOptionTile(
                          statusKey: statusKey,
                          translatedStatus: translatedStatus,
                          isSelected: isSelected,
                          toggleStatus: _toggleStatus,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: CustomButton(
                    text: translate(widget.saveButtonKey),
                    onPressed: () => Navigator.of(context).pop(),
                    backgroundColor: const Color(0xFF000089),
                    textColor: const Color(0xFFF2F2F2),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
