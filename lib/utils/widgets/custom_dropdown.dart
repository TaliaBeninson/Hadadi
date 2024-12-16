import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String label;
  final String? initialValue;
  final List<String> items;
  final void Function(String?) onChanged;
  final bool hasError;
  final bool showSearchBar;
  final String? prependText;

  const CustomDropdown({
    required this.label,
    required this.initialValue,
    required this.items,
    required this.onChanged,
    this.hasError = false,
    this.showSearchBar = true,
    this.prependText,
    Key? key,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selected = await showSearchableDropdown(
          context: context,
          label: widget.label,
          items: widget.items,
          selectedItem: selectedValue,
          showSearchBar: widget.showSearchBar,
        );
        if (selected != null) {
          setState(() {
            selectedValue = selected;
          });
          widget.onChanged(selected);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: widget.hasError ? Colors.red : const Color(0xFFC1C3EE),
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(215, 215, 215, 0.75),
              blurRadius: 12.0,
              spreadRadius: 0.0,
            ),
            BoxShadow(
              color: Colors.white,
              blurRadius: 4.0,
              spreadRadius: -4.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${widget.prependText ?? ""}${selectedValue ?? widget.label}',
                style: const TextStyle(
                  color: Color(0xFF000089),
                  fontFamily: 'Rubik',
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Transform(
              transform: Matrix4.identity()..scale(1.3, 1.0),
              alignment: Alignment.center,
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF4C52CC),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> showSearchableDropdown({
    required BuildContext context,
    required String label,
    required List<String> items,
    String? selectedItem,
    bool showSearchBar = true,
  }) async {
    final TextEditingController searchController = TextEditingController();
    List<String> filteredItems = List.from(items);

    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showSearchBar)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: label,
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xFF999999)),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                        ),
                      ),
                      onChanged: (query) {
                        setState(() {
                          filteredItems = items
                              .where((item) => item
                                  .toLowerCase()
                                  .contains(query.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                if (showSearchBar) const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return ListTile(
                        title: Text(
                          item,
                          style: const TextStyle(
                            color: Color(0xFF0F0F14),
                            fontFamily: 'Rubik',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context, item);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
