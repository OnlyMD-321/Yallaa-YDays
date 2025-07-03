import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../providers/auth_provider.dart';
import '../config/app_theme.dart';
import '../services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize API service
      ApiService.initialize();

      // Wait for minimum splash duration
      await Future.delayed(const Duration(seconds: 2));

      // Check authentication status
      final authProvider = context.read<AuthProvider>();

      if (mounted) {
        if (authProvider.isAuthenticated) {
          context.go('/home');
        } else {
          context.go('/login');
        }
      }
    } catch (e) {
      debugPrint('Splash screen error: $e');
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.whiteColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Y',
                      style: AppTheme.headingLarge.copyWith(
                        color: AppTheme.primaryColor,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // App Name
                Text(
                  'Yallaa',
                  style: AppTheme.headingLarge.copyWith(
                    color: AppTheme.whiteColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // App Tagline
                Text(
                  'Your Ultimate Booking Experience',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.whiteColor.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 60),

                // Loading Animation
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.whiteColor.withOpacity(0.8),
                    ),
                    strokeWidth: 3,
                  ),
                ),

                const SizedBox(height: 24),

                // Loading Text
                Text(
                  'Loading...',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.whiteColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
