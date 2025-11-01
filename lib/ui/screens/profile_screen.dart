import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:drift/drift.dart' as d;

import '../../db/app_db.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  DateTime? _dob;
  bool _loading = true;

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
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final init = _dob ?? DateTime(2008, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: init,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _save() async {
    final db = Get.find<AppDb>();
    final name = _nameCtrl.text.trim();
    final img = _imageCtrl.text.trim();
    await db.upsertProfile(
      ProfilesCompanion(
        id: const d.Value(1),
        name: d.Value<String?>(name.isEmpty ? null : name),
        imagePath: d.Value<String?>(img.isEmpty ? null : img),
        dob: d.Value<DateTime?>(_dob),
      ),
    );
    Get.snackbar('Saved', 'Profile updated');
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _avatarPreview(_imageCtrl.text, _nameCtrl.text),
                SizedBox(width: 4.w),
                Expanded(
                  child: TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: _imageCtrl,
              decoration: const InputDecoration(labelText: 'Image path or URL'),
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _dob == null
                        ? 'DOB: Not set'
                        : 'DOB: ${DateFormat('yMMMd').format(_dob!)}',
                  ),
                ),
                TextButton(onPressed: _pickDob, child: const Text('Pick DOB')),
              ],
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarPreview(String path, String name) {
    final initials = (name.isNotEmpty)
        ? name
              .trim()
              .split(RegExp(r"\s+"))
              .map((e) => e.isNotEmpty ? e[0] : '')
              .take(2)
              .join()
              .toUpperCase()
        : '?';
    return CircleAvatar(
      radius: 28,
      backgroundColor: Colors.grey.shade300,
      backgroundImage: path.startsWith('http') ? NetworkImage(path) : null,
      child: path.startsWith('http')
          ? null
          : Text(initials, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
