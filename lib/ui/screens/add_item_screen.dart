import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/items_controller.dart';
import '../../services/audio_service.dart';
import '../icon_utils.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  String? _selectedIconName;
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = Get.find<ItemsController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Add Custom Item')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(2.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create a custom purchase with icon + category',
                style: TextStyle(fontSize: 11.sp),
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter a name' : null,
              ),
              SizedBox(height: 1.5.h),
              Obx(() {
                final cats = items.categories;
                return DropdownButtonFormField<String>(
                  initialValue:
                      _selectedCategory != null &&
                          cats.contains(_selectedCategory)
                      ? _selectedCategory
                      : null,
                  items: cats
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCategory = v),
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Select a category' : null,
                );
              }),
              SizedBox(height: 1.5.h),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  child: _selectedIconName == null
                      ? const Icon(Icons.category)
                      : Icon(iconFromName(_selectedIconName)),
                ),
                title: const Text('Icon'),
                subtitle: Text(_selectedIconName ?? 'Choose a Material icon'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  AudioService().playButtonClick();
                  final picked = await showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) =>
                        _IconPickerSheet(initial: _selectedIconName),
                  );
                  if (picked != null)
                    setState(() => _selectedIconName = picked);
                },
              ),
              SizedBox(height: 1.5.h),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(
                  labelText: 'Default price (optional)',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              SizedBox(height: 1.5.h),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
                maxLines: 2,
              ),
              SizedBox(height: 1.h),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final price = double.tryParse(
                      _priceCtrl.text.replaceAll(',', ''),
                    );
                    await items.addItem(
                      name: _nameCtrl.text.trim(),
                      category: _selectedCategory!,
                      emoji: null,
                      iconName: _selectedIconName,
                      description: _descCtrl.text.trim().isEmpty
                          ? null
                          : _descCtrl.text.trim(),
                      kidSpecific: true,
                      defaultPrice: price,
                    );
                    Get.back();
                    Get.snackbar('Saved', 'Custom item added');
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconPickerSheet extends StatefulWidget {
  const _IconPickerSheet({this.initial});
  final String? initial;

  @override
  State<_IconPickerSheet> createState() => _IconPickerSheetState();
}

class _IconPickerSheetState extends State<_IconPickerSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = knownIconNames
        .where((n) => n.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pick an icon',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search icons',
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 320,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final name = filtered[index];
                  final selected = name == widget.initial;
                  return InkWell(
                    onTap: () {
                      AudioService().playButtonClick();
                      Navigator.pop(context, name);
                    },
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: selected
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.15)
                            : null,
                        child: Icon(
                          iconFromName(name),
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
