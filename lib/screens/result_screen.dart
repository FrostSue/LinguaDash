import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../services/audio_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/banner_ad_widget.dart';
import 'main_menu.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.read<GameProvider>();
    final s = context.read<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: BannerAdWidget(),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                s.getText('game_over'),
                style: TextStyle(
                  fontSize: 48,
                  fontFamily: s.fontFamily,
                  color: AppColors.primaryPurple,
                  fontWeight: FontWeight.bold
                )
              ).animate().scale(),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)]
                ),
                child: Column(
                  children: [
                    Text(
                      s.getText('score'),
                      style: const TextStyle(fontSize: 22, color: Colors.grey)
                    ),
                    Text(
                      "${p.score}",
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryTeal
                      )
                    ).animate().fadeIn(),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(
                          s.getText('correct'),
                          "${p.correctCount}",
                          AppColors.correctGreen,
                          'correct.png'
                        ),
                        _buildStat(
                          s.getText('wrong'),
                          "${p.wrongCount}",
                          AppColors.wrongRed,
                          'wrong.png'
                        )
                      ]
                    )
                  ]
                )
              ),
              const SizedBox(height: 30),
              TextButton.icon(
                onPressed: () {
                   String templateMsg = s.getText('share_msg');
                   String finalMsg = templateMsg.replaceAll('{score}', p.score.toString());
                   Share.share("$finalMsg\n\nhttps://play.google.com/store/apps/details?id=com.frostsue.linguadash");
                },
                icon: const Icon(Icons.share, color: AppColors.secondaryTeal, size: 28),
                label: Text(
                  s.getText('share_score'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryTeal
                  )
                )
              ),

              const SizedBox(height: 20),
              CustomButton(
                text: s.getText('main_menu'),
                onPressed: () {
                  AudioService().playClick();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainMenu()),
                    (r) => false
                  );
                }
              )
            ]
          )
        )
      )
    );
  }

  Widget _buildStat(String label, String value, Color color, String iconName) {
    return Column(
      children: [
        Image.asset('assets/icons/$iconName', width: 32),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)
        )
      ]
    );
  }
}