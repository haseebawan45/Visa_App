import 'package:flutter/material.dart';

enum ChatMessageType {
  user,
  assistant,
  suggestion,
  action,
  structured,
}

class ChatMessage {
  final String text;
  final ChatMessageType type;
  final DateTime timestamp;
  final List<String>? suggestions;
  final Map<String, dynamic>? data;
  final List<ChatAction>? actions;
  
  ChatMessage({
    required this.text,
    required this.type,
    required this.timestamp,
    this.suggestions,
    this.data,
    this.actions,
  });
}

class ChatAction {
  final String label;
  final String actionType;
  final Map<String, dynamic>? parameters;
  
  ChatAction({
    required this.label,
    required this.actionType,
    this.parameters,
  });
} 