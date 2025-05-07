import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:visa_app/theme/app_theme.dart';
import 'package:visa_app/widgets/futuristic_button.dart';
import 'package:visa_app/widgets/glass_container.dart';
import 'package:visa_app/widgets/neuro_card.dart';

class GhostPaymentScreen extends StatefulWidget {
  const GhostPaymentScreen({super.key});

  @override
  State<GhostPaymentScreen> createState() => _GhostPaymentScreenState();
}

class _GhostPaymentScreenState extends State<GhostPaymentScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  bool _isAnonymous = true;
  bool _isGenerating = false;
  bool _isGenerated = false;
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  void _generatePayment() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isGenerating = true;
      });
      
      // Simulate generation process
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          setState(() {
            _isGenerating = false;
            _isGenerated = true;
          });
          _animationController.forward();
        }
      });
    }
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
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppTheme.background,
                  AppTheme.backgroundDarker,
                  Color(0xFF121726),
                ],
              ),
            ),
          ),
          
          // Decorative elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentNeon.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primaryNeon.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text(
                        'Ghost Payment',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Main content
                Expanded(
                  child: !_isGenerated
                      ? _buildPaymentForm() 
                      : _buildGeneratedQR(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPaymentForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: SizedBox(
                height: 150,
                child: Lottie.asset(
                  'assets/animations/ghost_payment.json',
                  animate: true,
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms)
                .scaleXY(begin: 0.9, end: 1.0, delay: 300.ms, duration: 500.ms),
                
            const SizedBox(height: AppTheme.spacingL),
            
            Text(
              'Create Ghost Payment',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slide(begin: const Offset(0, 0.2), end: Offset.zero, duration: 600.ms),
                
            const SizedBox(height: AppTheme.spacingS),
            
            Text(
              'Generate a secure, one-time payment link that leaves no transaction history.',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slide(begin: const Offset(0, 0.2), end: Offset.zero, delay: 200.ms, duration: 600.ms),
                
            const SizedBox(height: AppTheme.spacingXL),
            
            // Amount field
            GlassContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS,
              ),
              borderRadius: AppTheme.radiusMedium,
              opacity: AppTheme.glassOpacityMedium,
              blur: AppTheme.blurLight,
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  hintText: 'Amount (PKR)',
                  hintStyle: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.payments_outlined,
                    color: AppTheme.secondaryNeon,
                  ),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 600.ms)
                .slide(begin: const Offset(-0.1, 0), end: Offset.zero, delay: 300.ms, duration: 600.ms),
                
            const SizedBox(height: AppTheme.spacingM),
            
            // Note field
            GlassContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS,
              ),
              borderRadius: AppTheme.radiusMedium,
              opacity: AppTheme.glassOpacityMedium,
              blur: AppTheme.blurLight,
              child: TextFormField(
                controller: _noteController,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                ),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Note (optional)',
                  hintStyle: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.note_alt_outlined,
                    color: AppTheme.secondaryNeon,
                  ),
                  border: InputBorder.none,
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slide(begin: const Offset(0.1, 0), end: Offset.zero, delay: 400.ms, duration: 600.ms),
                
            const SizedBox(height: AppTheme.spacingL),
            
            // Anonymous toggle
            GlassContainer(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              borderRadius: AppTheme.radiusMedium,
              opacity: AppTheme.glassOpacityMedium,
              blur: AppTheme.blurLight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_off_rounded,
                        color: AppTheme.accentNeon,
                        size: 24,
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Text(
                        'Anonymous Mode',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _isAnonymous,
                    onChanged: (value) {
                      setState(() {
                        _isAnonymous = value;
                      });
                    },
                    activeColor: AppTheme.accentNeon,
                    activeTrackColor: AppTheme.accentNeon.withOpacity(0.3),
                    inactiveThumbColor: AppTheme.textMuted,
                    inactiveTrackColor: AppTheme.backgroundLighter,
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 500.ms, duration: 600.ms)
                .slide(begin: const Offset(0, 0.2), end: Offset.zero, delay: 500.ms, duration: 600.ms),
                
            const SizedBox(height: AppTheme.spacingXL),
            
            // Generate button
            FuturisticButton(
              text: _isGenerating ? 'Generating...' : 'Generate Ghost Payment',
              onPressed: _isGenerating ? () {} : _generatePayment,
              color: AppTheme.secondaryNeon,
              isLoading: _isGenerating,
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .scaleXY(begin: 0.9, end: 1.0, delay: 600.ms, duration: 600.ms),
                
            const SizedBox(height: AppTheme.spacingM),
            
            // Security hint
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield,
                    color: AppTheme.primaryNeon,
                    size: 16,
                  ),
                  const SizedBox(width: AppTheme.spacingXS),
                  Text(
                    'Encrypted & Untraceable',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 700.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGeneratedQR() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppTheme.spacingL),
                
                // Success message
                Text(
                  'Ghost Payment Ready',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slide(begin: const Offset(0, -0.2), end: Offset.zero, duration: 600.ms),
                
                const SizedBox(height: AppTheme.spacingS),
                
                Text(
                  'Share this secure QR to receive ${_amountController.text} PKR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms)
                    .slide(begin: const Offset(0, 0.2), end: Offset.zero, delay: 200.ms, duration: 600.ms),
                
                const SizedBox(height: AppTheme.spacingXL),
                
                // QR Code
                GlassContainer(
                  width: 280,
                  height: 280,
                  borderRadius: AppTheme.radiusLarge,
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  border: Border.all(
                    color: AppTheme.secondaryNeon.withOpacity(0.3),
                    width: 2,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // QR Code
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        child: Image.asset(
                          'assets/images/qr_placeholder.png',
                          width: 230,
                          height: 230,
                          fit: BoxFit.cover,
                        ),
                      ),
                      
                      // Animated overlay
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.secondaryNeon.withOpacity(0.2 * (1 - _animationController.value)),
                                  Colors.transparent,
                                  AppTheme.accentNeon.withOpacity(0.2 * (1 - _animationController.value)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      
                      // Center logo
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const FlutterLogo(),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 800.ms)
                    .scaleXY(begin: 0.8, end: 1.0, delay: 400.ms, duration: 800.ms),
                
                const SizedBox(height: AppTheme.spacingXL),
                
                // Payment details
                GlassContainer(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  borderRadius: AppTheme.radiusMedium,
                  opacity: AppTheme.glassOpacityMedium,
                  child: Column(
                    children: [
                      _buildDetailRow(
                        icon: Icons.payments_outlined,
                        label: 'Amount',
                        value: '${_amountController.text} PKR',
                        color: AppTheme.secondaryNeon,
                      ),
                      
                      if (_noteController.text.isNotEmpty) ...[
                        Divider(
                          color: AppTheme.textMuted.withOpacity(0.2),
                          height: 32,
                        ),
                        _buildDetailRow(
                          icon: Icons.note_alt_outlined,
                          label: 'Note',
                          value: _noteController.text,
                          color: AppTheme.secondaryNeon,
                        ),
                      ],
                      
                      Divider(
                        color: AppTheme.textMuted.withOpacity(0.2),
                        height: 32,
                      ),
                      
                      _buildDetailRow(
                        icon: Icons.timer_outlined,
                        label: 'Valid for',
                        value: '24 hours',
                        color: AppTheme.secondaryNeon,
                      ),
                      
                      Divider(
                        color: AppTheme.textMuted.withOpacity(0.2),
                        height: 32,
                      ),
                      
                      _buildDetailRow(
                        icon: Icons.person_off_rounded,
                        label: 'Anonymous',
                        value: _isAnonymous ? 'Yes' : 'No',
                        color: _isAnonymous ? AppTheme.accentNeon : AppTheme.textMuted,
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 600.ms)
                    .slide(begin: const Offset(0, -0.2), end: Offset.zero, delay: 600.ms, duration: 600.ms),
              ],
            ),
          ),
        ),
        
        // Bottom buttons
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              Expanded(
                child: FuturisticButton(
                  text: 'Share Link',
                  isOutlined: true,
                  color: AppTheme.secondaryNeon,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: FuturisticButton(
                  text: 'Share QR',
                  color: AppTheme.secondaryNeon,
                  onPressed: () {},
                ),
              ),
            ],
          )
              .animate()
              .fadeIn(delay: 800.ms, duration: 600.ms),
        ),
      ],
    );
  }
  
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(width: AppTheme.spacingS),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 