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

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _streak = 0;

  @override
  void initState() {
    super.initState();
    _loadStreak();
  }

  Future<void> _loadStreak() async {
    final s = await StorageService().getStreak();
    if (mounted) {
      setState(() {
        _streak = s;
      });
    }
  }

  Future<void> _onCustomGamePressed(BuildContext context, SettingsProvider settings) async {
    AudioService().playClick();
    final scores = await StorageService().loadHighScores();
    bool isUnlocked = (scores['infinite'] ?? 0) >= 500 ||
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
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.white,
            title: Text(settings.getText('locked_title'), style: const TextStyle(color: AppColors.primaryPurple, fontFamily: 'Monogram', fontSize: 24)),
            content: Text(settings.getText('locked_msg')),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(settings.getText('ok')))]
          )
        );
      }
    }
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
        child: Stack(
          children: [
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.withOpacity(0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2)
                    )
                  ]
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/flame.png',
                      width: 24,
                      height: 24
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$_streak",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Monogram'
                      )
                    ),
                  ],
                ),
              ),
            ),

            Center(
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
                        ).then((_) => _loadStreak());
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
          ],
        ),
      ),
    );
  }
}