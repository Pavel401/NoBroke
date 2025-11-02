import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:drift/drift.dart' as d;

import '../../db/app_db.dart';
import '../colors.dart';
import '../components/awesome_snackbar_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  DateTime? _dob;
  String? _gender;
  bool _loading = true;
  bool _saving = false;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = Get.isRegistered<AppDb>()
        ? Get.find<AppDb>()
        : Get.put(AppDb(), permanent: true);
    final p = await db.getProfile();
    if (p != null) {
      _nameCtrl.text = p.name ?? '';
      _imageCtrl.text = p.imagePath ?? '';
      _dob = p.dob;
      _gender = p.gender;
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  int? get _calculatedAge {
    if (_dob == null) return null;
    final now = DateTime.now();
    int age = now.year - _dob!.year;
    if (now.month < _dob!.month ||
        (now.month == _dob!.month && now.day < _dob!.day)) {
      age--;
    }
    return age;
  }

  Future<void> _pickDob() async {
    final init = _dob ?? DateTime(2008, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: TurfitColors.primary(context),
              onPrimary: TurfitColors.white(context),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final db = Get.find<AppDb>();
      final name = _nameCtrl.text.trim();
      final img = _imageCtrl.text.trim();

      await db.upsertProfile(
        ProfilesCompanion(
          id: const d.Value(1),
          name: d.Value<String?>(name.isEmpty ? null : name),
          imagePath: d.Value<String?>(img.isEmpty ? null : img),
          dob: d.Value<DateTime?>(_dob),
          gender: d.Value<String?>(_gender),
        ),
      );

      AwesomeSnackbarHelper.showSuccess(
        context,
        'Profile Saved! 🎉',
        'Your information has been updated successfully',
      );

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      AwesomeSnackbarHelper.showError(
        context,
        'Save Failed',
        'There was an error saving your profile. Please try again.',
      );
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: TurfitColors.primary(context),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar Section
              _buildAvatar(),
              SizedBox(height: 3.h),

              // Name Field
              _buildTextField(
                controller: _nameCtrl,
                label: 'Full Name',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),
              SizedBox(height: 2.h),

              // Date of Birth Field
              _buildDateField(),
              SizedBox(height: 2.h),

              // Gender Field
              _buildGenderField(),
              SizedBox(height: 2.h),

              // // Image URL Field (Optional)
              // _buildTextField(
              //   controller: _imageCtrl,
              //   label: 'Profile Image URL (Optional)',
              //   icon: Icons.image_outlined,
              //   onChanged: (value) => setState(() {}),
              // ),
              // SizedBox(height: 4.h),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TurfitColors.primary(context),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          'Save Profile',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final path = _imageCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    final initials = name.isNotEmpty
        ? name
              .split(RegExp(r"\s+"))
              .map((e) => e.isNotEmpty ? e[0] : '')
              .take(2)
              .join()
              .toUpperCase()
        : '?';

    return CircleAvatar(
      radius: 40,
      backgroundColor: TurfitColors.primary(context).withOpacity(0.2),
      backgroundImage: path.startsWith('http') ? NetworkImage(path) : null,
      child: path.startsWith('http')
          ? null
          : Text(
              initials,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: TurfitColors.primary(context),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: TurfitColors.primary(context)),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: _pickDob,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: Colors.grey.shade600),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date of Birth',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _dob == null
                        ? 'Select your birthday'
                        : DateFormat('MMM dd, yyyy').format(_dob!),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: _dob == null
                          ? Colors.grey.shade500
                          : Colors.black87,
                    ),
                  ),
                  if (_calculatedAge != null)
                    Text(
                      '$_calculatedAge years old',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: TurfitColors.primary(context),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      initialValue: _gender,
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: GoogleFonts.poppins(),
        prefixIcon: const Icon(Icons.people_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: TurfitColors.primary(context)),
        ),
      ),
      style: GoogleFonts.poppins(color: Colors.black87),
      items: _genderOptions.map((String gender) {
        return DropdownMenuItem<String>(value: gender, child: Text(gender));
      }).toList(),
      onChanged: (String? newValue) {
        setState(() => _gender = newValue);
      },
      hint: Text(
        'Select gender',
        style: GoogleFonts.poppins(color: Colors.grey.shade500),
      ),
    );
  }
}
