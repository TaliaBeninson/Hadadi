import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/player/profile_page/widgets/profile_editable_fields.dart';
import 'package:hadadi/pages/player/profile_page/widgets/status_section.dart';
import 'package:hadadi/pages/player/profile_page/widgets/styled_info_card.dart';
import 'package:hadadi/services/DB/image_upload_service.dart';
import 'package:hadadi/services/DB/user_service.dart';
import 'package:hadadi/utils/status_selector/status_selector.dart';
import 'package:hadadi/utils/widgets/profile_image_section.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = true;
  bool _isEditingName = false;
  bool _isEditingPhone = false;
  bool _isGuest = false;

  String? _email;
  String? _name;
  String? _phone;
  double _credits = 0;
  int _guaranteesProvided = 0;
  int _guaranteesReceived = 0;
  String? _profileImageUrl;
  File? _profileImage;

  List<String> _selectedStatuses = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Directionality(
      textDirection: isHebrew ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFF5A1F),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            translate('profile.title'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          elevation: 0,
          toolbarHeight: 82,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(38),
              bottomRight: Radius.circular(38),
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileImageSection(
                        profileImageUrl: _profileImageUrl,
                        updateProfilePicture: _updateProfilePicture,
                        isGuest: _isGuest,
                        size: 135,
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          _email ?? '',
                          style: const TextStyle(
                            color: Color(0xFF0F0F14),
                            fontFamily: 'Rubik',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      EditableField(
                        label: translate('signup.full_name'),
                        content: _name ?? '',
                        controller: _nameController,
                        isEditing: _isEditingName,
                        onEdit: () {
                          setState(() {
                            _isEditingName = true;
                            _isEditingPhone = false;
                            _nameController.text = _name ?? '';
                          });
                        },
                        onSave: _updateName,
                      ),
                      const SizedBox(height: 24),
                      EditableField(
                        label: translate('signup.phone_number'),
                        content: _phone ?? '',
                        controller: _phoneController,
                        isEditing: _isEditingPhone,
                        onEdit: () {
                          setState(() {
                            _isEditingPhone = true;
                            _isEditingName = false;
                            _phoneController.text = _phone ?? '';
                          });
                        },
                        onSave: _updatePhone,
                      ),
                      const SizedBox(height: 34),
                      if (!_isGuest)
                        StatusSection(
                          selectedStatuses: _selectedStatuses,
                          selectStatus: _selectStatus,
                        ),
                      const SizedBox(height: 16),
                      _buildNumbersList(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildNumbersList() {
    if (_isGuest) {
      return Column(
        children: [
          StyledInfoCard(
              label: translate('profile.points_earned'),
              value: '0',
              iconData: Icons.star_border),
          StyledInfoCard(
              label: translate('profile.guarantees_provided'),
              value: '0',
              iconData: Icons.shield_outlined),
          StyledInfoCard(
              label: translate('profile.guarantees_received'),
              value: '0',
              iconData: Icons.check),
          StyledInfoCard(
              label: translate('profile.transactions_approved'),
              value: '0',
              iconData: Icons.attach_money),
          StyledInfoCard(
              label: translate('profile.payments_cleared'),
              value: '0',
              iconData: Icons.credit_card),
          StyledInfoCard(
              label: translate('profile.debt_balance'),
              value: '0',
              iconData: Icons.money_off),
          StyledInfoCard(
              label: translate('profile.next_month_payment'),
              value: '0',
              iconData: Icons.calendar_today),
        ],
      );
    } else {
      return Column(
        children: [
          StyledInfoCard(
              label: translate('profile.points_earned'),
              value: '$_credits',
              iconData: Icons.star_border),
          StyledInfoCard(
              label: translate('profile.guarantees_provided'),
              value: '$_guaranteesProvided',
              iconData: Icons.shield_outlined),
          StyledInfoCard(
              label: translate('profile.guarantees_received'),
              value: '$_guaranteesReceived',
              iconData: Icons.check),
          StyledInfoCard(
              label: translate('profile.transactions_approved'),
              value: '0',
              iconData: Icons.attach_money),
          StyledInfoCard(
              label: translate('profile.payments_cleared'),
              value: '0',
              iconData: Icons.credit_card),
          StyledInfoCard(
              label: translate('profile.debt_balance'),
              value: '0',
              iconData: Icons.money_off),
          StyledInfoCard(
              label: translate('profile.next_month_payment'),
              value: '0',
              iconData: Icons.calendar_today),
        ],
      );
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final String? userId = await _userService.getCurrentUserId();

      if (userId == null) {
        setState(() {
          _isGuest = true;
          _displayGuestData();
        });
        return;
      }
      final Map<String, dynamic>? data = await _userService.getUserData(userId);

      if (data != null) {
        setState(() {
          _isGuest = false;
          _name = data['name'] ?? '';
          _phone = data['phone'] ?? '';
          _email = data['email'] ?? '';
          _credits = data['credits'] ?? 0.0;
          _profileImageUrl = data['profilePic'];

          _guaranteesProvided =
              (data['guaranteesProvided'] as List?)?.length ?? 0;
          _guaranteesReceived =
              (data['guaranteesReceived'] as List?)?.length ?? 0;
          _selectedStatuses = List<String>.from(data['statuses'] ?? []);

          _isLoading = false;
        });
      } else {
        setState(() {
          _isGuest = true;
          _displayGuestData();
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isGuest = true;
        _displayGuestData();
      });
    }
  }

  void _displayGuestData() {
    setState(() {
      _name = translate('profile.guest_user');
      _phone = '0500000000';
      _email = 'guest@example.com';
      _credits = 0;
      _guaranteesProvided = 0;
      _guaranteesReceived = 0;
      _profileImageUrl = null;
      _isLoading = false;
    });
  }

  Future<void> _updateName() async {
    if (_isGuest) return;
    setState(() => _isLoading = true);
    try {
      await _userService.updateUserData({'name': _nameController.text});
      setState(() {
        _name = _nameController.text;
        _isEditingName = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(translate('profile.update_success'))));
    } catch (e) {
      throw ('Failed to update name: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updatePhone() async {
    if (_isGuest) return;
    setState(() => _isLoading = true);
    try {
      await _userService.updateUserData({'phone': _phoneController.text});
      setState(() {
        _phone = _phoneController.text;
        _isEditingPhone = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(translate('profile.update_success'))));
    } catch (e) {
      throw ('Failed to update phone: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfilePicture() async {
    if (_isGuest) return;
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      setState(() {
        _profileImage = File(pickedFile.path);
        _isLoading = true;
      });

      // Use the ImageUploadService to handle the upload
      final imageUploadService = ImageUploadService();
      final downloadUrl =
          await imageUploadService.uploadProfileImage(_profileImage!);

      if (downloadUrl == null) {
        throw ('Failed to upload image');
      }

      // Update user data with the new profile picture URL
      await _userService.updateUserData({'profilePic': downloadUrl});
      setState(() {
        _profileImageUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('תמונת הפרופיל עודכנה בהצלחה')),
      );
    } catch (e) {
      throw ('Failed to upload image: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _selectStatus() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatusSelector(
          initialSelectedStatuses: _selectedStatuses,
          onStatusSelected: (statuses) async {
            setState(() => _selectedStatuses = statuses);
            await _updateStatusesInFirebase();
          },
          headlineKey: 'profile.select_status',
          saveButtonKey: 'profile.save_changes',
          topButtonKey: 'profile.clear_all',
          isSelectAll: false,
          maxSelection: 5,
          showLimitWarning: true,
        );
      },
    );
  }

  Future<void> _updateStatusesInFirebase() async {
    if (_isGuest) return;

    try {
      await _userService.updateUserData({'statuses': _selectedStatuses});
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(translate('profile.update_success'))));
    } catch (e) {
      throw ('Failed to update statuses: $e');
    }
  }
}
