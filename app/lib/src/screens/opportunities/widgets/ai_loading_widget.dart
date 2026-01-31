import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app/src/screens/opportunities/widgets/opportunities_loader.dart';

/// Premium AI Loading Widget with rotating copy messages
/// Used during the ~60 second AI analysis wait time
class AiLoadingWidget extends StatefulWidget {
  const AiLoadingWidget({Key? key}) : super(key: key);

  @override
  State<AiLoadingWidget> createState() => _AiLoadingWidgetState();
}

class _AiLoadingWidgetState extends State<AiLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Timer? _textRotationTimer;
  int _currentTextIndex = 0;

  static const List<String> _loadingMessages = [
    'Analyzing portfolio overlap...',
    'Scanning for stopped SIPs...',
    'Calculating insurance coverage gaps...',
    'Identifying step-up opportunities...',
    'Generating personalized insights...',
  ];

  @override
  void initState() {
    super.initState();
    
    // Fade animation controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    // Start with fade in
    _fadeController.forward();
    
    // Rotate text every 3 seconds
    _textRotationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _rotateText();
    });
  }

  void _rotateText() {
    // Fade out
    _fadeController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _currentTextIndex = (_currentTextIndex + 1) % _loadingMessages.length;
        });
        // Fade in with new text
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _textRotationTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Compass Loader Animation
          const OpportunitiesLoader(
            size: 80,
            color: Color(0xFF6725F4),
          ),
          const SizedBox(height: 32),
          
          // Main Title
          const Text(
            'AI is analyzing your portfolio...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          
          // Rotating Subtitle with Fade Animation
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6725F4)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _loadingMessages[_currentTextIndex],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6725F4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Progress indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _loadingMessages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == _currentTextIndex ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == _currentTextIndex
                      ? const Color(0xFF6725F4)
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
