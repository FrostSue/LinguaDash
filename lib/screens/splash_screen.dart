import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants.dart';
import '../providers/settings_provider.dart';
import 'main_menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await context.read<SettingsProvider>().loadSettings();
      
      await Future.delayed(const Duration(seconds: 4));
      if (mounted) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (_) => const MainMenu())
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            
            Image.asset('assets/icons/icon.png', width: 140)
                .animate()
                .fade(duration: 800.ms)
                .scale(duration: 800.ms),
                
            const SizedBox(height: 20),
            
            Text(
              settings.getText('game_title'),
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
                fontFamily: 'Monogram'
              )
            ).animate().fadeIn(delay: 400.ms).moveY(begin: 30, end: 0),
            
            const Spacer(),
            
            
            SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const LinearProgressIndicator(
                  color: AppColors.primaryPurple,
                  backgroundColor: Colors.black12,
                  minHeight: 6,
                ),
              )
            ),
            
            const SizedBox(height: 15),
            
            Text(
              settings.getText('loading'),
              style: TextStyle(
                color: AppColors.primaryPurple.withOpacity(0.7),
                fontSize: 16,
                fontFamily: 'Monogram'
              )
            ),
            
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}