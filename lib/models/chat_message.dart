import 'package:flutter/material.dart';

enum ChatMessageType {
  user,
  assistant,
  suggestion,
}

class ChatMessage {
  final String text;
  final ChatMessageType type;
  final DateTime timestamp;
  final List<String>? suggestions;

  ChatMessage({
    required this.text,
    required this.type,
    required this.timestamp,
    this.suggestions,
  });
} 