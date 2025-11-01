import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/selection_controller.dart';
import '../../routes/app_pages.dart';
import '../icon_utils.dart';

class EnterPriceScreen extends StatefulWidget {
  const EnterPriceScreen({super.key});

  @override
  State<EnterPriceScreen> createState() => _EnterPriceScreenState();
}

class _EnterPriceScreenState extends State<EnterPriceScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final defaultPrice = (Get.arguments as num?)?.toDouble() ?? 0.0;
    _controller = TextEditingController(text: defaultPrice.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selection = Get.find<SelectionController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Enter price')),
      body: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final iconName = selection.selectedItemIconName.value;
              final leading = iconName.isNotEmpty
                  ? Icon(iconFromName(iconName), size: 20.sp)
                  : Icon(Icons.category, size: 20.sp);
              return Row(
                children: [
                  leading,
                  SizedBox(width: 3.w),
                  Text(
                    selection.selectedItemName.value,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: 2.h),
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'How much are you spending?',
              ),
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                final value = double.tryParse(
                  _controller.text.replaceAll(',', ''),
                );
                if (value == null || value <= 0) {
                  Get.snackbar(
                    'Invalid amount',
                    'Please enter a positive number',
                  );
                  return;
                }
                selection.setPrice(value);
                Get.toNamed(Routes.selectInvestment);
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
