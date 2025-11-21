import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../providers/settings_provider.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/banner_ad_widget.dart';
import 'mode_selection_screen.dart';
import 'settings_screen.dart';
import 'history_screen.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  Future<void> _onCustomGamePressed(BuildContext context, SettingsProvider settings) async {
    AudioService().playClick();

    final scores = await StorageService().loadHighScores();

    bool isUnlocked = (scores['classic'] ?? 0) >= 500 ||
                      (scores['timeAttack'] ?? 0) >= 500 ||
                      (scores['wordCount'] ?? 0) >= 500;

    if (isUnlocked) {
      if (context.mounted) {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (_) => const ModeSelectionScreen(isCustom: true))
        );
      }
    } else {
      if (context.mounted) {
        _showLockedDialog(context, settings);
      }
    }
  }

  void _showLockedDialog(BuildContext context, SettingsProvider s) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.lock, color: AppColors.wrongRed, size: 30),
            const SizedBox(width: 10),
            Text(
              s.getText('locked_title'), 
              style: const TextStyle(
                color: AppColors.primaryPurple, 
                fontFamily: 'Monogram', 
                fontSize: 28,
                fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
        content: Text(
          s.getText('locked_msg'),
          style: const TextStyle(fontSize: 18, height: 1.4, color: AppColors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              s.getText('ok'),
              style: const TextStyle(color: AppColors.secondaryTeal, fontWeight: FontWeight.bold, fontSize: 18)
            ),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,

      bottomNavigationBar: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: BannerAdWidget(),
        ),
      ),
      
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/icon.png', width: 100),
                const SizedBox(height: 10),
                
                Text(
                  s.getText('game_title'), 
                  style: TextStyle(
                    fontSize: 60, 
                    color: AppColors.primaryPurple, 
                    fontFamily: s.fontFamily
                  )
                ),
                
                const SizedBox(height: 50),

                CustomButton(
                  text: s.getText('play'),
                  color: AppColors.correctGreen,
                  height: 70,
                  fontSize: 32,
                  onPressed: () {
                    AudioService().playClick();
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => const ModeSelectionScreen())
                    );
                  },
                ),
                
                const SizedBox(height: 15),
                CustomButton(
                  text: s.getText('custom'),
                  color: Colors.orange,
                  onPressed: () => _onCustomGamePressed(context, s),
                ),
                
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: s.getText('settings'),
                        onPressed: () {
                          AudioService().playClick();
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (_) => const SettingsScreen())
                          );
                        },
                      )
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        text: s.getText('history'),
                        color: AppColors.secondaryTeal,
                        onPressed: () {
                          AudioService().playClick();
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (_) => const HistoryScreen())
                          );
                        },
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}