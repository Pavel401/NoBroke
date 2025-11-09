import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/chat_service.dart';
import '../controllers/chat_controller.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:network_inspector/network_inspector.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Chat'),
        actions: [
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.wifi_tethering),
              tooltip: 'Network Inspector',
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ActivityPage()),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showSettingsDialog(context, controller),
            tooltip: 'Settings',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showClearChatDialog(context, controller),
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Error message banner
          Obx(() {
            if (controller.errorMessage.value.isNotEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: AppTheme.errorRed.withOpacity(0.1),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppTheme.errorRed,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(
                          color: AppTheme.errorRed,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      color: AppTheme.errorRed,
                      onPressed: () => controller.errorMessage.value = '',
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Data sharing info banner
          Obx(() {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlack.withOpacity(0.05),
                border: Border(
                  bottom: BorderSide(color: AppTheme.greyMedium, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryBlack.withOpacity(0.6),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sharing: ${controller.transactionDays.value}d transactions, ${controller.budgetMonths.value}mo budgets',
                      style: TextStyle(
                        color: AppTheme.primaryBlack.withOpacity(0.7),
                        fontSize: 11,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _showSettingsDialog(context, controller),
                    child: Text(
                      'Configure',
                      style: TextStyle(
                        color: AppTheme.primaryBlack,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Chat messages
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryBlack,
                  ),
                );
              }

              if (controller.messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: AppTheme.greyDark.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Start a conversation',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.greyDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Ask about your finances, transactions, budgets, and more',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.greyDark.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return _ChatMessageBubble(message: message);
                },
              );
            }),
          ),

          // Input area
          _ChatInputArea(controller: controller),
        ],
      ),
    );
  }

  void _showClearChatDialog(BuildContext context, ChatController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text(
          'Are you sure you want to clear all chat messages? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.clearChat();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, ChatController controller) {
    final baseUrlController = TextEditingController();
    final isValidating = false.obs;
    final validationMessage = ''.obs;

    // Load current base URL
    ChatService.getBaseUrl().then((url) {
      baseUrlController.text = url;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chat Settings'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Backend URL Section
              const Text(
                'Backend URL',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text(
                'Configure the Finance Bro Agent backend URL:',
                style: TextStyle(fontSize: 12, color: AppTheme.greyDark),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: baseUrlController,
                decoration: InputDecoration(
                  hintText: 'https://your-backend-url.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => isValidating.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : TextButton.icon(
                            onPressed: () async {
                              final url = baseUrlController.text.trim();
                              if (url.isEmpty) {
                                validationMessage.value = 'URL cannot be empty';
                                return;
                              }

                              isValidating.value = true;
                              validationMessage.value = 'Validating...';

                              final isValid = await ChatService.validateUrl(
                                url,
                              );
                              isValidating.value = false;

                              if (isValid) {
                                await ChatService.setBaseUrl(url);
                                validationMessage.value = '✓ Valid & saved';
                              } else {
                                validationMessage.value = '✗ Cannot reach URL';
                              }
                            },
                            icon: const Icon(
                              Icons.check_circle_outline,
                              size: 16,
                            ),
                            label: const Text('Test & Save'),
                          ),
                  ),
                ],
              ),
              Obx(
                () => validationMessage.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          validationMessage.value,
                          style: TextStyle(
                            fontSize: 11,
                            color: validationMessage.value.contains('✓')
                                ? Colors.green
                                : validationMessage.value.contains('✗')
                                ? AppTheme.errorRed
                                : AppTheme.greyDark,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final url = Uri.parse(
                    'https://github.com/Pavel401/Your-Finance-Bro--Agent',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: const Text(
                  '📚 Backend Repository: Your-Finance-Bro--Agent',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.primaryBlue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // History Limit Section
              const Text(
                'History Limit',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text(
                'Number of messages to send as context to the AI:',
                style: TextStyle(fontSize: 12, color: AppTheme.greyDark),
              ),
              const SizedBox(height: 16),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: controller.historyLimit.value.toDouble(),
                        min: 2,
                        max: 20,
                        divisions: 18,
                        label: controller.historyLimit.value.toString(),
                        activeColor: AppTheme.primaryBlack,
                        onChanged: (value) {
                          controller.historyLimit.value = value.toInt();
                        },
                      ),
                    ),
                    Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Text(
                        '${controller.historyLimit.value}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Data Sharing Preferences Section
              const Text(
                'Data Sharing Preferences',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text(
                'Configure how much data to share with the AI:',
                style: TextStyle(fontSize: 12, color: AppTheme.greyDark),
              ),
              const SizedBox(height: 16),

              // Transaction Days
              const Text(
                'Transaction History',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              // Quick presets for transactions
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildPresetChip(
                      controller,
                      '7 days',
                      () => controller.transactionDays.value = 7,
                      controller.transactionDays.value == 7,
                    ),
                    _buildPresetChip(
                      controller,
                      '30 days',
                      () => controller.transactionDays.value = 30,
                      controller.transactionDays.value == 30,
                    ),
                    _buildPresetChip(
                      controller,
                      '90 days',
                      () => controller.transactionDays.value = 90,
                      controller.transactionDays.value == 90,
                    ),
                    _buildPresetChip(
                      controller,
                      '180 days',
                      () => controller.transactionDays.value = 180,
                      controller.transactionDays.value == 180,
                    ),
                    _buildPresetChip(
                      controller,
                      '1 year',
                      () => controller.transactionDays.value = 365,
                      controller.transactionDays.value == 365,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Quick presets for budgets
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildPresetChip(
                      controller,
                      '3 months',
                      () => controller.budgetMonths.value = 3,
                      controller.budgetMonths.value == 3,
                    ),
                    _buildPresetChip(
                      controller,
                      '6 months',
                      () => controller.budgetMonths.value = 6,
                      controller.budgetMonths.value == 6,
                    ),
                    _buildPresetChip(
                      controller,
                      '1 year',
                      () => controller.budgetMonths.value = 12,
                      controller.budgetMonths.value == 12,
                    ),
                    _buildPresetChip(
                      controller,
                      '2 years',
                      () => controller.budgetMonths.value = 24,
                      controller.budgetMonths.value == 24,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Slider(
                            value: controller.transactionDays.value.toDouble(),
                            min: 7,
                            max: 365,
                            divisions: 51, // 7, 14, 30, 60, 90, 180, 365
                            label: '${controller.transactionDays.value} days',
                            activeColor: AppTheme.primaryBlack,
                            onChanged: (value) {
                              controller.transactionDays.value = value.toInt();
                            },
                          ),
                          Text(
                            'Last ${controller.transactionDays.value} days',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.greyDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Budget Months
              const Text(
                'Budget History',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Slider(
                            value: controller.budgetMonths.value.toDouble(),
                            min: 1,
                            max: 36,
                            divisions: 35,
                            label: '${controller.budgetMonths.value} months',
                            activeColor: AppTheme.primaryBlack,
                            onChanged: (value) {
                              controller.budgetMonths.value = value.toInt();
                            },
                          ),
                          Text(
                            'Last ${controller.budgetMonths.value} ${controller.budgetMonths.value == 1 ? "month" : "months"}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.greyDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // User History Section
              const Text(
                'User History',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showDeleteUserHistoryDialog(context, controller);
                  },
                  icon: const Icon(Icons.person_remove_outlined, size: 18),
                  label: const Text('Delete User Messages'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.errorRed,
                    side: const BorderSide(color: AppTheme.errorRed),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Persist history limit and data sharing preferences
              controller.updateHistoryLimit(controller.historyLimit.value);
              controller.updateDataPreferences(
                controller.transactionDays.value,
                controller.budgetMonths.value,
              );

              // Also persist backend URL if provided (basic validation)
              final rawUrl = baseUrlController.text.trim();
              if (rawUrl.isNotEmpty) {
                final hasProtocol =
                    rawUrl.startsWith('http://') ||
                    rawUrl.startsWith('https://');
                if (hasProtocol) {
                  await ChatService.setBaseUrl(rawUrl);
                }
              }

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings saved'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(
    ChatController controller,
    String label,
    VoidCallback onTap,
    bool isSelected,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlack : AppTheme.greyLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlack : AppTheme.greyMedium,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? AppTheme.primaryWhite : AppTheme.primaryBlack,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showDeleteUserHistoryDialog(
    BuildContext context,
    ChatController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User Messages'),
        content: const Text(
          'This will delete all your messages from the chat history, keeping only the assistant responses. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteUserHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User messages deleted'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatMessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[_buildAvatar(false), const SizedBox(width: 8)],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? AppTheme.primaryBlack : AppTheme.greyLight,
                    borderRadius: BorderRadius.circular(12),
                    border: isUser
                        ? null
                        : Border.all(color: AppTheme.greyMedium, width: 1),
                  ),
                  child: message.content.isEmpty
                      ? _buildTypingIndicator()
                      : isUser
                      ? Text(
                          message.content,
                          style: TextStyle(
                            color: AppTheme.primaryWhite,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        )
                      : MarkdownBody(
                          data: message.content,
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(
                              color: AppTheme.primaryBlack,
                              fontSize: 14,
                              height: 1.4,
                            ),
                            code: TextStyle(
                              backgroundColor: AppTheme.greyMedium,
                              color: AppTheme.primaryBlack,
                              fontSize: 13,
                            ),
                            codeblockDecoration: BoxDecoration(
                              color: AppTheme.greyMedium,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            blockquote: TextStyle(
                              color: AppTheme.greyDark,
                              fontSize: 14,
                            ),
                            h1: const TextStyle(
                              color: AppTheme.primaryBlack,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            h2: const TextStyle(
                              color: AppTheme.primaryBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            h3: const TextStyle(
                              color: AppTheme.primaryBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            listBullet: const TextStyle(
                              color: AppTheme.primaryBlack,
                              fontSize: 14,
                            ),
                            a: const TextStyle(
                              color: AppTheme.primaryBlue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onTapLink: (text, href, title) async {
                            if (href != null) {
                              final url = Uri.parse(href);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            }
                          },
                        ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(message.timestamp),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.greyDark.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          if (isUser) ...[const SizedBox(width: 8), _buildAvatar(true)],
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isUser ? AppTheme.primaryBlack : AppTheme.greyLight,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.greyMedium, width: 1),
      ),
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        size: 18,
        color: isUser ? AppTheme.primaryWhite : AppTheme.primaryBlack,
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TypingDot(delay: 0),
        const SizedBox(width: 4),
        _TypingDot(delay: 200),
        const SizedBox(width: 4),
        _TypingDot(delay: 400),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return DateFormat('h:mm a').format(timestamp);
    } else {
      return DateFormat('MMM d, h:mm a').format(timestamp);
    }
  }
}

class _ChatInputArea extends StatelessWidget {
  final ChatController controller;

  const _ChatInputArea({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        border: Border(top: BorderSide(color: AppTheme.greyMedium, width: 1)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              decoration: InputDecoration(
                hintText: 'Ask about your finances...',
                hintStyle: TextStyle(
                  color: AppTheme.greyDark.withOpacity(0.7),
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppTheme.greyMedium),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppTheme.greyMedium),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: AppTheme.primaryBlack,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: true,
                fillColor: AppTheme.greyLight,
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  controller.sendMessage(value);
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Obx(() {
            return Container(
              decoration: BoxDecoration(
                color: controller.isSending.value
                    ? AppTheme.greyMedium
                    : AppTheme.primaryBlack,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: controller.isSending.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryWhite,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send, size: 20),
                color: AppTheme.primaryWhite,
                onPressed: controller.isSending.value
                    ? null
                    : () {
                        final message = controller.messageController.text;
                        if (message.trim().isNotEmpty) {
                          controller.sendMessage(message);
                        }
                      },
              ),
            );
          }),
        ],
      ),
    );
  }
}

// Typing indicator dot widget
class _TypingDot extends StatefulWidget {
  final int delay;

  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: AppTheme.greyDark,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
