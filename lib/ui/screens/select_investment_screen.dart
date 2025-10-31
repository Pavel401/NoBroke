import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/selection_controller.dart';
import '../../routes/app_pages.dart';
import '../../data/investments.dart';

class SelectInvestmentScreen extends StatelessWidget {
  const SelectInvestmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selection = Get.find<SelectionController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Pick an investment')),
      body: ListView.separated(
        padding: EdgeInsets.all(4.w),
        itemBuilder: (context, index) {
          final inv = investments[index];
          return ListTile(
            leading: Text(inv.emoji, style: TextStyle(fontSize: 18.sp)),
            title: Text(inv.name),
            subtitle: Text(inv.symbol),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              selection.pickInvestment(inv.symbol, inv.name, inv.emoji);
              Get.toNamed(Routes.result);
            },
          );
        },
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemCount: investments.length,
      ),
    );
  }
}
