import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../providers/settings_provider.dart';
import '../services/audio_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/banner_ad_widget.dart'; 
import 'mode_selection_screen.dart';
import 'settings_screen.dart';
import 'history_screen.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});
  @override Widget build(BuildContext context) {
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
                Text("LinguaDash", style: TextStyle(fontSize: 60, color: AppColors.primaryPurple, fontFamily: s.fontFamily)),
                const SizedBox(height: 50),
                CustomButton(text: s.getText('play'), color: AppColors.correctGreen, height: 70, fontSize: 32, onPressed: () { AudioService().playClick(); Navigator.push(context, MaterialPageRoute(builder: (_) => const ModeSelectionScreen())); }),
                const SizedBox(height: 15),
                CustomButton(text: s.getText('custom'), color: Colors.orange, onPressed: () { AudioService().playClick(); Navigator.push(context, MaterialPageRoute(builder: (_) => const ModeSelectionScreen(isCustom: true))); }),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: CustomButton(text: s.getText('settings'), onPressed: () { AudioService().playClick(); Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())); })),
                  const SizedBox(width: 10),
                  Expanded(child: CustomButton(text: s.getText('history'), color: AppColors.secondaryTeal, onPressed: () { AudioService().playClick(); Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())); })),
                ])
              ]
            ),
          ),
        ),
      ),
    );
  }
}