import 'package:flutter/material.dart';
import 'package:visa_app/theme/app_theme.dart';

enum TransactionType {
  deposit,
  withdrawal,
  ghostPayment,
  groupPayment,
  transfer,
  refund,
  fee
}

enum TransactionStatus {
  completed,
  pending,
  failed,
  disputed,
  flagged
}

class Transaction {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final TransactionStatus status;
  final String? merchantLogo;
  final String? merchantName;
  final String? categoryIcon;
  final String? categoryName;
  final bool isSecurityVerified;

  const Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    this.status = TransactionStatus.completed,
    this.merchantLogo,
    this.merchantName,
    this.categoryIcon,
    this.categoryName,
    this.isSecurityVerified = true,
  });

  bool get isCredit => 
      type == TransactionType.deposit || 
      type == TransactionType.refund;

  Color get amountColor {
    if (status == TransactionStatus.failed) return AppTheme.textMuted;
    if (status == TransactionStatus.disputed) return AppTheme.warningNeon;
    if (status == TransactionStatus.flagged) return AppTheme.dangerNeon;
    return isCredit ? AppTheme.primaryNeon : AppTheme.textPrimary;
  }

  String get formattedAmount {
    final sign = isCredit ? '+' : '-';
    return '$sign PKR ${amount.toStringAsFixed(2)}';
  }

  IconData get typeIcon {
    switch (type) {
      case TransactionType.deposit:
        return Icons.arrow_downward_rounded;
      case TransactionType.withdrawal:
        return Icons.arrow_upward_rounded;
      case TransactionType.ghostPayment:
        return Icons.flash_on_rounded;
      case TransactionType.groupPayment:
        return Icons.group_rounded;
      case TransactionType.transfer:
        return Icons.swap_horiz_rounded;
      case TransactionType.refund:
        return Icons.replay_rounded;
      case TransactionType.fee:
        return Icons.attach_money_rounded;
    }
  }

  Color get typeColor {
    switch (type) {
      case TransactionType.deposit:
        return AppTheme.primaryNeon;
      case TransactionType.withdrawal:
        return AppTheme.textPrimary;
      case TransactionType.ghostPayment:
        return AppTheme.accentNeon;
      case TransactionType.groupPayment:
        return AppTheme.secondaryNeon;
      case TransactionType.transfer:
        return AppTheme.accentNeon;
      case TransactionType.refund:
        return AppTheme.primaryNeon;
      case TransactionType.fee:
        return AppTheme.warningNeon;
    }
  }

  static List<Transaction> getMockTransactions() {
    return [
      Transaction(
        id: '1',
        title: 'Salary Deposit',
        description: 'Monthly salary payment',
        amount: 150000,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        type: TransactionType.deposit,
        merchantName: 'MegaCorp Inc.',
        categoryName: 'Income',
      ),
      Transaction(
        id: '2',
        title: 'Grocery Shopping',
        description: 'Weekly groceries',
        amount: 15250,
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: TransactionType.withdrawal,
        merchantName: 'AlFatah Supermarket',
        categoryName: 'Groceries',
      ),
      Transaction(
        id: '3',
        title: 'Ghost Payment',
        description: 'One-time secure payment',
        amount: 25000,
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: TransactionType.ghostPayment,
        merchantName: 'Secret Vendor',
        categoryName: 'Services',
      ),
      Transaction(
        id: '4',
        title: 'Group Dinner',
        description: 'Split bill with friends',
        amount: 8550,
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: TransactionType.groupPayment,
        merchantName: 'BBQ Tonight',
        categoryName: 'Dining',
      ),
      Transaction(
        id: '5',
        title: 'Suspicious Attempt',
        description: 'Blocked by Scam Radar',
        amount: 50000,
        date: DateTime.now().subtract(const Duration(days: 4)),
        type: TransactionType.withdrawal,
        status: TransactionStatus.flagged,
        merchantName: 'Unknown Merchant',
        categoryName: 'Security Alert',
        isSecurityVerified: false,
      ),
      Transaction(
        id: '6',
        title: 'Airline Refund',
        description: 'Flight cancellation',
        amount: 35000,
        date: DateTime.now().subtract(const Duration(days: 5)),
        type: TransactionType.refund,
        merchantName: 'PIA Airways',
        categoryName: 'Travel',
      ),
    ];
  }
} 