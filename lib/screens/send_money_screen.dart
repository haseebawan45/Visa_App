import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visa_app/theme/app_theme.dart';
import 'package:visa_app/widgets/neuro_card.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedRecipient = '';
  String _selectedAccount = 'Main Account (PKR 275,850.75)';
  bool _isProcessing = false;
  int _currentStep = 0;
  
  final List<Map<String, dynamic>> _recentRecipients = [
    {
      'name': 'Sarah Johnson',
      'phone': '+92 300 1234567',
      'avatar': 'S',
      'color': Colors.purple,
    },
    {
      'name': 'Michael Brown',
      'phone': '+92 301 7654321',
      'avatar': 'M',
      'color': Colors.blue,
    },
    {
      'name': 'Emma Davis',
      'phone': '+92 302 9876543',
      'avatar': 'E',
      'color': Colors.orange,
    },
  ];
  
  final List<String> _accounts = [
    'Main Account (PKR 275,850.75)',
    'Savings Account (PKR 120,450.50)',
    'Business Account (PKR 43,250.25)',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedRecipient.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.dangerNeon,
          content: Text('Please select a recipient', style: TextStyle(color: Colors.white)),
        ),
      );
      return;
    }
    
    if (_currentStep == 1 && _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.dangerNeon,
          content: Text('Please enter an amount', style: TextStyle(color: Colors.white)),
        ),
      );
      return;
    }
    
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      _processSendMoney();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _processSendMoney() {
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
              'Successfully sent ${_amountController.text} PKR to $_selectedRecipient',
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
          'Send Money',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: _previousStep,
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
            child: Column(
              children: [
                // Progress indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: List.generate(3, (index) {
                      bool isActive = index <= _currentStep;
                      bool isCurrent = index == _currentStep;
                      
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          height: 4,
                          decoration: BoxDecoration(
                            color: isActive
                                ? isCurrent
                                    ? AppTheme.primaryNeon
                                    : AppTheme.accentNeon
                                : AppTheme.textMuted.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                
                // Step label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getStepTitle(),
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Step ${_currentStep + 1}/3',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Main content area
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: _buildCurrentStep(),
                  ),
                ),
                
                // Bottom action button
                Container(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _nextStep,
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
                              _getButtonText(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
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
  
  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Select Recipient';
      case 1:
        return 'Enter Amount';
      case 2:
        return 'Review & Confirm';
      default:
        return 'Send Money';
    }
  }
  
  String _getButtonText() {
    switch (_currentStep) {
      case 0:
      case 1:
        return 'Continue';
      case 2:
        return 'Send Money';
      default:
        return 'Next';
    }
  }
  
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildRecipientStep();
      case 1:
        return _buildAmountStep();
      case 2:
        return _buildReviewStep();
      default:
        return Container();
    }
  }
  
  Widget _buildRecipientStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.textMuted.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: AppTheme.textMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search by name or number',
                    hintStyle: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Recent recipients
        Text(
          'Recent Recipients',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: _recentRecipients.map((recipient) {
              bool isSelected = recipient['name'] == _selectedRecipient;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: recipient['color'],
                  child: Text(
                    recipient['avatar'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  recipient['name'],
                  style: TextStyle(
                    color: isSelected ? AppTheme.primaryNeon : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
                subtitle: Text(
                  recipient['phone'],
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 14,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: AppTheme.primaryNeon,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    _selectedRecipient = recipient['name'];
                  });
                },
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Add new recipient button
        NeuroCard(
          padding: const EdgeInsets.symmetric(vertical: 16),
          borderRadius: AppTheme.radiusMedium,
          onTap: () {
            // This would navigate to an add recipient screen in a real app
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: AppTheme.primaryNeon,
              ),
              const SizedBox(width: 8),
              Text(
                'Add New Recipient',
                style: TextStyle(
                  color: AppTheme.primaryNeon,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildAmountStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Account selection
        Text(
          'From Account',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: _accounts.map((account) {
              bool isSelected = account == _selectedAccount;
              return ListTile(
                title: Text(
                  account,
                  style: TextStyle(
                    color: isSelected ? AppTheme.primaryNeon : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
                leading: Icon(
                  Icons.account_balance_wallet,
                  color: isSelected ? AppTheme.primaryNeon : AppTheme.textMuted,
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: AppTheme.primaryNeon,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    _selectedAccount = account;
                  });
                },
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Amount input
        Text(
          'Amount',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
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
        
        const SizedBox(height: 24),
        
        // Note / purpose
        Text(
          'Add Note (Optional)',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.textMuted.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _noteController,
            style: TextStyle(
              color: AppTheme.textPrimary,
            ),
            maxLines: 3,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'What is this payment for?',
              hintStyle: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 16,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
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
      ],
    );
  }
  
  Widget _buildReviewStep() {
    String amountText = _amountController.text.isEmpty ? '0' : _amountController.text;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.primaryNeon.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Transfer Summary',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              _buildSummaryRow('From', _selectedAccount),
              _buildSummaryRow('To', _selectedRecipient),
              _buildSummaryRow('Amount', 'PKR $amountText'),
              if (_noteController.text.isNotEmpty)
                _buildSummaryRow('Note', _noteController.text),
              
              const SizedBox(height: 16),
              const Divider(color: AppTheme.textMuted),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transfer Fee',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'PKR 0.00',
                    style: TextStyle(
                      color: AppTheme.warningNeon,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'PKR $amountText',
                    style: TextStyle(
                      color: AppTheme.accentNeon,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Estimated delivery
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                color: AppTheme.accentNeon,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated Delivery',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Instant Transfer',
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
        
        const SizedBox(height: 24),
        
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
    );
  }
  
  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
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
} 