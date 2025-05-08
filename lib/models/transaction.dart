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

  static List<Transaction> getMockTransactions({int count = 6}) {
    final List<Transaction> baseTransactions = [
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
    
    // If we need exactly the base amount, return them
    if (count <= baseTransactions.length) {
      return baseTransactions.sublist(0, count);
    }
    
    // Otherwise, generate additional transactions
    final List<Transaction> result = List.from(baseTransactions);
    final List<String> titles = [
      'Coffee Shop',
      'Fuel Station',
      'Online Shopping',
      'Mobile Recharge',
      'Electricity Bill',
      'Internet Bill',
      'Clothing Store',
      'Restaurant Payment',
      'Movie Tickets',
      'Ride Sharing',
      'Subscription Payment',
      'Money Transfer',
      'ATM Withdrawal',
      'Medical Expenses',
      'Hardware Store',
      'Book Store',
      'Home Appliances',
      'Phone Bill'
    ];
    
    final List<String> descriptions = [
      'Daily coffee',
      'Vehicle refueling',
      'Purchased items online',
      'Monthly mobile balance',
      'Monthly electricity payment',
      'Internet service payment',
      'Seasonal shopping',
      'Dining out',
      'Weekend entertainment',
      'Transportation',
      'Monthly subscription',
      'Sent money to friend',
      'Cash withdrawal',
      'Healthcare expenses',
      'Home repairs',
      'Educational materials',
      'Home improvement',
      'Phone service'
    ];
    
    final List<TransactionType> types = [
      TransactionType.withdrawal,
      TransactionType.transfer,
      TransactionType.ghostPayment,
      TransactionType.refund,
    ];
    
    final List<TransactionStatus> statuses = [
      TransactionStatus.completed,
      TransactionStatus.completed, // More likely to be completed
      TransactionStatus.completed,
      TransactionStatus.completed,
      TransactionStatus.pending,
      TransactionStatus.failed,
      TransactionStatus.flagged,
    ];
    
    // Generate additional random transactions
    for (int i = baseTransactions.length; i < count; i++) {
      final titleIndex = i % titles.length;
      final typeIndex = i % types.length;
      final statusIndex = i % statuses.length;
      
      // Generate a random amount between 500 and 50000
      final amount = 500 + (49500 * (i / count));
      
      // Create a date in the past (up to 30 days ago)
      final daysAgo = (i / 3).round() + 1; // Distribute over the past month
      final date = DateTime.now().subtract(Duration(days: daysAgo));
      
      result.add(Transaction(
        id: (i + 1).toString(),
        title: titles[titleIndex],
        description: descriptions[titleIndex],
        amount: amount,
        date: date,
        type: types[typeIndex],
        status: statuses[statusIndex],
        merchantName: 'Merchant ${i + 1}',
        categoryName: types[typeIndex].toString().split('.').last.toUpperCase(),
      ));
    }
    
    // Sort by date (newest first)
    result.sort((a, b) => b.date.compareTo(a.date));
    
    return result;
  }
} 