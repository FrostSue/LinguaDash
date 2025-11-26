import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants.dart';
import '../core/enums.dart';
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
  
  bool _isOwlBubbleVisible = false;
  String _currentOwlTip = "";
  Timer? _bubbleTimer;
  
  Key _owlAnimationKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _loadStreak();
  }

  @override
  void dispose() {
    _bubbleTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadStreak() async {
    final s = await StorageService().getStreak();
    if (mounted) {
      setState(() {
        _streak = s;
      });
    }
  }

  void _onOwlTap(SettingsProvider settings) {
    AudioService().playOwl();
    
    String langCode = settings.language == AppLanguage.turkish ? 'tr' : 'en';
    List<String> tips = AppTexts.owlTips[langCode] ?? [];
    String randomTip = tips[Random().nextInt(tips.length)];

    _bubbleTimer?.cancel();

    setState(() {
      _currentOwlTip = randomTip;
      _isOwlBubbleVisible = true;
      
      _owlAnimationKey = UniqueKey();
    });
    
    _bubbleTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isOwlBubbleVisible = false;
        });
      }
    });
  }

  Future<void> _onCustomGamePressed(BuildContext context, SettingsProvider settings) async {
    AudioService().playClick();
    final scores = await StorageService().loadHighScores();
    
    bool isUnlocked = (scores['classic'] ?? 0) >= 500 ||
                      (scores['timeAttack'] ?? 0) >= 500 ||
                      (scores['wordCount'] ?? 0) >= 500 ||
                      (scores['infinite'] ?? 0) >= 500;

    if (isUnlocked) {
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ModeSelectionScreen(isCustom: true)));
      }
    } else {
      if (context.mounted) _showLockedDialog(context, settings);
    }
  }

  void _showLockedDialog(BuildContext context, SettingsProvider s) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
            const Icon(Icons.lock, color: AppColors.wrongRed, size: 30),
            const SizedBox(width: 10),
            Text(s.getText('locked_title'), style: const TextStyle(color: AppColors.primaryPurple, fontFamily: 'Monogram', fontSize: 28, fontWeight: FontWeight.bold)),
        ]),
        content: Text(s.getText('locked_msg'), style: const TextStyle(fontSize: 18, height: 1.4, color: AppColors.black)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(s.getText('ok'), style: const TextStyle(color: AppColors.secondaryTeal, fontWeight: FontWeight.bold, fontSize: 18)))
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
        child: Stack(
          children: [
            Positioned(
              top: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.withOpacity(0.5), width: 2),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))
                      ]
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/icons/flame.png', width: 26, height: 26)
                            .animate(onPlay: (controller) => controller.repeat(reverse: true))
                            .scaleXY(begin: 1.0, end: 1.2, duration: 1000.ms),
                            
                        const SizedBox(width: 8),
                        
                        Text(
                          "$_streak",
                          style: const TextStyle(
                            color: Colors.orange, 
                            fontWeight: FontWeight.bold, 
                            fontSize: 22,
                            fontFamily: 'Monogram'
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 180,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none, 
                        children: [
                          GestureDetector(
                            onTap: () => _onOwlTap(s),
                            child: Image.asset('assets/icons/icon.png', width: 110)
                                .animate(target: _isOwlBubbleVisible ? 1 : 0)
                                .scaleXY(end: 1.2, duration: 100.ms, curve: Curves.easeOut)
                                .then()
                                .scaleXY(end: 1.0, duration: 100.ms, curve: Curves.bounceOut),
                          ),
                          
                          if (_isOwlBubbleVisible)
                            Positioned(
                              top: -40,
                              child: Container(
                                key: _owlAnimationKey, 
                                width: 240, 
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.primaryPurple, width: 2),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black26, blurRadius: 6, offset: const Offset(2, 4))
                                  ]
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _currentOwlTip,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppColors.primaryPurple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Icon(Icons.arrow_drop_down, color: AppColors.primaryPurple, size: 24)
                                  ],
                                ),
                              )
                              .animate()
                              .scale(duration: 400.ms, curve: Curves.elasticOut)
                              .shake(hz: 4, curve: Curves.easeInOut)
                              .fadeIn(),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    
                    Text(
                      s.getText('game_title'), 
                      style: TextStyle(fontSize: 60, color: AppColors.primaryPurple, fontFamily: s.fontFamily)
                    ),
                    
                    const SizedBox(height: 40),

                    CustomButton(
                      text: s.getText('play'),
                      color: AppColors.correctGreen,
                      height: 70,
                      fontSize: 32,
                      onPressed: () {
                        AudioService().playClick();
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ModeSelectionScreen())).then((_) => _loadStreak());
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
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
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
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
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