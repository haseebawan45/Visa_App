import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:visa_app/models/transaction.dart';
import 'package:visa_app/theme/app_theme.dart';
import 'package:visa_app/widgets/glass_container.dart';
import 'package:visa_app/widgets/neuro_card.dart';
import 'package:visa_app/widgets/transaction_card.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final List<Transaction> _allTransactions = Transaction.getMockTransactions(count: 50);
  List<Transaction> _filteredTransactions = [];
  
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Filter options
  DateTime? _startDate;
  DateTime? _endDate;
  TransactionType? _selectedType;
  TransactionStatus? _selectedStatus;
  bool _showFilterOptions = false;
  
  @override
  void initState() {
    super.initState();
    // Set initial filtered transactions to all transactions
    _filteredTransactions = List.from(_allTransactions);
    
    // Add listener to search field
    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFilters();
    });
  }
  
  void _applyFilters() {
    setState(() {
      _filteredTransactions = _allTransactions.where((transaction) {
        // Apply search filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          if (!transaction.title.toLowerCase().contains(query) &&
              !transaction.description.toLowerCase().contains(query)) {
            return false;
          }
        }
        
        // Apply type filter
        if (_selectedType != null && transaction.type != _selectedType) {
          return false;
        }
        
        // Apply status filter
        if (_selectedStatus != null && transaction.status != _selectedStatus) {
          return false;
        }
        
        // Apply date range filter
        if (_startDate != null) {
          if (transaction.date.isBefore(_startDate!)) {
            return false;
          }
        }
        
        if (_endDate != null) {
          // Add one day to include the end date fully
          final endDateIncluded = _endDate!.add(const Duration(days: 1));
          if (transaction.date.isAfter(endDateIncluded)) {
            return false;
          }
        }
        
        return true;
      }).toList();
      
      // Sort by most recent first
      _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
    });
  }
  
  void _resetFilters() {
    setState(() {
      _selectedType = null;
      _selectedStatus = null;
      _startDate = null;
      _endDate = null;
      _searchController.clear();
      _searchQuery = '';
      _filteredTransactions = List.from(_allTransactions);
    });
  }
  
  void _toggleFilterOptions() {
    setState(() {
      _showFilterOptions = !_showFilterOptions;
    });
  }
  
  Future<void> _selectDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: _startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      end: _endDate ?? DateTime.now(),
    );
    
    final pickedDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primaryNeon,
              onPrimary: Colors.white,
              surface: AppTheme.backgroundLighter,
              onSurface: AppTheme.textPrimary,
            ),
            dialogBackgroundColor: AppTheme.backgroundDarker,
          ),
          child: child!,
        );
      },
    );
    
    if (pickedDateRange != null) {
      setState(() {
        _startDate = pickedDateRange.start;
        _endDate = pickedDateRange.end;
        _applyFilters();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Group transactions by date
    final groupedTransactions = _groupTransactionsByDate(_filteredTransactions);
    
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
          
          // Decorative element
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
                // App bar with back button and title
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
                            'Transaction History',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_filteredTransactions.length} transactions found',
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
                        onTap: _toggleFilterOptions,
                        child: Icon(
                          Icons.filter_list,
                          color: _showFilterOptions 
                              ? AppTheme.primaryNeon 
                              : AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Search and filter row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
                  child: Column(
                    children: [
                      // Search field
                      GlassContainer(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                          vertical: AppTheme.spacingS,
                        ),
                        borderRadius: AppTheme.radiusLarge,
                        opacity: AppTheme.glassOpacityMedium,
                        blur: AppTheme.blurLight,
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: AppTheme.textMuted,
                              size: 20,
                            ),
                            const SizedBox(width: AppTheme.spacingS),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search transactions...',
                                  hintStyle: TextStyle(
                                    color: AppTheme.textMuted,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: AppTheme.textMuted,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // Filter options
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: _showFilterOptions ? 160 : 0,
                        curve: Curves.easeInOut,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: AppTheme.spacingM),
                              Text(
                                'Filter Transactions',
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacingM),
                              
                              // Filter options
                              Row(
                                children: [
                                  // Date range filter
                                  Expanded(
                                    child: NeuroCard(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppTheme.spacingM,
                                        vertical: AppTheme.spacingS,
                                      ),
                                      onTap: () => _selectDateRange(context),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            color: _startDate != null 
                                                ? AppTheme.primaryNeon 
                                                : AppTheme.textMuted,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _startDate != null && _endDate != null
                                                  ? '${DateFormat.MMMd().format(_startDate!)} - ${DateFormat.MMMd().format(_endDate!)}'
                                                  : 'Date Range',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: _startDate != null 
                                                    ? AppTheme.textPrimary 
                                                    : AppTheme.textMuted,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(width: AppTheme.spacingS),
                                  
                                  // Reset filters
                                  NeuroCard(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppTheme.spacingM,
                                      vertical: AppTheme.spacingS,
                                    ),
                                    onTap: _resetFilters,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.refresh,
                                          color: AppTheme.textMuted,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Reset',
                                          style: TextStyle(
                                            color: AppTheme.textMuted,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: AppTheme.spacingM),
                              
                              // Transaction type filters
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildTypeFilter(null, 'All'),
                                    _buildTypeFilter(TransactionType.withdrawal, 'Payment'),
                                    _buildTypeFilter(TransactionType.transfer, 'Transfer'),
                                    _buildTypeFilter(TransactionType.refund, 'Refund'),
                                    _buildTypeFilter(TransactionType.ghostPayment, 'Ghost Pay'),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: AppTheme.spacingM),
                              
                              // Transaction status filters
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildStatusFilter(null, 'All'),
                                    _buildStatusFilter(TransactionStatus.completed, 'Completed'),
                                    _buildStatusFilter(TransactionStatus.pending, 'Pending'),
                                    _buildStatusFilter(TransactionStatus.failed, 'Failed'),
                                    _buildStatusFilter(TransactionStatus.flagged, 'Flagged'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Active filters display
                if (_selectedType != null || _selectedStatus != null || _startDate != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                      vertical: AppTheme.spacingS,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (_selectedType != null)
                            _buildActiveFilter(
                              '${_selectedType.toString().split('.').last}',
                              () {
                                setState(() {
                                  _selectedType = null;
                                  _applyFilters();
                                });
                              }
                            ),
                            
                          if (_selectedStatus != null)
                            _buildActiveFilter(
                              '${_selectedStatus.toString().split('.').last}',
                              () {
                                setState(() {
                                  _selectedStatus = null;
                                  _applyFilters();
                                });
                              }
                            ),
                            
                          if (_startDate != null && _endDate != null)
                            _buildActiveFilter(
                              '${DateFormat.MMMd().format(_startDate!)} - ${DateFormat.MMMd().format(_endDate!)}',
                              () {
                                setState(() {
                                  _startDate = null;
                                  _endDate = null;
                                  _applyFilters();
                                });
                              }
                            ),
                        ],
                      ),
                    ),
                  ),
                
                const SizedBox(height: AppTheme.spacingS),
                
                // Transactions list
                Expanded(
                  child: _filteredTransactions.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.only(
                            bottom: AppTheme.spacingL,
                          ),
                          itemCount: groupedTransactions.length,
                          itemBuilder: (context, index) {
                            final date = groupedTransactions.keys.elementAt(index);
                            final transactions = groupedTransactions[date]!;
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Date header
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.spacingM,
                                    vertical: AppTheme.spacingS,
                                  ),
                                  child: Text(
                                    _formatDateHeader(date),
                                    style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                
                                // Transactions for this date
                                ...transactions.map((transaction) => TransactionCard(
                                  transaction: transaction,
                                  onTap: () => _showTransactionDetails(transaction),
                                  index: transactions.indexOf(transaction),
                                )),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTypeFilter(TransactionType? type, String label) {
    final bool isSelected = _selectedType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          _applyFilters();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: AppTheme.spacingS),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingXS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryNeon.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: isSelected ? AppTheme.primaryNeon : AppTheme.textMuted.withOpacity(0.5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryNeon : AppTheme.textMuted,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatusFilter(TransactionStatus? status, String label) {
    final bool isSelected = _selectedStatus == status;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = status;
          _applyFilters();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: AppTheme.spacingS),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingXS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentNeon.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: isSelected ? AppTheme.accentNeon : AppTheme.textMuted.withOpacity(0.5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.accentNeon : AppTheme.textMuted,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  
  Widget _buildActiveFilter(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: AppTheme.spacingS),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: 2,
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
          Text(
            label,
            style: TextStyle(
              color: AppTheme.primaryNeon,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              color: AppTheme.primaryNeon,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            color: AppTheme.textMuted,
            size: 64,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            'No transactions found',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Try adjusting your filters or search terms',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          NeuroCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingL,
              vertical: AppTheme.spacingM,
            ),
            onTap: _resetFilters,
            child: Text(
              'Reset Filters',
              style: TextStyle(
                color: AppTheme.accentNeon,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showTransactionDetails(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildTransactionDetailsSheet(transaction),
    );
  }
  
  Widget _buildTransactionDetailsSheet(Transaction transaction) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppTheme.spacingM),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textMuted.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Transaction details
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with merchant logo and transaction title
                  Row(
                    children: [
                      NeuroCard(
                        width: 60,
                        height: 60,
                        borderRadius: 15,
                        depth: 3,
                        padding: const EdgeInsets.all(0),
                        child: Center(
                          child: Icon(
                            _getIconForTransactionType(transaction.type),
                            color: _getColorForTransactionType(transaction.type),
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.title,
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy, hh:mm a').format(transaction.date),
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                          vertical: AppTheme.spacingXS,
                        ),
                        decoration: BoxDecoration(
                          color: _getColorForTransactionStatus(transaction.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                          border: Border.all(
                            color: _getColorForTransactionStatus(transaction.status).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          _getStatusText(transaction.status),
                          style: TextStyle(
                            color: _getColorForTransactionStatus(transaction.status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Amount
                  GlassContainer(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    borderRadius: 15,
                    opacity: AppTheme.glassOpacityMedium,
                    blur: AppTheme.blurLight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _formatAmount(transaction.amount, transaction.type),
                          style: TextStyle(
                            color: transaction.type == TransactionType.refund 
                                ? Colors.green 
                                : AppTheme.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Transaction details
                  Text(
                    'Details',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Details list
                  _buildDetailItem('Transaction ID', '#${transaction.hashCode.toString().substring(0, 8)}'),
                  _buildDetailItem('Category', _getCategoryText(transaction.type)),
                  _buildDetailItem('Description', transaction.description),
                  _buildDetailItem('Method', 'VISA Card **** 4269'),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: NeuroCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingM,
                            vertical: AppTheme.spacingM,
                          ),
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.support_agent,
                                color: AppTheme.primaryNeon,
                                size: 20,
                              ),
                              const SizedBox(width: AppTheme.spacingS),
                              Text(
                                'Get Help',
                                style: TextStyle(
                                  color: AppTheme.primaryNeon,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: NeuroCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingM,
                            vertical: AppTheme.spacingM,
                          ),
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.file_download_outlined,
                                color: AppTheme.accentNeon,
                                size: 20,
                              ),
                              const SizedBox(width: AppTheme.spacingS),
                              Text(
                                'Download',
                                style: TextStyle(
                                  color: AppTheme.accentNeon,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  if (transaction.status == TransactionStatus.flagged)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppTheme.spacingL),
                        
                        // Warning for flagged transactions
                        GlassContainer(
                          padding: const EdgeInsets.all(AppTheme.spacingM),
                          borderRadius: 15,
                          opacity: AppTheme.glassOpacityMedium,
                          blur: AppTheme.blurLight,
                          border: Border.all(
                            color: AppTheme.dangerNeon.withOpacity(0.3),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: AppTheme.dangerNeon,
                                size: 24,
                              ),
                              const SizedBox(width: AppTheme.spacingM),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Suspicious Transaction',
                                      style: TextStyle(
                                        color: AppTheme.dangerNeon,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'This transaction was flagged for security reasons. Please review and contact support if you don\'t recognize it.',
                                      style: TextStyle(
                                        color: AppTheme.textPrimary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: AppTheme.spacingM),
                        
                        Center(
                          child: NeuroCard(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingL,
                              vertical: AppTheme.spacingM,
                            ),
                            onTap: () {},
                            child: Text(
                              'Report Fraud',
                              style: TextStyle(
                                color: AppTheme.dangerNeon,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper function to group transactions by date
  Map<DateTime, List<Transaction>> _groupTransactionsByDate(List<Transaction> transactions) {
    final Map<DateTime, List<Transaction>> grouped = {};
    
    for (final transaction in transactions) {
      // Remove time component to group by date only
      final date = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      
      grouped[date]!.add(transaction);
    }
    
    // Sort dates in descending order (newest first)
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    
    return {for (var key in sortedKeys) key: grouped[key]!};
  }
  
  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }
  
  IconData _getIconForTransactionType(TransactionType type) {
    switch (type) {
      case TransactionType.withdrawal:
        return Icons.shopping_bag_outlined;
      case TransactionType.transfer:
        return Icons.swap_horiz;
      case TransactionType.refund:
        return Icons.restore;
      case TransactionType.ghostPayment:
        return Icons.flash_on_rounded;
      case TransactionType.groupPayment:
        return Icons.group_rounded;
      case TransactionType.deposit:
        return Icons.arrow_downward_rounded;
      case TransactionType.fee:
        return Icons.attach_money_rounded;
    }
  }
  
  Color _getColorForTransactionType(TransactionType type) {
    switch (type) {
      case TransactionType.withdrawal:
        return AppTheme.primaryNeon;
      case TransactionType.transfer:
        return AppTheme.accentNeon;
      case TransactionType.refund:
        return Colors.green;
      case TransactionType.ghostPayment:
        return AppTheme.warningNeon;
      case TransactionType.groupPayment:
        return AppTheme.secondaryNeon;
      case TransactionType.deposit:
        return AppTheme.primaryNeon;
      case TransactionType.fee:
        return AppTheme.warningNeon;
    }
  }
  
  Color _getColorForTransactionStatus(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return Colors.green;
      case TransactionStatus.pending:
        return AppTheme.warningNeon;
      case TransactionStatus.failed:
        return Colors.red;
      case TransactionStatus.flagged:
        return AppTheme.dangerNeon;
      case TransactionStatus.disputed:
        return AppTheme.warningNeon;
    }
  }
  
  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.flagged:
        return 'Flagged';
      case TransactionStatus.disputed:
        return 'Disputed';
    }
  }
  
  String _getCategoryText(TransactionType type) {
    switch (type) {
      case TransactionType.withdrawal:
        return 'Payment';
      case TransactionType.transfer:
        return 'Transfer';
      case TransactionType.refund:
        return 'Refund';
      case TransactionType.ghostPayment:
        return 'Ghost Payment';
      case TransactionType.groupPayment:
        return 'Group Payment';
      case TransactionType.deposit:
        return 'Deposit';
      case TransactionType.fee:
        return 'Fee';
    }
  }
  
  String _formatAmount(double amount, TransactionType type) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final symbol = '₨';
    
    // Add plus sign for refunds
    if (type == TransactionType.refund || type == TransactionType.deposit) {
      return '+$symbol${formatter.format(amount)}';
    } else if (type == TransactionType.withdrawal || type == TransactionType.fee) {
      return '-$symbol${formatter.format(amount)}';
    } else {
      return '$symbol${formatter.format(amount)}';
    }
  }
} 