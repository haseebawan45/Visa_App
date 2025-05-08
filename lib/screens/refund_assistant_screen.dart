import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visa_app/models/chat_message.dart';
import 'package:visa_app/theme/app_theme.dart';
import 'package:visa_app/widgets/futuristic_button.dart';
import 'package:visa_app/widgets/glass_container.dart';
import 'package:visa_app/widgets/neuro_card.dart';

class RefundAssistantScreen extends StatefulWidget {
  const RefundAssistantScreen({super.key});

  @override
  State<RefundAssistantScreen> createState() => _RefundAssistantScreenState();
}

class _RefundAssistantScreenState extends State<RefundAssistantScreen> {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    // Welcome message
    _addMessage(
      "Hi there! I'm your Refund Assistant. How can I help you today?",
      ChatMessageType.assistant,
    );

    // Add suggestions
    _addMessage(
      "I can help with:",
      ChatMessageType.suggestion,
      suggestions: [
        "Request a refund",
        "Track my refund status",
        "Dispute a transaction",
        "Contact merchant"
      ],
    );
  }

  void _addMessage(String text, ChatMessageType type, {List<String>? suggestions}) {
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          type: type,
          timestamp: DateTime.now(),
          suggestions: suggestions,
        ),
      );
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend() {
    if (_textController.text.trim().isEmpty) return;

    final userMessage = _textController.text;
    _addMessage(userMessage, ChatMessageType.user);
    _textController.clear();

    // Simulate assistant typing
    setState(() {
      _isTyping = true;
    });

    // Simulate response after delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      
      setState(() {
        _isTyping = false;
      });

      // Response based on user query
      if (userMessage.toLowerCase().contains('refund')) {
        _addMessage(
          "I can help you with your refund request. To start, please provide the transaction date and merchant name.",
          ChatMessageType.assistant,
        );
      } else if (userMessage.toLowerCase().contains('dispute')) {
        _addMessage(
          "To dispute a transaction, we'll need to gather some information. When did the transaction occur?",
          ChatMessageType.assistant,
        );
      } else if (userMessage.toLowerCase().contains('track')) {
        _addMessage(
          "Your refund request for Coffee Shop (₨1,250) is being processed. Estimated completion: 3-5 business days.",
          ChatMessageType.assistant,
        );
      } else {
        _addMessage(
          "I'll be happy to assist you with that. Could you provide more details about your transaction?",
          ChatMessageType.assistant,
          suggestions: [
            "It was today",
            "It was yesterday",
            "It was last week",
            "I need help with something else"
          ],
        );
      }
    });
  }

  void _handleSuggestionTap(String suggestion) {
    _addMessage(suggestion, ChatMessageType.user);

    // Simulate assistant typing
    setState(() {
      _isTyping = true;
    });

    // Simulate response after delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      
      setState(() {
        _isTyping = false;
      });

      if (suggestion == "Request a refund") {
        _addMessage(
          "I'll help you request a refund. First, let's identify the transaction. Please select or describe the transaction you want to refund:",
          ChatMessageType.assistant,
          suggestions: [
            "Coffee Shop - ₨1,250",
            "Online Store - ₨5,890",
            "Grocery Store - ₨3,450",
            "Other transaction"
          ],
        );
      } else if (suggestion == "Track my refund status") {
        _addMessage(
          "I can check the status of your refunds. Here are your recent refund requests:",
          ChatMessageType.assistant,
        );
        
        Future.delayed(const Duration(milliseconds: 500), () {
          _addMessage(
            "• Coffee Shop (₨1,250) - In Progress\nEstimated completion: 3-5 business days\n\n• Online Store (₨5,890) - Completed\nRefunded on: June 8, 2023\n\nWould you like more details on either of these?",
            ChatMessageType.assistant,
            suggestions: [
              "Details on Coffee Shop refund",
              "Details on Online Store refund",
              "I have another question"
            ],
          );
        });
      } else if (suggestion == "Dispute a transaction") {
        _addMessage(
          "Let's start a transaction dispute. This is a formal process to contest a charge. Here's how it works:",
          ChatMessageType.assistant,
        );
        
        Future.delayed(const Duration(milliseconds: 500), () {
          _addMessage(
            "1. We'll gather information about the disputed transaction\n2. We'll submit the dispute to the merchant\n3. The merchant has 7-10 days to respond\n4. We'll keep you updated on the progress\n\nReady to proceed?",
            ChatMessageType.assistant,
            suggestions: [
              "Yes, let's proceed",
              "What information is needed?",
              "How long will this take?"
            ],
          );
        });
      } else if (suggestion == "Contact merchant") {
        _addMessage(
          "I can help you contact the merchant directly. Which merchant would you like to contact?",
          ChatMessageType.assistant,
          suggestions: [
            "Coffee Shop",
            "Online Store",
            "Grocery Store",
            "Other merchant"
          ],
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.backgroundDarker,
                  AppTheme.background,
                  Color(0xFF141728),
                ],
              ),
            ),
          ),
          
          // Decorative elements
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentNeon.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: NeuroCard(
                          width: 45,
                          height: 45,
                          borderRadius: AppTheme.radiusRounded,
                          depth: 3,
                          padding: const EdgeInsets.all(0),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Refund Assistant',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'AI-powered support',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      NeuroCard(
                        width: 45,
                        height: 45,
                        borderRadius: AppTheme.radiusRounded,
                        depth: 3,
                        padding: const EdgeInsets.all(0),
                        onTap: () {},
                        child: Icon(
                          Icons.more_vert_rounded,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Chat messages
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(
                      left: AppTheme.spacingM,
                      right: AppTheme.spacingM,
                      bottom: AppTheme.spacingL,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message, index);
                    },
                  ),
                ),
                
                // Typing indicator
                if (_isTyping)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppTheme.spacingM,
                      bottom: AppTheme.spacingM,
                    ),
                    child: Row(
                      children: [
                        GlassContainer(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingM,
                            vertical: AppTheme.spacingS,
                          ),
                          borderRadius: 20,
                          opacity: 0.1,
                          color: AppTheme.accentNeon,
                          child: Row(
                            children: [
                              _buildDot(delay: 0),
                              _buildDot(delay: 300),
                              _buildDot(delay: 600),
                            ],
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slide(begin: const Offset(0, 0.5), end: Offset.zero, duration: 300.ms),
                  ),
                
                // Input field
                GlassContainer(
                  margin: const EdgeInsets.all(AppTheme.spacingM),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingS,
                  ),
                  borderRadius: AppTheme.radiusLarge,
                  opacity: AppTheme.glassOpacityMedium,
                  blur: AppTheme.blurLight,
                  color: AppTheme.backgroundLighter,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            hintStyle: TextStyle(
                              color: AppTheme.textMuted,
                            ),
                            border: InputBorder.none,
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _handleSend(),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      GestureDetector(
                        onTap: _handleSend,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.accentNeon,
                                AppTheme.accentNeon.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(AppTheme.radiusRounded),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accentNeon.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDot({required int delay}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: AppTheme.accentNeon,
        shape: BoxShape.circle,
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .scaleXY(
          begin: 0.6,
          end: 1.0,
          duration: 600.ms,
          delay: Duration(milliseconds: delay),
          curve: Curves.easeInOut,
        );
  }

  Widget _buildMessageBubble(ChatMessage message, int index) {
    final isUser = message.type == ChatMessageType.user;
    final isSuggestion = message.type == ChatMessageType.suggestion;
    
    // For suggestions, show them in a horizontal row
    if (isSuggestion && message.suggestions != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.text.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(
                top: AppTheme.spacingM,
                bottom: AppTheme.spacingS,
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
            child: Row(
              children: message.suggestions!.map((suggestion) {
                return Container(
                  margin: const EdgeInsets.only(right: AppTheme.spacingS),
                  child: NeuroCard(
                    onTap: () => _handleSuggestionTap(suggestion),
                    depth: 3,
                    child: Text(
                      suggestion,
                      style: TextStyle(
                        color: AppTheme.primaryNeon,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
              .animate()
              .fadeIn(
                delay: 300.ms,
                duration: 400.ms,
              )
              .slide(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
                delay: 300.ms,
                duration: 400.ms,
              ),
        ],
      )
          .animate()
          .fadeIn(duration: 400.ms)
          .slide(begin: const Offset(0, 0.3), end: Offset.zero, duration: 400.ms);
    }
    
    // For regular messages (user or assistant)
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: EdgeInsets.only(
            top: AppTheme.spacingM,
            bottom: message.suggestions != null ? 0 : AppTheme.spacingXS,
          ),
          child: isUser
              ? NeuroCard(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  borderRadius: 20,
                  depth: 3,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryNeon.withOpacity(0.6),
                      AppTheme.primaryNeon.withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                )
              : GlassContainer(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  borderRadius: 20,
                  opacity: AppTheme.glassOpacityMedium,
                  blur: AppTheme.blurLight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                      
                      if (message.suggestions != null) ...[
                        const SizedBox(height: AppTheme.spacingM),
                        
                        Wrap(
                          spacing: AppTheme.spacingS,
                          runSpacing: AppTheme.spacingS,
                          children: message.suggestions!.map((suggestion) {
                            return InkWell(
                              onTap: () => _handleSuggestionTap(suggestion),
                              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingM,
                                  vertical: AppTheme.spacingS,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentNeon.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                  border: Border.all(
                                    color: AppTheme.accentNeon.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  suggestion,
                                  style: TextStyle(
                                    color: AppTheme.accentNeon,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                            .animate()
                            .fadeIn(
                              delay: 500.ms,
                              duration: 400.ms,
                            )
                            .slide(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                              delay: 500.ms,
                              duration: 400.ms,
                            ),
                      ],
                    ],
                  ),
                ),
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms)
          .slide(
            begin: Offset(isUser ? 0.3 : -0.3, 0),
            end: Offset.zero,
            duration: 400.ms,
          ),
    );
  }
} 