import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../services/audio_service.dart';
import '../services/ad_service.dart'; 
import '../widgets/custom_button.dart';
import '../widgets/banner_ad_widget.dart'; 
import 'main_menu.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override 
  Widget build(BuildContext context) {
    final p = context.read<GameProvider>();
    final s = context.read<SettingsProvider>();

    
    WidgetsBinding.instance.addPostFrameCallback((_) {
       AdService().showInterstitialIfReady();
    });

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
              Text(s.getText('game_over'), style: TextStyle(fontSize: 48, fontFamily: s.fontFamily, color: AppColors.primaryPurple, fontWeight: FontWeight.bold)).animate().scale(),
              const SizedBox(height: 40),
              Container(padding: const EdgeInsets.all(30), decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)]), child: Column(children: [
                Text(s.getText('score'), style: const TextStyle(fontSize: 22, color: Colors.grey)),
                Text("${p.score}", style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: AppColors.secondaryTeal)).animate().fadeIn(),
                const Divider(height: 30),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [ 
                  _stat(s.getText('correct'), "${p.correctCount}", AppColors.correctGreen, 'correct.png'), 
                  _stat(s.getText('wrong'), "${p.wrongCount}", AppColors.wrongRed, 'wrong.png') 
                ])
              ])),
              const SizedBox(height: 50),
              CustomButton(text: s.getText('main_menu'), onPressed: () { AudioService().playClick(); Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainMenu()), (r) => false); })
            ]
          )
        )
      )
    );
  }
  Widget _stat(String l, String v, Color c, String i) => Column(children: [ Image.asset('assets/icons/$i', width: 32), const SizedBox(height: 5), Text(v, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: c)), Text(l, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)) ]);
}