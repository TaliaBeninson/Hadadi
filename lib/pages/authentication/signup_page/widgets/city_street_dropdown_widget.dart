import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/utils/widgets/custom_dropdown.dart';

class CityStreetDropdown extends StatefulWidget {
  final void Function(String city, String street) onSelectionChanged;
  final bool isHebrew;

  const CityStreetDropdown(
      {required this.onSelectionChanged, required this.isHebrew, super.key});

  @override
  _CityStreetDropdownState createState() => _CityStreetDropdownState();
}

class _CityStreetDropdownState extends State<CityStreetDropdown> {
  Map<String, List<String>> cityStreetData = {};
  String? selectedCity;
  String? selectedStreet;
  List<String> cities = [];
  List<String> streets = [];

  @override
  void initState() {
    super.initState();
    _loadCityStreetData();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<Map<String, String>>(
      validator: (value) {
        if (value == null || value['city'] == null || value['city']!.isEmpty) {
          return translate('signup.required');
        }
        if (value['street'] == null || value['street']!.isEmpty) {
          return translate('signup.required');
        }
        return null;
      },
      builder: (field) {
        final hasError = field.hasError;
        if (cityStreetData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomDropdown(
              label: translate('signup.select_city'),
              initialValue: selectedCity,
              items: cities.isNotEmpty ? cities : [''],
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                  streets = cityStreetData[selectedCity] ?? [];
                  streets.sort();
                  selectedStreet = null;
                });
                field.setValue({
                  'city': selectedCity ?? '',
                  'street': selectedStreet ?? '',
                });
                widget.onSelectionChanged(
                    selectedCity ?? '', selectedStreet ?? '');
              },
              hasError:
                  hasError && (selectedCity == null || selectedCity!.isEmpty),
            ),
            if (selectedCity != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CustomDropdown(
                  label: translate('signup.select_street'),
                  initialValue: selectedStreet,
                  items: streets.isNotEmpty ? streets : [''],
                  onChanged: (value) {
                    setState(() {
                      selectedStreet = value;
                    });
                    field.setValue({
                      'city': selectedCity ?? '',
                      'street': selectedStreet ?? '',
                    });
                    widget.onSelectionChanged(
                        selectedCity ?? '', selectedStreet ?? '');
                  },
                  hasError: hasError &&
                      (selectedStreet == null || selectedStreet!.isEmpty),
                ),
              ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _loadCityStreetData() async {
    final String jsonString =
        await rootBundle.loadString('assets/city_street_data.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    setState(() {
      cityStreetData = jsonData.map(
        (key, value) =>
            MapEntry(key, List<String>.from(value as List<dynamic>)),
      );
      cities = cityStreetData.keys.toList()..sort();
    });
  }
}
