import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyapp/data/models/transaction_info.dart';
import 'package:sizer/sizer.dart';
import '../controllers/transaction_controller.dart';
import '../widgets/custom_widgets.dart';
import '../../core/theme/app_theme.dart';

class SmsParserTestScreen extends StatefulWidget {
  const SmsParserTestScreen({super.key});

  @override
  State<SmsParserTestScreen> createState() => _SmsParserTestScreenState();
}

class _SmsParserTestScreenState extends State<SmsParserTestScreen> {
  final TextEditingController _smsController = TextEditingController();
  final TransactionController _transactionController =
      Get.find<TransactionController>();

  // Sample SMS messages for testing
  final List<String> sampleSMS = [
    'Rs.500.00 debited from A/c XX1234 on 04-11-25. UPI/P2P/441234567890/zomato@paytm Info:9876543210. Avl Bal:Rs.5000.00',
    'Your A/C XX5678 is credited with Rs 10,000.00 on 03-Nov-25. Available Balance: Rs 15,000.00',
    'Rs 250 spent on SBI Credit Card XX9012 at SWIGGY on 02-NOV-25. Avl Credit Limit Rs 48,750.00',
  ];

  @override
  void dispose() {
    _smsController.dispose();
    super.dispose();
  }

  void _testParseSms() {
    final smsText = _smsController.text.trim();
    if (smsText.isEmpty) {
      Get.snackbar('Error', 'Please enter SMS text');
      return;
    }

    TransactionInfo transactionInfo = _transactionController.smsService
        .parseTransactionFromSms(smsText)!;

    _showParsedResult(transactionInfo);
  }

  void _showParsedResult(TransactionInfo transactionInfo) {
    Get.dialog(
      AlertDialog(
        title: const Text('Parsed Transaction Info'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                'Transaction Type',
                transactionInfo.transaction.type?.name ?? 'N/A',
              ),
              _buildInfoRow(
                'Amount',
                transactionInfo.transaction.amount ?? 'N/A',
              ),
              _buildInfoRow(
                'Merchant',
                transactionInfo.transaction.merchant ?? 'N/A',
              ),
              _buildInfoRow(
                'Reference No',
                transactionInfo.transaction.referenceNo ?? 'N/A',
              ),
              const Divider(),
              const Text(
                'Account Info',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildInfoRow(
                'Type',
                transactionInfo.account.type?.name ?? 'N/A',
              ),
              _buildInfoRow('Number', transactionInfo.account.number ?? 'N/A'),
              _buildInfoRow(
                'Bank Name',
                transactionInfo.account.bankName ?? 'N/A',
              ),
              if (transactionInfo.balance != null) ...[
                const Divider(),
                const Text(
                  'Balance Info',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildInfoRow(
                  'Available',
                  transactionInfo.balance?.available ?? 'N/A',
                ),
                _buildInfoRow(
                  'Outstanding',
                  transactionInfo.balance?.outstanding ?? 'N/A',
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SMS Parser Test')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test SMS Parser',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 2.h),
            Text(
              'Enter a banking SMS or select a sample below:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 3.h),

            // SMS Input
            CustomTextField(
              label: 'SMS Message',
              hint: 'Paste your banking SMS here',
              controller: _smsController,
              maxLines: 5,
            ),

            SizedBox(height: 3.h),

            // Parse Button
            CustomButton(
              text: 'Parse SMS',
              icon: Icons.analytics,
              onPressed: _testParseSms,
            ),

            SizedBox(height: 4.h),

            // Sample SMS Section
            Text(
              'Sample SMS Messages',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),

            ...sampleSMS.asMap().entries.map((entry) {
              final index = entry.key;
              final sms = entry.value;
              return Card(
                margin: EdgeInsets.only(bottom: 2.h),
                child: ListTile(
                  title: Text(
                    'Sample ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      sms,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      _smsController.text = sms;
                      Get.snackbar('Success', 'Sample SMS copied to input');
                    },
                  ),
                ),
              );
            }),

            SizedBox(height: 3.h),

            // Info Card
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlack.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 20),
                      SizedBox(width: 2.w),
                      const Text(
                        'How it works',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '• The transaction_sms_parser package automatically extracts:\n'
                    '  - Transaction type (credit/debit)\n'
                    '  - Amount\n'
                    '  - Merchant/UPI ID\n'
                    '  - Account details\n'
                    '  - Balance information\n'
                    '  - Reference numbers\n\n'
                    '• Supports multiple banks and formats\n'
                    '• Works with card, wallet, and account transactions',
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
