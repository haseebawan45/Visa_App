import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visa_app/models/chat_message.dart';
import 'package:visa_app/theme/app_theme.dart';
import 'package:visa_app/widgets/futuristic_button.dart';
import 'package:visa_app/widgets/glass_container.dart';
import 'package:visa_app/widgets/neuro_card.dart';
import 'package:visa_app/utils/ai_response_templates.dart';
import 'dart:math' as math;

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
  
  // Add a context map to keep track of conversation state
  final Map<String, dynamic> _conversationContext = {};

  @override
  void initState() {
    super.initState();
    _initializeChat();
    
    // Schedule proactive suggestions after a delay
    Future.delayed(const Duration(seconds: 10), () {
      _offerProactiveSuggestion();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    // Use templates for welcome message
    final welcomeTemplate = AIResponseTemplates.refundTemplates['welcome'];
    _addMessageFromTemplate(welcomeTemplate);

    // Add suggestions with improved categorization
    final optionsTemplate = AIResponseTemplates.refundTemplates['main_options'];
    _addMessageFromTemplate(optionsTemplate);
    
    // Initialize conversation context
    _conversationContext["stage"] = "welcome";
    _conversationContext["user_intent"] = null;
    _conversationContext["selected_transaction"] = null;
  }

  void _addMessageFromTemplate(Map<String, dynamic> template) {
    final message = AIResponseTemplates.createFromTemplate(template, _conversationContext);
    
    setState(() {
      _messages.add(message);
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

  void _addMessage(String text, ChatMessageType type, 
      {List<String>? suggestions, Map<String, dynamic>? data, List<ChatAction>? actions}) {
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          type: type,
          timestamp: DateTime.now(),
          suggestions: suggestions,
          data: data,
          actions: actions,
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

    // Process input based on conversation context
    _processUserInput(userMessage);
  }

  void _processUserInput(String userMessage) {
    // Simulate response after delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      
      setState(() {
        _isTyping = false;
      });

      // Get current conversation stage
      final stage = _conversationContext["stage"];
      
      // Analyze message for intent
      String detectedIntent = _detectIntent(userMessage.toLowerCase());
      
      // Update conversation context with detected intent if we don't have one
      if (_conversationContext["user_intent"] == null && detectedIntent != "unknown") {
        _conversationContext["user_intent"] = detectedIntent;
      }
      
      // Track conversation history
      if (!_conversationContext.containsKey("history")) {
        _conversationContext["history"] = <String>[];
      }
      (_conversationContext["history"] as List<String>).add(userMessage);
      
      // Check for interruption pattern - user wants to do something else
      if (_isInterruptionRequest(userMessage) && stage != "welcome") {
        _handleInterruption(userMessage);
        return;
      }
      
      // Handle based on current stage and intent
      if (stage == "welcome") {
        if (detectedIntent == "greeting") {
          _handleGreeting();
        } else {
          _handleWelcomeStageResponse(userMessage, detectedIntent);
        }
      } else if (stage == "refund_request") {
        _handleRefundRequestResponse(userMessage);
      } else if (stage == "transaction_selection") {
        _handleTransactionSelectionResponse(userMessage);
      } else if (stage == "refund_reason") {
        _handleRefundReasonResponse(userMessage);
      } else if (stage == "dispute") {
        _handleDisputeResponse(userMessage);
      } else {
        // Fallback response for unknown stage
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
        _conversationContext["stage"] = "welcome";
      }
    });
  }

  bool _isInterruptionRequest(String message) {
    // Detect if the user is trying to change topics or start over
    List<String> interruptionPhrases = [
      'start over', 'cancel', 'stop', 'go back', 'something else',
      'different', 'change topic', 'nevermind', 'never mind'
    ];
    
    for (String phrase in interruptionPhrases) {
      if (message.toLowerCase().contains(phrase)) {
        return true;
      }
    }
    
    return false;
  }

  void _handleInterruption(String message) {
    // First acknowledge the interruption
        _addMessage(
      "I understand you want to switch topics. What would you like to do instead?",
          ChatMessageType.assistant,
      suggestions: [
        "Request a refund",
        "Track my refund status",
        "Dispute a transaction",
        "Contact merchant",
        "Start over"
      ],
    );
    
    // Reset the conversation context but keep user data
    var savedData = <String, dynamic>{};
    if (_conversationContext.containsKey("user_name")) {
      savedData["user_name"] = _conversationContext["user_name"];
    }
    if (_conversationContext.containsKey("history")) {
      savedData["history"] = _conversationContext["history"];
    }
    
    _conversationContext.clear();
    _conversationContext.addAll(savedData);
    _conversationContext["stage"] = "welcome";
    _conversationContext["user_intent"] = null;
  }

  void _handleGreeting() {
    // Check if this is the first interaction
    bool isFirstInteraction = !_conversationContext.containsKey("greeting_count");
    
    if (isFirstInteraction) {
      _conversationContext["greeting_count"] = 1;
        _addMessage(
        "Hello! It's nice to meet you. I'm your Refund Assistant. How can I help you today?",
          ChatMessageType.assistant,
        suggestions: [
          "Request a refund",
          "Track my refund status",
          "Dispute a transaction",
          "Contact merchant"
        ],
        );
      } else {
      // Increment greeting count
      _conversationContext["greeting_count"] = (_conversationContext["greeting_count"] as int) + 1;
      
      if ((_conversationContext["greeting_count"] as int) > 2) {
        // User has greeted multiple times, might be confused
        _addMessage(
          "Hi there! It seems we're having a bit of a loop with greetings. What can I actually help you with today?",
          ChatMessageType.assistant,
          suggestions: [
            "Request a refund",
            "Track my refund status",
            "Dispute a transaction",
            "Contact merchant",
            "I'm just testing"
          ],
        );
      } else {
        _addMessage(
          "Hello again! What can I help you with?",
          ChatMessageType.assistant,
          suggestions: [
            "Request a refund",
            "Track my refund status",
            "Dispute a transaction",
            "Contact merchant"
          ],
        );
      }
    }
  }

  void _handleWelcomeStageResponse(String userMessage, String intent) {
    // Check if we found any extracted entities to personalize the response
    String extractedMerchant = _conversationContext["extracted_merchant"] as String? ?? "";
    String extractedAmount = _conversationContext["extracted_amount"] as String? ?? "";
    String extractedDate = _conversationContext["extracted_date"] as String? ?? "";
    
    // If we have extracted information and intent is refund, use it to personalize the response
    if (intent == "refund" && (extractedMerchant.isNotEmpty || extractedAmount.isNotEmpty)) {
      String personalizedResponse = "I understand you want to request a refund";
      
      if (extractedMerchant.isNotEmpty) {
        personalizedResponse += " for a purchase from $extractedMerchant";
      }
      
      if (extractedAmount.isNotEmpty) {
        personalizedResponse += " for ₨$extractedAmount";
      }
      
      if (extractedDate.isNotEmpty) {
        personalizedResponse += " made on $extractedDate";
      }
      
      personalizedResponse += ". I'll help you with that.";
      
      _addMessage(
        personalizedResponse,
        ChatMessageType.assistant,
      );
      
      // Pre-fill the transaction information
      if (extractedMerchant.isNotEmpty) {
        _conversationContext["selected_transaction"] = extractedMerchant + 
            (extractedAmount.isNotEmpty ? " - ₨$extractedAmount" : "");
        
        // Move directly to reason selection
        Future.delayed(const Duration(milliseconds: 800), () {
          _addMessageFromTemplate(AIResponseTemplates.refundTemplates['refund_reason']);
          _conversationContext["stage"] = "refund_reason";
        });
        return;
      }
    }
    
    // For any sentiment-aware response
    double sentiment = _conversationContext["sentiment"] as double? ?? 0.0;
    bool isNegativeSentiment = sentiment < -0.3;
    
    if (isNegativeSentiment) {
      _addMessage(
        "I'm sorry to hear you're having trouble. I'll do my best to help resolve this for you quickly.",
        ChatMessageType.assistant,
      );
      
      Future.delayed(const Duration(milliseconds: 800), () {
        if (intent == "refund") {
          _startRefundFlow();
        } else if (intent == "dispute") {
          _startDisputeFlow();
        } else if (intent == "track") {
          _showRefundStatus();
        } else if (intent == "contact") {
          _showMerchantContactOptions();
        } else {
          _addMessage(
            "Could you please let me know what specific help you need? I can assist with refunds, disputes, tracking status, or contacting merchants.",
            ChatMessageType.assistant,
            suggestions: [
              "Request a refund",
              "Track my refund status",
              "Dispute a transaction",
              "Contact merchant"
            ],
          );
        }
      });
      return;
    }
    
    // Default handling based on intent
    if (intent == "refund") {
      _startRefundFlow();
    } else if (intent == "dispute") {
      _startDisputeFlow();
    } else if (intent == "track") {
      _showRefundStatus();
    } else if (intent == "contact") {
      _showMerchantContactOptions();
    } else if (intent == "help") {
      _showHelpOptions();
    } else {
        _addMessage(
        "I'll be happy to assist you with that. What would you like to do?",
          ChatMessageType.assistant,
          suggestions: [
          "Request a refund",
          "Track my refund status",
          "Dispute a transaction",
          "Contact merchant"
        ],
      );
    }
  }

  void _showHelpOptions() {
        _addMessage(
      "I'm here to help! Here are the main things I can assist you with:",
          ChatMessageType.assistant,
        );
        
        Future.delayed(const Duration(milliseconds: 500), () {
          _addMessage(
        "• Request a refund for a purchase\n• Track the status of existing refunds\n• Dispute a transaction you don't recognize\n• Get contact information for merchants\n\nWhat would you like help with today?",
            ChatMessageType.assistant,
            suggestions: [
          "Request a refund",
          "Track my refund status",
          "Dispute a transaction",
          "Contact merchant",
          "How does the refund process work?"
        ],
        actions: [
          ChatAction(
            label: "View tutorial",
            actionType: "view_tutorial",
            parameters: {"topic": "refunds"},
          ),
            ],
          );
        });
  }

  // Additional method for handling tutorial requests
  void _showTutorial(String topic) {
    if (topic == "refunds") {
        _addMessage(
        "Refund Process Tutorial",
          ChatMessageType.assistant,
        );
        
        Future.delayed(const Duration(milliseconds: 500), () {
          _addMessage(
          "The refund process works in 4 simple steps:\n\n1️⃣ Request: You provide transaction details and reason\n2️⃣ Submission: We send the request to the merchant\n3️⃣ Processing: The merchant reviews your request (typically 3-5 business days)\n4️⃣ Resolution: Approved refunds are credited back to your original payment method\n\nWould you like to start a refund request now?",
            ChatMessageType.assistant,
            suggestions: [
            "Yes, request a refund",
            "No, maybe later",
            "Show me another tutorial"
            ],
          );
        });
    } else if (topic == "disputes") {
      // Add dispute tutorial content...
    }
  }

  String _detectIntent(String message) {
    // More sophisticated intent detection with confidence scores
    Map<String, double> intentScores = {
      "refund": 0.0,
      "dispute": 0.0,
      "track": 0.0,
      "contact": 0.0,
      "cancel": 0.0,
      "help": 0.0,
      "greeting": 0.0,
      "date_selection": 0.0,
      "transaction_mention": 0.0,
    };
    
    // Check for refund intent
    if (message.contains('refund') || message.contains('money back') || 
        message.contains('return') || message.contains('get back')) {
      intentScores["refund"] = (intentScores["refund"] ?? 0.0) + 0.8;
    }
    
    // Check for dispute intent
    if (message.contains('dispute') || message.contains('contest') || 
        message.contains('challenge') || message.contains('wrong charge')) {
      intentScores["dispute"] = (intentScores["dispute"] ?? 0.0) + 0.8;
    }
    
    // Check for tracking intent
    if (message.contains('track') || message.contains('status') || 
        message.contains('where is') || message.contains('progress')) {
      intentScores["track"] = (intentScores["track"] ?? 0.0) + 0.8;
    }
    
    // Check for contact intent
    if (message.contains('contact') || message.contains('merchant') || 
        message.contains('speak') || message.contains('call') || 
        message.contains('email')) {
      intentScores["contact"] = (intentScores["contact"] ?? 0.0) + 0.7;
    }
    
    // Check for cancellation intent
    if (message.contains('cancel') || message.contains('stop') || 
        message.contains('end') || message.contains('don\'t want')) {
      intentScores["cancel"] = (intentScores["cancel"] ?? 0.0) + 0.8;
    }
    
    // Check for help intent
    if (message.contains('help') || message.contains('confused') || 
        message.contains('don\'t understand') || message.contains('how do i')) {
      intentScores["help"] = (intentScores["help"] ?? 0.0) + 0.7;
    }
    
    // Check for greeting intent
    if (message.contains('hello') || message.contains('hi ') || 
        message.contains('hey') || message.contains('greetings')) {
      intentScores["greeting"] = (intentScores["greeting"] ?? 0.0) + 0.6;
    }
    
    // Check for date selection
    if (message.contains('today') || message.contains('yesterday') || 
        message.contains('last week') || message.contains('on ')) {
      intentScores["date_selection"] = (intentScores["date_selection"] ?? 0.0) + 0.6;
    }
    
    // Check for transaction mentions
    RegExp amountPattern = RegExp(r'(?:Rs|₨|rs|\$)?\s?(\d+(?:[,.]\d+)?)');
    RegExp datePattern = RegExp(r'\d{1,2}(?:st|nd|rd|th)? (?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|January|February|March|April|May|June|July|August|September|October|November|December)|\d{1,2}[\/\-\.]\d{1,2}(?:[\/\-\.]\d{2,4})?');
    
    if (amountPattern.hasMatch(message)) {
      intentScores["transaction_mention"] = (intentScores["transaction_mention"] ?? 0.0) + 0.7;
      
      // Extract amount for future use
      final amountMatch = amountPattern.firstMatch(message);
      if (amountMatch != null) {
        _conversationContext["extracted_amount"] = amountMatch.group(1);
      }
    }
    
    if (datePattern.hasMatch(message)) {
      intentScores["date_selection"] = (intentScores["date_selection"] ?? 0.0) + 0.7;
      
      // Extract date for future use
      final dateMatch = datePattern.firstMatch(message);
      if (dateMatch != null) {
        _conversationContext["extracted_date"] = dateMatch.group(0);
      }
    }
    
    // Extract merchant name if mentioned
    List<String> knownMerchants = [
      "coffee shop", "online store", "grocery store", "restaurant", 
      "gas station", "department store", "electronics store"
    ];
    
    for (String merchant in knownMerchants) {
      if (message.toLowerCase().contains(merchant)) {
        _conversationContext["extracted_merchant"] = merchant;
        intentScores["transaction_mention"] = (intentScores["transaction_mention"] ?? 0.0) + 0.6;
        break;
      }
    }
    
    // Detect sentiment
    double sentimentScore = 0.0;
    List<String> positiveWords = ['good', 'great', 'excellent', 'thanks', 'happy', 'appreciate', 'helpful'];
    List<String> negativeWords = ['bad', 'terrible', 'unhappy', 'disappointed', 'angry', 'frustrated', 'poor'];
    
    for (String word in positiveWords) {
      if (message.toLowerCase().contains(word)) sentimentScore += 0.2;
    }
    
    for (String word in negativeWords) {
      if (message.toLowerCase().contains(word)) sentimentScore -= 0.2;
    }
    
    // Clamp sentiment between -1 and 1
    sentimentScore = math.max(-1.0, math.min(1.0, sentimentScore));
    _conversationContext["sentiment"] = sentimentScore;
    
    // Find the intent with the highest score
    String topIntent = "unknown";
    double maxScore = 0.2; // Threshold for intent detection
    
    intentScores.forEach((intent, score) {
      if (score > maxScore) {
        maxScore = score;
        topIntent = intent;
      }
    });
    
    // Store confidence for future reference
    _conversationContext["intent_confidence"] = maxScore;
    
    return topIntent;
  }

  void _startRefundFlow() {
    _addMessageFromTemplate(AIResponseTemplates.refundTemplates['refund_start']);
    _conversationContext["stage"] = "transaction_selection";
    _conversationContext["user_intent"] = "refund";
  }

  void _startDisputeFlow() {
    _addMessageFromTemplate(AIResponseTemplates.disputeTemplates['dispute_start']);
    
    Future.delayed(const Duration(milliseconds: 500), () {
      _addMessageFromTemplate(AIResponseTemplates.disputeTemplates['dispute_explanation']);
    });
    _conversationContext["stage"] = "dispute";
    _conversationContext["user_intent"] = "dispute";
  }

  void _showRefundStatus() {
    _addMessageFromTemplate(AIResponseTemplates.trackingTemplates['refund_status_intro']);
    
    Future.delayed(const Duration(milliseconds: 500), () {
      _addMessageFromTemplate(AIResponseTemplates.trackingTemplates['refund_status_details']);
    });
    _conversationContext["stage"] = "refund_status";
    _conversationContext["user_intent"] = "track";
  }

  void _showMerchantContactOptions() {
        _addMessage(
          "I can help you contact the merchant directly. Which merchant would you like to contact?",
          ChatMessageType.assistant,
          suggestions: [
            "Coffee Shop",
            "Online Store",
            "Grocery Store",
            "Other merchant"
          ],
      actions: [
        ChatAction(
          label: "View recent merchants",
          actionType: "view_merchants",
          parameters: {"limit": 5},
        ),
      ],
    );
    _conversationContext["stage"] = "merchant_contact";
    _conversationContext["user_intent"] = "contact";
  }

  void _handleRefundRequestResponse(String userMessage) {
    // Handle responses in the refund request flow
        _addMessage(
      "Great! Now, please tell me why you're requesting a refund:",
          ChatMessageType.assistant,
          suggestions: [
        "Wrong item received",
        "Item not as described",
        "Item not received",
        "Double charged",
        "Other reason"
      ],
    );
    _conversationContext["stage"] = "refund_reason";
  }

  void _handleTransactionSelectionResponse(String userMessage) {
    // Extract transaction details from the message
    _conversationContext["selected_transaction"] = userMessage;
    
    _addMessageFromTemplate(AIResponseTemplates.refundTemplates['refund_reason']);
    _conversationContext["stage"] = "refund_reason";
  }

  void _handleRefundReasonResponse(String userMessage) {
    _conversationContext["refund_reason"] = userMessage;
    
    _addMessageFromTemplate(AIResponseTemplates.refundTemplates['refund_confirmation']);
    
    Future.delayed(const Duration(milliseconds: 1000), () {
      _addMessage(
        "Is there anything else you need help with today?",
        ChatMessageType.assistant,
        suggestions: [
          "Track another refund",
          "Start a new request",
          "Contact support",
          "No, that's all"
        ],
      );
    });
    
    _conversationContext["stage"] = "welcome";
  }

  void _handleDisputeResponse(String userMessage) {
    if (userMessage.toLowerCase().contains("proceed") || 
        userMessage.toLowerCase().contains("yes")) {
      _addMessage(
        "Great! To start the dispute process, please select the transaction you want to dispute:",
        ChatMessageType.assistant,
        suggestions: [
          "Coffee Shop - ₨1,250 - Yesterday",
          "Online Store - ₨5,890 - June 5, 2023",
          "Grocery Store - ₨3,450 - June 2, 2023",
          "Other transaction"
        ],
        data: {
          "dispute_eligible_transactions": [
            {
              "merchant": "Coffee Shop",
              "amount": 1250,
              "date": "Yesterday",
              "id": "TXN12345"
            },
            {
              "merchant": "Online Store",
              "amount": 5890,
              "date": "June 5, 2023",
              "id": "TXN67890"
            },
            {
              "merchant": "Grocery Store",
              "amount": 3450,
              "date": "June 2, 2023",
              "id": "TXN24680"
            }
          ]
        },
      );
      _conversationContext["dispute_step"] = "transaction_selection";
    } else if (userMessage.toLowerCase().contains("information") || 
               userMessage.contains("what")) {
      _addMessage(
        "For a dispute, we'll need the following information:\n\n• Transaction details (date, amount, merchant)\n• Reason for dispute\n• Any communication with the merchant\n• Supporting documents (if available)\n\nReady to proceed?",
        ChatMessageType.assistant,
        suggestions: [
          "Yes, let's continue",
          "I need more time",
          "Cancel dispute"
        ],
      );
    } else if (userMessage.toLowerCase().contains("how long") || 
               userMessage.toLowerCase().contains("time")) {
      _addMessage(
        "The dispute process typically takes 7-10 business days for the merchant to respond. If they don't respond or don't resolve the issue, we'll escalate it to the card network, which may take an additional 30-45 days.\n\nWould you like to proceed?",
        ChatMessageType.assistant,
        suggestions: [
          "Yes, proceed with dispute",
          "No, try something else"
        ],
      );
    }
  }

  void _offerProactiveSuggestion() {
    // Only show proactive suggestions if:
    // 1. User is not actively typing
    // 2. The conversation has been idle for a while
    // 3. We have at least a basic conversation history
    
    if (_isTyping || !mounted) return;
    
    // Initialize history if needed
    if (!_conversationContext.containsKey("history")) {
      _conversationContext["history"] = <String>[];
    }
    
    // Only proceed if we have at least one user message
    final List<String> history = _conversationContext["history"] as List<String>? ?? <String>[];
    if (history.isEmpty) {
      return;
    }
    
    // Get the most recent user intent
    final userIntent = _conversationContext["user_intent"] as String? ?? "unknown";
    
    // Check the stage - only show proactive suggestions on welcome screen
    // or if no activity for a while (simulated here)
    final stage = _conversationContext["stage"] as String? ?? "welcome";
    
    if (stage != "welcome") return;
    
    if (userIntent == "refund" || userIntent == "unknown") {
      // Show recent transactions that might need a refund
      _addMessage(
        "I noticed you might be interested in managing refunds. Would you like to see your recent transactions?",
        ChatMessageType.assistant,
        suggestions: [
          "Yes, show recent transactions",
          "No thanks",
          "I need something else"
        ],
        actions: [
          ChatAction(
            label: "View recent transactions",
            actionType: "view_transactions",
            parameters: {"days": 7},
          ),
        ],
      );
    } else if (userIntent == "track") {
      // Suggest to check status of a pending refund
      _addMessage(
        "You have a pending refund for Coffee Shop (₨1,250). Would you like to check its status?",
        ChatMessageType.assistant,
        suggestions: [
          "Check refund status",
          "No, not now",
          "I need help with something else"
        ],
        actions: [
          ChatAction(
            label: "View refund status",
            actionType: "view_refund_status",
            parameters: {"ref_id": "REF12345"},
          ),
        ],
      );
    } else if (userIntent == "dispute") {
      // Suggest help with a suspicious transaction
      _addMessage(
        "I noticed that you're concerned about a transaction. Would you like to learn more about the dispute process?",
        ChatMessageType.assistant,
        suggestions: [
          "Yes, explain the process",
          "Start a dispute",
          "Not interested"
        ],
        actions: [
          ChatAction(
            label: "View dispute tutorial",
            actionType: "view_tutorial",
            parameters: {"topic": "disputes"},
          ),
        ],
      );
    }
    
    // Schedule the next proactive suggestion
    Future.delayed(const Duration(seconds: 60), () {
      _offerProactiveSuggestion();
    });
  }

  // Add contextual awareness to suggestion handling
  void _handleSuggestionTap(String suggestion) {
    _addMessage(suggestion, ChatMessageType.user);

    // Update conversation analysis metrics
    if (!_conversationContext.containsKey("suggestion_taps")) {
      _conversationContext["suggestion_taps"] = 0;
    }
    _conversationContext["suggestion_taps"] = (_conversationContext["suggestion_taps"] as int) + 1;
    
    // Initialize history if it doesn't exist
    if (!_conversationContext.containsKey("history")) {
      _conversationContext["history"] = <String>[];
    }
    
    // Check if user always uses suggestions instead of typing - safely access history
    final List<String> history = _conversationContext["history"] as List<String>? ?? <String>[];
    
    // Only calculate ratio if we have history
    if (history.isNotEmpty) {
      final totalMessages = history.length;
      final suggestionRatio = (_conversationContext["suggestion_taps"] as int) / totalMessages;
      
      // If user seems to prefer suggestions, offer more of them in future messages
      if (suggestionRatio > 0.8 && totalMessages > 3) {
        _conversationContext["prefers_suggestions"] = true;
      }
    }

    // Handle "Back to menu" options immediately
    if (suggestion == "Back to main menu" || 
        suggestion == "Go back to main menu" || 
        suggestion == "Return to menu") {
      _handleReturnToMainMenu();
      return;
    }

    // Simulate assistant typing
    setState(() {
      _isTyping = true;
    });

    // Process the suggestion based on current context
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      
      setState(() {
        _isTyping = false;
      });
      
      // Existing code for handling suggestions...
      final stage = _conversationContext["stage"];
      
      if (stage == "welcome") {
        if (suggestion == "Request a refund") {
          _startRefundFlow();
        } else if (suggestion == "Track my refund status") {
          _showRefundStatus();
        } else if (suggestion == "Dispute a transaction") {
          _startDisputeFlow();
        } else if (suggestion == "Contact merchant") {
          _showMerchantContactOptions();
        } else if (suggestion == "Yes, show recent transactions") {
          _showRecentTransactions();
        } else if (suggestion == "Check refund status") {
          _showRefundStatusVisual("REF12345");
        } else if (suggestion == "Yes, explain the process") {
          _showTutorial("disputes");
        }
      } else if (stage == "transaction_selection") {
        _handleTransactionSelectionResponse(suggestion);
      } else if (stage == "refund_reason") {
        _handleRefundReasonResponse(suggestion);
      } else if (stage == "dispute") {
        _handleDisputeResponse(suggestion);
      } else if (stage == "refund_status") {
        if (suggestion.contains("Details on")) {
          String merchant = suggestion.replaceAll("Details on ", "").replaceAll(" refund", "");
          _addMessage(
            "Here are the details for your $merchant refund request:\n\n" +
            "• Reference: REF" + (merchant == "Coffee Shop" ? "12345" : "67890") + "\n" +
            "• Amount: ₨" + (merchant == "Coffee Shop" ? "1,250" : "5,890") + "\n" +
            "• Requested on: " + (merchant == "Coffee Shop" ? "June 10, 2023" : "June 5, 2023") + "\n" +
            "• Status: " + (merchant == "Coffee Shop" ? "In Progress" : "Completed") + "\n" +
            "• " + (merchant == "Coffee Shop" ? "Expected completion: 3-5 business days" : "Refunded on: June 8, 2023") + "\n\n" +
            "Would you like to take any action?",
            ChatMessageType.assistant,
            suggestions: merchant == "Coffee Shop" ? [
              "Cancel request",
              "Update request details",
              "Contact support"
            ] : [
              "Dispute refund amount",
              "View confirmation",
              "Back to main menu"
            ],
          );
        } else if (suggestion == "I have another question") {
          _addMessage(
            "What would you like to know?",
            ChatMessageType.assistant,
            suggestions: [
              "Request a refund",
              "Dispute a transaction",
              "Contact merchant",
              "Something else"
            ],
          );
          _conversationContext["stage"] = "welcome";
        } else if (suggestion == "Back to main menu") {
          _handleReturnToMainMenu();
        }
      } else if (stage == "merchant_contact") {
        if (suggestion == "Other merchant") {
          _addMessage(
            "Please type the name of the merchant you wish to contact:",
            ChatMessageType.assistant,
          );
        } else if (suggestion == "Go back to main menu") {
          _handleReturnToMainMenu();
        } else {
          _addMessage(
            "Here's the contact information for $suggestion:\n\n" +
            "• Phone: " + (suggestion == "Coffee Shop" ? "+1-234-567-8910" : suggestion == "Online Store" ? "+1-800-123-4567" : "+1-987-654-3210") + "\n" +
            "• Email: " + (suggestion == "Coffee Shop" ? "support@coffeeshop.com" : suggestion == "Online Store" ? "help@onlinestore.com" : "customercare@grocerystore.com") + "\n" +
            "• Hours: Mon-Fri 9am-6pm\n\n" +
            "Would you like me to help you with anything else?",
            ChatMessageType.assistant,
            suggestions: [
              "Call merchant",
              "Email merchant",
              "Go back to main menu"
            ],
            actions: [
              ChatAction(
                label: "Add to contacts",
                actionType: "add_contact",
                parameters: {"name": suggestion, "category": "merchant"},
              ),
            ],
          );
        }
      }
    });
  }

  void _handleReturnToMainMenu() {
    // Check if we should acknowledge completed task first
    final currentStage = _conversationContext["stage"] as String? ?? "welcome";
    final previousIntent = _conversationContext["user_intent"] as String? ?? "unknown";
    
    // Provide contextual acknowledgment before returning to menu
    if (currentStage != "welcome") {
      String acknowledgment = "I'll take you back to the main menu.";
      
      // Add more context based on what they were doing before
      if (previousIntent == "refund" && currentStage == "refund_reason") {
        acknowledgment = "Your refund request has been saved. " + acknowledgment;
      } else if (previousIntent == "dispute") {
        acknowledgment = "I've noted your dispute information. " + acknowledgment;
      } else if (previousIntent == "track") {
        acknowledgment = "Let me know if you need more details about your refunds later. " + acknowledgment;
      } else if (previousIntent == "contact") {
        acknowledgment = "I hope the contact information was helpful. " + acknowledgment;
      }
      
      // Send the acknowledgment message
      _addMessage(
        acknowledgment,
        ChatMessageType.assistant,
      );
    }
    
    // Wait a moment before showing the main menu options
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      
      // Reset conversation context but keep user data and history
      var savedData = <String, dynamic>{};
      if (_conversationContext.containsKey("user_name")) {
        savedData["user_name"] = _conversationContext["user_name"];
      }
      if (_conversationContext.containsKey("history")) {
        savedData["history"] = _conversationContext["history"];
      }
      if (_conversationContext.containsKey("suggestion_taps")) {
        savedData["suggestion_taps"] = _conversationContext["suggestion_taps"];
      }
      if (_conversationContext.containsKey("prefers_suggestions")) {
        savedData["prefers_suggestions"] = _conversationContext["prefers_suggestions"];
      }
      
      _conversationContext.clear();
      _conversationContext.addAll(savedData);
      _conversationContext["stage"] = "welcome";
      
      // Show the main menu with a friendly prompt
      _addMessage(
        "What would you like to do next?",
        ChatMessageType.assistant,
        suggestions: [
          "Request a refund",
          "Track my refund status",
          "Dispute a transaction",
          "Contact merchant",
          "I'm done for now"
        ],
        actions: [
          ChatAction(
            label: "View recent transactions",
            actionType: "view_transactions",
            parameters: {"days": 7},
          ),
        ],
      );
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
    final isAction = message.type == ChatMessageType.action;
    final isStructured = message.type == ChatMessageType.structured;
    
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
          
          // Add action buttons if available
          if (message.actions != null) ...[
            const SizedBox(height: AppTheme.spacingS),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
              child: Row(
                children: message.actions!.map((action) {
                  return Container(
                    margin: const EdgeInsets.only(right: AppTheme.spacingS),
                    child: NeuroCard(
                      onTap: () => _handleActionTap(action),
                      depth: 2,
                      borderRadius: 12,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.backgroundLighter,
                          AppTheme.backgroundDarker,
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getIconForAction(action.actionType),
                            color: AppTheme.accentNeon,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            action.label,
                            style: TextStyle(
                              color: AppTheme.accentNeon,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
                .animate()
                .fadeIn(
                  delay: 500.ms,
                  duration: 400.ms,
                )
                .slide(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                  delay: 500.ms,
                  duration: 400.ms,
                ),
          ],
        ],
      )
          .animate()
          .fadeIn(duration: 400.ms)
          .slide(begin: const Offset(0, 0.3), end: Offset.zero, duration: 400.ms);
    }
    
    // For structured data messages (like transaction lists)
    if (isStructured && message.data != null) {
      return _buildStructuredMessage(message);
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
                      
                      // Add suggestions if available
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
                      
                      // Add action buttons if available
                      if (message.actions != null) ...[
                        const SizedBox(height: AppTheme.spacingM),
                        
                        Wrap(
                          spacing: AppTheme.spacingS,
                          runSpacing: AppTheme.spacingS,
                          children: message.actions!.map((action) {
                            return InkWell(
                              onTap: () => _handleActionTap(action),
                              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingM,
                                  vertical: AppTheme.spacingS,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryNeon.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                                  border: Border.all(
                                    color: AppTheme.primaryNeon.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getIconForAction(action.actionType),
                                      color: AppTheme.primaryNeon,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      action.label,
                                      style: TextStyle(
                                        color: AppTheme.primaryNeon,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        )
                            .animate()
                            .fadeIn(
                              delay: 700.ms,
                              duration: 400.ms,
                            )
                            .slide(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                              delay: 700.ms,
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
  
  Widget _buildStructuredMessage(ChatMessage message) {
    // Handle different types of structured data
    if (message.data!.containsKey("refunds")) {
      return _buildRefundsList(message);
    } else if (message.data!.containsKey("dispute_eligible_transactions")) {
      return _buildTransactionsList(message);
    } else if (message.data!.containsKey("refund_status_visual")) {
      return _buildRefundStatusVisual(message.data!["refund_status_visual"]);
    }
    
    // Default fallback
    return Align(
      alignment: Alignment.centerLeft,
      child: GlassContainer(
        margin: const EdgeInsets.only(top: AppTheme.spacingM),
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
          ],
        ),
      ),
    );
  }
  
  Widget _buildRefundsList(ChatMessage message) {
    final refunds = message.data!["refunds"] as List;
    
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(
          top: AppTheme.spacingM,
          bottom: AppTheme.spacingS,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: GlassContainer(
          padding: const EdgeInsets.all(AppTheme.spacingS),
          borderRadius: 20,
          opacity: AppTheme.glassOpacityMedium,
          blur: AppTheme.blurLight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: AppTheme.spacingM,
                  top: AppTheme.spacingM,
                  right: AppTheme.spacingM,
                ),
                child: Text(
                  "Recent Refund Requests",
                  style: TextStyle(
                    color: AppTheme.accentNeon,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              // List of refunds
              ...refunds.map((refund) => NeuroCard(
                    margin: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacingXS,
                      horizontal: AppTheme.spacingS,
                    ),
                    borderRadius: 12,
                    depth: 2,
                    onTap: () => _handleRefundSelection(refund),
                    child: Row(
                      children: [
                        // Status indicator
                        Container(
                          width: 12,
                          height: 12,
                          margin: const EdgeInsets.only(right: AppTheme.spacingM),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: refund["status"] == "Completed"
                                ? Colors.green
                                : AppTheme.accentNeon,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${refund["merchant"]} - ₨${refund["amount"]}",
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                refund["status"],
                                style: TextStyle(
                                  color: refund["status"] == "Completed"
                                      ? Colors.green
                                      : AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: AppTheme.textMuted,
                          size: 20,
                        ),
                      ],
                    ),
                  )),
              if (message.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                ),
              
              // Add suggestions if available
              if (message.suggestions != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingS),
                  child: Wrap(
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
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
              ],
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms)
          .slide(begin: const Offset(-0.3, 0), end: Offset.zero, duration: 400.ms),
    );
  }
  
  Widget _buildTransactionsList(ChatMessage message) {
    final transactions = message.data!["dispute_eligible_transactions"] as List;
    
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(
          top: AppTheme.spacingM,
          bottom: AppTheme.spacingS,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: GlassContainer(
          padding: const EdgeInsets.all(AppTheme.spacingS),
          borderRadius: 20,
          opacity: AppTheme.glassOpacityMedium,
          blur: AppTheme.blurLight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: AppTheme.spacingM,
                  top: AppTheme.spacingM,
                  right: AppTheme.spacingM,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppTheme.primaryNeon,
                      size: 18,
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Text(
                      "Select Transaction to Dispute",
                      style: TextStyle(
                        color: AppTheme.primaryNeon,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              // List of transactions
              ...transactions.map((transaction) => NeuroCard(
                    margin: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacingXS,
                      horizontal: AppTheme.spacingS,
                    ),
                    borderRadius: 12,
                    depth: 2,
                    onTap: () => _handleTransactionTap(transaction),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transaction["merchant"],
                                    style: TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    transaction["date"],
                                    style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "₨${transaction["amount"]}",
                              style: TextStyle(
                                color: AppTheme.primaryNeon,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
              if (message.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                ),
              
              // Add suggestions if available
              if (message.suggestions != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingS),
                  child: Wrap(
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
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
              ],
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms)
          .slide(begin: const Offset(-0.3, 0), end: Offset.zero, duration: 400.ms),
    );
  }
  
  void _handleRefundSelection(Map<String, dynamic> refund) {
    _addMessage(
      "Here are the details for your ${refund["merchant"]} refund request:\n\n" +
      "• Reference: ${refund["id"]}\n" +
      "• Amount: ₨${refund["amount"]}\n" +
      "• Status: ${refund["status"]}\n" +
      "• " + (refund["status"] == "Completed" ? 
             "Refunded on: ${refund["refund_date"]}" : 
             "Estimated completion: ${refund["estimated_completion"]}") + "\n\n" +
      "Would you like to take any action?",
      ChatMessageType.assistant,
      suggestions: refund["status"] == "Completed" ? [
        "Dispute refund amount",
        "View confirmation",
        "Back to main menu"
      ] : [
        "Cancel request",
        "Update request details",
        "Contact support"
      ],
    );
  }
  
  void _handleTransactionTap(Map<String, dynamic> transaction) {
    _conversationContext["selected_transaction"] = transaction;
    
    _addMessage(
      "You've selected: ${transaction["merchant"]} - ₨${transaction["amount"]} - ${transaction["date"]}",
      ChatMessageType.assistant,
    );
    
    Future.delayed(const Duration(milliseconds: 500), () {
      _addMessage(
        "Please select the reason for your dispute:",
        ChatMessageType.assistant,
        suggestions: [
          "Item not received",
          "Item not as described",
          "Duplicate charge",
          "Incorrect amount",
          "Unauthorized transaction",
          "Other reason"
        ],
      );
    });
    
    _conversationContext["dispute_step"] = "reason_selection";
  }
  
  void _handleActionTap(ChatAction action) {
    // Handle different action types
    if (action.actionType == "view_transactions") {
      _showRecentTransactions();
    } else if (action.actionType == "view_refund") {
      final refId = action.parameters?["ref_id"] ?? "REF12345";
      _showRefundDetails(refId);
    } else if (action.actionType == "set_notifications") {
      _showNotificationPreferences();
    } else if (action.actionType == "view_document") {
      final docId = action.parameters?["doc_id"] ?? "general_policy";
      _showDocument(docId);
    } else if (action.actionType == "view_merchants") {
      _showRecentMerchants();
    } else if (action.actionType == "add_contact") {
      final name = action.parameters?["name"] ?? "Merchant";
      _showAddContactConfirmation(name);
    } else if (action.actionType == "view_tutorial") {
      final topic = action.parameters?["topic"] ?? "refunds";
      _showTutorial(topic);
    } else if (action.actionType == "view_refund_status") {
      final refId = action.parameters?["ref_id"] ?? "REF12345";
      _showRefundStatusVisual(refId);
    }
  }
  
  void _showRecentTransactions() {
    _addMessage(
      "Here are your recent transactions:",
      ChatMessageType.structured,
      data: {
        "dispute_eligible_transactions": [
          {
            "merchant": "Coffee Shop",
            "amount": 1250,
            "date": "Yesterday",
            "id": "TXN12345"
          },
          {
            "merchant": "Online Store",
            "amount": 5890,
            "date": "June 5, 2023",
            "id": "TXN67890"
          },
          {
            "merchant": "Grocery Store",
            "amount": 3450,
            "date": "June 2, 2023",
            "id": "TXN24680"
          },
          {
            "merchant": "Restaurant",
            "amount": 2300,
            "date": "June 1, 2023",
            "id": "TXN13579"
          }
        ]
      },
    );
  }
  
  void _showRefundDetails(String refId) {
    _addMessage(
      "Refund Details\n\n" +
      "• Reference: $refId\n" +
      "• Merchant: Coffee Shop\n" +
      "• Amount: ₨1,250\n" +
      "• Request Date: June 10, 2023\n" +
      "• Status: In Progress\n" +
      "• Expected completion: 3-5 business days\n\n" +
      "Is there anything else you'd like to know about this refund?",
      ChatMessageType.assistant,
      suggestions: [
        "Cancel request",
        "Update request details",
        "Contact support",
        "Back to main menu"
      ],
    );
  }
  
  void _showNotificationPreferences() {
    _addMessage(
      "Notification Preferences\n\n" +
      "You'll receive notifications for the following events:",
      ChatMessageType.assistant,
    );
    
    Future.delayed(const Duration(milliseconds: 500), () {
      _addMessage(
        "Choose notification preferences:",
        ChatMessageType.assistant,
        suggestions: [
          "Refund status changes",
          "Dispute updates",
          "All transaction alerts",
          "None (disable)"
        ],
      );
    });
  }
  
  void _showDocument(String docId) {
    String title = "General Policy";
    String content = "This document outlines our general policies.";
    
    if (docId == "dispute_policy") {
      title = "Dispute Policy";
      content = "Our dispute resolution policy follows these guidelines:\n\n" +
        "1. Submit your dispute with all relevant information\n" +
        "2. We'll notify the merchant within 1 business day\n" +
        "3. The merchant has 7-10 days to respond\n" +
        "4. If the merchant accepts, your account will be credited within 3-5 business days\n" +
        "5. If the merchant declines, we'll review the case and may escalate to the card network\n" +
        "6. Network resolution may take 30-45 additional days\n\n" +
        "Note: For unauthorized transactions, temporary credit may be issued during investigation.";
    }
    
    _addMessage(
      "$title\n\n$content",
      ChatMessageType.assistant,
      suggestions: [
        "I understand",
        "I have questions",
        "Back to dispute"
      ],
    );
  }
  
  void _showRecentMerchants() {
    _addMessage(
      "Your Recent Merchants:",
      ChatMessageType.assistant,
      suggestions: [
        "Coffee Shop",
        "Online Store",
        "Grocery Store",
        "Restaurant",
        "Gas Station"
      ],
    );
  }
  
  void _showAddContactConfirmation(String name) {
    _addMessage(
      "$name has been added to your saved merchants. You can access their contact information at any time from your profile.",
      ChatMessageType.assistant,
    );
  }
  
  void _showRefundStatusVisual(String refId) {
    // First, show a loading message
    _addMessage(
      "Loading status details for refund #$refId...",
      ChatMessageType.assistant,
    );
    
    // Simulate a delay to fetch status
    Future.delayed(const Duration(milliseconds: 1200), () {
      // Create a structured data representation of the refund status
      final Map<String, dynamic> refundData = {
        "refund_id": refId,
        "merchant": "Coffee Shop",
        "amount": 1250,
        "date_requested": "June 10, 2023",
        "status": "In Progress",
        "timeline": [
          {
            "stage": "Refund Requested",
            "date": "June 10, 2023",
            "completed": true,
          },
          {
            "stage": "Merchant Notified",
            "date": "June 10, 2023",
            "completed": true,
          },
          {
            "stage": "Merchant Review",
            "date": "Expected by June 15, 2023",
            "completed": false,
          },
          {
            "stage": "Refund Approved",
            "date": "Pending",
            "completed": false,
          },
          {
            "stage": "Funds Credited",
            "date": "Expected by June 17, 2023",
            "completed": false,
          }
        ]
      };
      
      _addMessage(
        "Visual Status for Refund #$refId",
        ChatMessageType.structured,
        data: {
          "refund_status_visual": refundData
        },
      );
    });
  }

  // Method to build visual refund status timeline
  Widget _buildRefundStatusVisual(Map<String, dynamic> refundData) {
    final timeline = refundData["timeline"] as List;
    
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          top: AppTheme.spacingM,
          bottom: AppTheme.spacingM,
        ),
        child: GlassContainer(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          borderRadius: 20,
          opacity: AppTheme.glassOpacityMedium,
          blur: AppTheme.blurLight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Refund header
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    color: AppTheme.accentNeon,
                    size: 22,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    "${refundData["merchant"]} - ₨${refundData["amount"]}",
                    style: TextStyle(
                      color: AppTheme.accentNeon,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              
              // Refund status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: refundData["status"] == "Completed" 
                      ? Colors.green.withOpacity(0.2)
                      : AppTheme.accentNeon.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  border: Border.all(
                    color: refundData["status"] == "Completed"
                        ? Colors.green
                        : AppTheme.accentNeon,
                  ),
                ),
                child: Text(
                  refundData["status"],
                  style: TextStyle(
                    color: refundData["status"] == "Completed"
                        ? Colors.green
                        : AppTheme.accentNeon,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              
              // Timeline visualization
              ..._buildTimelineItems(timeline),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NeuroCard(
                    onTap: () {},
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                      vertical: AppTheme.spacingS,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          color: AppTheme.primaryNeon,
                          size: 16,
                        ),
                        const SizedBox(width: AppTheme.spacingXS),
                        Text(
                          "Email updates",
                          style: TextStyle(
                            color: AppTheme.primaryNeon,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  NeuroCard(
                    onTap: () {},
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                      vertical: AppTheme.spacingS,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          color: AppTheme.accentNeon,
                          size: 16,
                        ),
                        const SizedBox(width: AppTheme.spacingXS),
                        Text(
                          "Contact support",
                          style: TextStyle(
                            color: AppTheme.accentNeon,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 500.ms)
          .slide(begin: const Offset(0, 0.2), end: Offset.zero, duration: 500.ms),
    );
  }

  List<Widget> _buildTimelineItems(List timeline) {
    List<Widget> timelineWidgets = [];
    
    for (int i = 0; i < timeline.length; i++) {
      final item = timeline[i];
      final bool isCompleted = item["completed"] as bool;
      final bool isLast = i == timeline.length - 1;
      
      // The timeline item itself
      timelineWidgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status indicator circle
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(
                right: AppTheme.spacingM,
                top: 2,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted 
                    ? Colors.green 
                    : AppTheme.backgroundLighter,
                border: Border.all(
                  color: isCompleted 
                      ? Colors.green 
                      : AppTheme.primaryNeon.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: isCompleted 
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    )
                  : null,
            ),
            
            // Timeline text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["stage"],
                    style: TextStyle(
                      color: isCompleted 
                          ? Colors.green 
                          : AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item["date"],
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).animate().fadeIn(
          delay: Duration(milliseconds: 300 * i),
          duration: 400.ms,
        ),
      );
      
      // Connecting line (except for last item)
      if (!isLast) {
        timelineWidgets.add(
          Container(
            margin: const EdgeInsets.only(left: 9),
            width: 2,
            height: 30,
            color: isCompleted 
                ? Colors.green 
                : AppTheme.primaryNeon.withOpacity(0.3),
          ).animate().fadeIn(
            delay: Duration(milliseconds: 300 * i + 200),
            duration: 400.ms,
          ),
        );
      }
    }
    
    return timelineWidgets;
  }
  
  IconData _getIconForAction(String actionType) {
    switch (actionType) {
      case "view_transactions":
        return Icons.receipt_long_rounded;
      case "view_refund":
        return Icons.assignment_rounded;
      case "set_notifications":
        return Icons.notifications_rounded;
      case "view_document":
        return Icons.description_rounded;
      case "view_merchants":
        return Icons.store_rounded;
      case "add_contact":
        return Icons.person_add_rounded;
      default:
        return Icons.arrow_forward_rounded;
    }
  }
} 