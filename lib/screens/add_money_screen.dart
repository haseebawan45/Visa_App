import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visa_app/theme/app_theme.dart';
import 'package:visa_app/widgets/neuro_card.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedSource = 'Credit/Debit Card';
  bool _isProcessing = false;
  
  final List<String> _fundingSources = [
    'Credit/Debit Card',
    'Bank Account',
    'Apple Pay',
    'Google Pay',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _processAddMoney() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.dangerNeon,
          content: Text('Please enter an amount', style: TextStyle(color: Colors.white)),
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate processing delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        
        // Show success and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.primaryNeon,
            content: Text(
              'Successfully added ${_amountController.text} PKR',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Add Money',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.backgroundLighter,
                  AppTheme.background,
                  AppTheme.backgroundDarker,
                ],
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount section
                    Text(
                      'Enter Amount',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Amount input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryNeon.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'PKR',
                            style: TextStyle(
                              color: AppTheme.primaryNeon,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '0',
                                hintStyle: TextStyle(
                                  color: AppTheme.textSecondary.withOpacity(0.5),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Source section
                    Text(
                      'Select Source',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Source selection
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: _fundingSources.map((source) {
                          bool isSelected = source == _selectedSource;
                          return ListTile(
                            title: Text(
                              source,
                              style: TextStyle(
                                color: isSelected 
                                    ? AppTheme.primaryNeon 
                                    : AppTheme.textPrimary,
                                fontWeight: isSelected 
                                    ? FontWeight.bold 
                                    : FontWeight.normal,
                              ),
                            ),
                            leading: _getSourceIcon(source),
                            trailing: isSelected 
                                ? Icon(
                                    Icons.check_circle,
                                    color: AppTheme.primaryNeon,
                                  ) 
                                : null,
                            onTap: () {
                              setState(() {
                                _selectedSource = source;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Quick amounts
                    Text(
                      'Quick Amounts',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQuickAmountButton('1,000'),
                        _buildQuickAmountButton('5,000'),
                        _buildQuickAmountButton('10,000'),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Add money button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _processAddMoney,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryNeon,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: _isProcessing
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                'Add Money',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Security note
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock,
                            size: 16,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Secured by 256-bit encryption',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickAmountButton(String amount) {
    return NeuroCard(
      borderRadius: AppTheme.radiusMedium,
      onTap: () {
        setState(() {
          _amountController.text = amount.replaceAll(',', '');
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Text(
          amount,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  Widget _getSourceIcon(String source) {
    IconData iconData;
    Color iconColor;
    
    switch (source) {
      case 'Credit/Debit Card':
        iconData = Icons.credit_card;
        iconColor = AppTheme.primaryNeon;
        break;
      case 'Bank Account':
        iconData = Icons.account_balance;
        iconColor = AppTheme.accentNeon;
        break;
      case 'Apple Pay':
        iconData = Icons.apple;
        iconColor = Colors.white;
        break;
      case 'Google Pay':
        iconData = Icons.g_mobiledata;
        iconColor = AppTheme.warningNeon;
        break;
      default:
        iconData = Icons.account_balance_wallet;
        iconColor = AppTheme.primaryNeon;
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
      ),
    );
  }
} 