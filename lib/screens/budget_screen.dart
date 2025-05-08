import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visa_app/theme/app_theme.dart';
import 'package:visa_app/widgets/futuristic_button.dart';
import 'package:visa_app/widgets/glass_container.dart';
import 'package:visa_app/widgets/neuro_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _budgetController = TextEditingController();
  double _monthlyBudget = 0.0;
  double _currentSpending = 0.0;
  bool _isBudgetSet = false;
  List<ExpenseCategory> _categories = [];
  
  @override
  void initState() {
    super.initState();
    // Initialize with dummy data
    _currentSpending = 12450.0;
    _initializeCategories();
    _loadBudgetData();
  }
  
  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }
  
  // Load saved budget data from shared preferences
  Future<void> _loadBudgetData() async {
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      _monthlyBudget = prefs.getDouble('monthlyBudget') ?? 0.0;
      _isBudgetSet = _monthlyBudget > 0;
    });
  }
  
  // Save budget data to shared preferences
  Future<void> _saveBudgetData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('monthlyBudget', _monthlyBudget);
  }
  
  void _initializeCategories() {
    _categories = [
      ExpenseCategory(
        name: "Groceries",
        amount: 3200.0,
        color: Colors.green,
        icon: Icons.shopping_basket,
      ),
      ExpenseCategory(
        name: "Dining Out",
        amount: 2750.0,
        color: Colors.orange,
        icon: Icons.restaurant,
      ),
      ExpenseCategory(
        name: "Transportation",
        amount: 1850.0,
        color: Colors.blue,
        icon: Icons.directions_car,
      ),
      ExpenseCategory(
        name: "Entertainment",
        amount: 3100.0,
        color: Colors.purple,
        icon: Icons.movie,
      ),
      ExpenseCategory(
        name: "Shopping",
        amount: 1550.0,
        color: Colors.pink,
        icon: Icons.shopping_bag,
      ),
    ];
  }
  
  void _setBudget() {
    if (_budgetController.text.isEmpty) return;
    
    try {
      double budget = double.parse(_budgetController.text.replaceAll(',', ''));
      setState(() {
        _monthlyBudget = budget;
        _isBudgetSet = true;
      });
      _budgetController.clear();
      
      // Save budget data
      _saveBudgetData();
    } catch (e) {
      // Show error for invalid input
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a valid amount"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  
  void _editBudget() {
    setState(() {
      _isBudgetSet = false;
      _budgetController.text = _monthlyBudget.toString();
    });
  }
  
  String _formatCurrency(double amount) {
    return '₨${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},'
    )}';
  }
  
  double _getBudgetProgress() {
    if (_monthlyBudget <= 0) return 0;
    double progress = _currentSpending / _monthlyBudget;
    // Cap at 1.0 for UI purposes
    return math.min(progress, 1.0);
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
                            'Monthly Budget',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Track your spending',
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
                
                // Budget input or display
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Budget set/edit section
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            crossFadeState: _isBudgetSet 
                                ? CrossFadeState.showSecond 
                                : CrossFadeState.showFirst,
                            firstChild: _buildBudgetInputCard(),
                            secondChild: _buildBudgetSummaryCard(),
                          ),
                          
                          const SizedBox(height: AppTheme.spacingL),
                          
                          // Expense categories section
                          Text(
                            'Expense Categories',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slide(begin: const Offset(0, 0.3), end: Offset.zero, duration: 400.ms),
                          
                          const SizedBox(height: AppTheme.spacingM),
                          
                          // Category cards
                          ..._categories.map((category) => _buildCategoryCard(category)),
                          
                          const SizedBox(height: AppTheme.spacingL),
                          
                          // Spending tips
                          _buildTipsCard(),
                          
                          const SizedBox(height: AppTheme.spacingL),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBudgetInputCard() {
    return GlassContainer(
      margin: const EdgeInsets.only(top: AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      borderRadius: 20,
      opacity: AppTheme.glassOpacityMedium,
      blur: AppTheme.blurLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set Your Monthly Budget',
            style: TextStyle(
              color: AppTheme.accentNeon,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            'How much do you plan to spend this month?',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          // Budget input field
          NeuroCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingS,
            ),
            child: Row(
              children: [
                Text(
                  '₨',
                  style: TextStyle(
                    color: AppTheme.accentNeon,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: TextField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: '25,000',
                      hintStyle: TextStyle(
                        color: AppTheme.textMuted,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          // Set budget button
          Align(
            alignment: Alignment.center,
            child: FuturisticButton(
              onPressed: _setBudget,
              text: 'Set Budget',
              width: 200,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 400.ms);
  }
  
  Widget _buildBudgetSummaryCard() {
    // Calculate whether over budget
    bool isOverBudget = _currentSpending > _monthlyBudget;
    double remainingAmount = _monthlyBudget - _currentSpending;
    
    return GlassContainer(
      margin: const EdgeInsets.only(top: AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      borderRadius: 20,
      opacity: AppTheme.glassOpacityMedium,
      blur: AppTheme.blurLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Budget',
                style: TextStyle(
                  color: AppTheme.accentNeon,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              NeuroCard(
                onTap: _editBudget,
                depth: 2,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingS,
                  vertical: AppTheme.spacingXS,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit,
                      color: AppTheme.textSecondary,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Edit',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          // Budget amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _formatCurrency(_monthlyBudget),
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                'per month',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Spending',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    _formatCurrency(_currentSpending),
                    style: TextStyle(
                      color: isOverBudget ? Colors.red : AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingS),
              
              // Progress bar
              Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLighter,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: _getBudgetProgress(),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isOverBudget
                                ? [Colors.red.shade400, Colors.red.shade700]
                                : [AppTheme.accentNeon, AppTheme.accentNeon.withOpacity(0.7)],
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              
              // Remaining amount
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    isOverBudget 
                        ? 'Over budget by: ' 
                        : 'Remaining: ',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    _formatCurrency(isOverBudget ? -remainingAmount : remainingAmount),
                    style: TextStyle(
                      color: isOverBudget ? Colors.red : Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 400.ms);
  }
  
  Widget _buildCategoryCard(ExpenseCategory category) {
    // Calculate percentage of total spending
    double percentage = (_currentSpending > 0) 
        ? (category.amount / _currentSpending) * 100 
        : 0;
    
    return NeuroCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      borderRadius: 16,
      depth: 3,
      child: Row(
        children: [
          // Category icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              category.icon,
              color: category.color,
              size: 22,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          
          // Category info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 6, bottom: 6),
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundLighter,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: percentage / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: category.color,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          
          // Amount
          Text(
            _formatCurrency(category.amount),
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: Duration(milliseconds: 100 * _categories.indexOf(category)))
        .slide(begin: const Offset(0, 0.3), end: Offset.zero, duration: 400.ms);
  }
  
  Widget _buildTipsCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      borderRadius: 20,
      opacity: AppTheme.glassOpacityMedium,
      blur: AppTheme.blurLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates,
                color: AppTheme.accentNeon,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                'Smart Budget Tips',
                style: TextStyle(
                  color: AppTheme.accentNeon,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          // Tips list
          _buildTipItem(
            'Dining spending is 22% of your budget. Consider cooking at home to save.',
            Icons.restaurant,
            Colors.orange,
          ),
          
          _buildTipItem(
            'Entertainment expenses have increased by 15% compared to last month.',
            Icons.movie,
            Colors.purple,
          ),
          
          _buildTipItem(
            'Set category limits to better manage your monthly spending.',
            Icons.category,
            Colors.blue,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 600.ms)
        .slide(begin: const Offset(0, 0.3), end: Offset.zero, duration: 400.ms);
  }
  
  Widget _buildTipItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: color,
              size: 14,
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseCategory {
  final String name;
  final double amount;
  final Color color;
  final IconData icon;
  
  ExpenseCategory({
    required this.name,
    required this.amount,
    required this.color,
    required this.icon,
  });
} 