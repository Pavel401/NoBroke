import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controllers/account_controller.dart';
import '../../domain/entities/bank_account_entity.dart';
import '../../core/theme/app_theme.dart';

class AddAccountScreen extends StatefulWidget {
  final BankAccountEntity? account;

  const AddAccountScreen({super.key, this.account});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _balanceController = TextEditingController();
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      _nameController.text = widget.account!.accountName;
      _accountNumberController.text = widget.account!.accountNumber;
      _bankNameController.text = widget.account!.bankName;
      _balanceController.text = widget.account!.balance.toString();
      _isDefault = widget.account!.isActive; // Using isActive as isDefault
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AccountController controller = Get.find<AccountController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.account == null ? 'Add Account' : 'Edit Account'),
        backgroundColor: AppTheme.primaryWhite,
        foregroundColor: AppTheme.primaryBlack,
        elevation: 0,
      ),
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Name
                    Text(
                      'Account Name',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Main Savings, Salary Account',
                        prefixIcon: Icon(
                          Icons.account_circle,
                          color: AppTheme.primaryBlack,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an account name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 3.h),

                    // Account Number
                    Text(
                      'Account Number',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _accountNumberController,
                      decoration: const InputDecoration(
                        hintText: 'Enter account number',
                        prefixIcon: Icon(
                          Icons.credit_card,
                          color: AppTheme.primaryBlack,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter account number';
                        }
                        if (value.length < 8) {
                          return 'Account number must be at least 8 digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 3.h),

                    // Bank Name
                    Text(
                      'Bank Name',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _bankNameController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., State Bank of India, HDFC Bank',
                        prefixIcon: Icon(
                          Icons.account_balance,
                          color: AppTheme.primaryBlack,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter bank name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 3.h),

                    // Balance
                    Text(
                      'Current Balance',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _balanceController,
                      decoration: const InputDecoration(
                        hintText: '0.00',
                        prefixIcon: Icon(
                          Icons.currency_rupee,
                          color: AppTheme.primaryBlack,
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter current balance';
                        }
                        final balance = double.tryParse(value);
                        if (balance == null) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 3.h),

                    // Default Account Toggle
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.greyLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.greyMedium),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: _isDefault
                                ? AppTheme.primaryBlack
                                : AppTheme.greyDark,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Set as Default Account',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  'This will be your primary account for transactions',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: AppTheme.greyDark),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isDefault,
                            onChanged: (value) {
                              setState(() {
                                _isDefault = value;
                              });
                            },
                            activeThumbColor: AppTheme.primaryBlack,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading ? null : _saveAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlack,
                          foregroundColor: AppTheme.primaryWhite,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AppTheme.primaryWhite,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                widget.account == null
                                    ? 'Add Account'
                                    : 'Update Account',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppTheme.primaryWhite,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAccount() {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<AccountController>();

      final name = _nameController.text.trim();
      final accountNumber = _accountNumberController.text.trim();
      final bankName = _bankNameController.text.trim();
      final balance = double.parse(_balanceController.text.trim());

      if (widget.account == null) {
        // Add new account
        controller.addAccount(
          name: name,
          accountNumber: accountNumber,
          bankName: bankName,
          balance: balance,
          isDefault: _isDefault,
        );
      } else {
        // Update existing account
        final updatedAccount = widget.account!.copyWith(
          accountName: name,
          accountNumber: accountNumber,
          bankName: bankName,
          balance: balance,
          isActive: _isDefault, // Using isActive as isDefault
          updatedAt: DateTime.now(),
        );
        controller.updateAccount(updatedAccount);
      }
    }
  }
}
