import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resona/core/providers/current_user_notifier.dart';
import 'package:resona/features/auth/view/pages/signup_page.dart';
import 'package:resona/features/home/view/pages/home_page.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // Wait, then navigate based on auth state
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      final currentUser = ref.read(currentUserNotifierProvider);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
          currentUser == null ? const SignupPage() : HomePage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Replace with Image.asset('assets/logo.png', height: 80) once ready
              const Icon(
                Icons.music_note_rounded,
                color: Colors.white,
                size: 80,
              ),
              const SizedBox(height: 16),
              const Text(
                'Resona',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Feel the sound',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}