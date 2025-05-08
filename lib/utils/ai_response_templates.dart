import 'package:flutter/material.dart';
import 'package:visa_app/models/chat_message.dart';

/// A utility class that provides templates for AI responses
class AIResponseTemplates {
  /// Templates for refund flow
  static Map<String, dynamic> refundTemplates = {
    'welcome': {
      'text': "Hi there! I'm your Refund Assistant. How can I help you today?",
      'type': ChatMessageType.assistant,
    },
    
    'main_options': {
      'text': "I can help with:",
      'type': ChatMessageType.suggestion,
      'suggestions': [
        "Request a refund",
        "Track my refund status",
        "Dispute a transaction",
        "Contact merchant"
      ],
      'actions': [
        {
          'label': "Recent transactions",
          'actionType': "view_transactions",
          'parameters': {"days": 7},
        },
      ],
    },
    
    'refund_start': {
      'text': "I'll help you request a refund. First, let's identify the transaction. Please select or describe the transaction you want to refund:",
      'type': ChatMessageType.assistant,
      'suggestions': [
        "Coffee Shop - ₨1,250",
        "Online Store - ₨5,890",
        "Grocery Store - ₨3,450",
        "Other transaction"
      ],
    },
    
    'refund_reason': {
      'text': "You've selected: {{selected_transaction}}. Now, please tell me why you're requesting a refund:",
      'type': ChatMessageType.assistant,
      'suggestions': [
        "Wrong item received",
        "Item not as described",
        "Item not received",
        "Double charged",
        "Other reason"
      ],
    },
    
    'refund_confirmation': {
      'text': "Thank you for providing that information. I've filed a refund request for {{selected_transaction}} with the reason: \"{{refund_reason}}\".\n\nYour refund request has been submitted successfully! You'll receive a confirmation email shortly, and we'll keep you updated on the status.",
      'type': ChatMessageType.assistant,
      'actions': [
        {
          'label': "View refund details",
          'actionType': "view_refund",
          'parameters': {"ref_id": "REF_DYNAMIC"},
        },
        {
          'label': "Set notification preferences",
          'actionType': "set_notifications",
          'parameters': {"type": "refund_updates"},
        },
      ],
    },
  };
  
  /// Templates for dispute flow
  static Map<String, dynamic> disputeTemplates = {
    'dispute_start': {
      'text': "Let's start a transaction dispute. This is a formal process to contest a charge. Here's how it works:",
      'type': ChatMessageType.assistant,
    },
    
    'dispute_explanation': {
      'text': "1. We'll gather information about the disputed transaction\n2. We'll submit the dispute to the merchant\n3. The merchant has 7-10 days to respond\n4. We'll keep you updated on the progress\n\nReady to proceed?",
      'type': ChatMessageType.assistant,
      'suggestions': [
        "Yes, let's proceed",
        "What information is needed?",
        "How long will this take?"
      ],
      'actions': [
        {
          'label': "View dispute policy",
          'actionType': "view_document",
          'parameters': {"doc_id": "dispute_policy"},
        },
      ],
    },
    
    'dispute_transaction_selection': {
      'text': "Great! To start the dispute process, please select the transaction you want to dispute:",
      'type': ChatMessageType.assistant,
      'suggestions': [
        "Coffee Shop - ₨1,250 - Yesterday",
        "Online Store - ₨5,890 - June 5, 2023",
        "Grocery Store - ₨3,450 - June 2, 2023",
        "Other transaction"
      ],
    },
  };
  
  /// Templates for tracking refund status
  static Map<String, dynamic> trackingTemplates = {
    'refund_status_intro': {
      'text': "I can check the status of your refunds. Here are your recent refund requests:",
      'type': ChatMessageType.assistant,
    },
    
    'refund_status_details': {
      'text': "• Coffee Shop (₨1,250) - In Progress\nEstimated completion: 3-5 business days\n\n• Online Store (₨5,890) - Completed\nRefunded on: June 8, 2023\n\nWould you like more details on either of these?",
      'type': ChatMessageType.assistant,
      'suggestions': [
        "Details on Coffee Shop refund",
        "Details on Online Store refund",
        "I have another question"
      ],
    },
  };
  
  /// Creates a ChatMessage from a template
  static ChatMessage createFromTemplate(
    Map<String, dynamic> template, 
    Map<String, dynamic> context
  ) {
    // Parse text with variables
    final text = _parseTemplate(template['text'], context);
    
    // Create suggestions from template
    List<String>? suggestions;
    if (template.containsKey('suggestions')) {
      suggestions = List<String>.from(template['suggestions']);
    }
    
    // Create actions from template
    List<ChatAction>? actions;
    if (template.containsKey('actions')) {
      actions = template['actions'].map<ChatAction>((action) {
        // Clone the parameters map to avoid modifying the original
        Map<String, dynamic>? params;
        if (action.containsKey('parameters')) {
          params = Map<String, dynamic>.from(action['parameters']);
          
          // Handle special dynamic parameters
          if (params.containsKey('ref_id') && params['ref_id'] == 'REF_DYNAMIC') {
            params['ref_id'] = 'REF' + DateTime.now().millisecondsSinceEpoch.toString().substring(0, 6);
          }
        }
        
        return ChatAction(
          label: action['label'],
          actionType: action['actionType'],
          parameters: params,
        );
      }).toList();
    }
    
    // Create ChatMessage
    return ChatMessage(
      text: text,
      type: template['type'],
      timestamp: DateTime.now(),
      suggestions: suggestions,
      actions: actions,
      data: template.containsKey('data') ? template['data'] : null,
    );
  }
  
  /// Parse template string with variables
  static String _parseTemplate(String template, Map<String, dynamic> context) {
    final regex = RegExp(r'\{\{(\w+)\}\}');
    return template.replaceAllMapped(regex, (match) {
      final variable = match.group(1);
      
      if (variable == null) return '';
      
      // Look up the variable in context
      if (context.containsKey(variable)) {
        return context[variable].toString();
      }
      
      // Handle special variables
      if (variable == 'current_date') {
        final now = DateTime.now();
        return '${now.day}/${now.month}/${now.year}';
      }
      
      if (variable == 'user_name') {
        return 'User'; // Could be replaced with actual user name from profile
      }
      
      // Return empty string if variable not found
      return '';
    });
  }
} 