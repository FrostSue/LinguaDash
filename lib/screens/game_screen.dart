import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants.dart';
import '../core/enums.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../services/audio_service.dart';
import '../widgets/banner_ad_widget.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  
  AnimationController? _animController;
  int _lastScoreTrigger = 0;
  bool _showScoreAnim = false;
  int _scoreDelta = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _animController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<GameProvider>();
    final s = context.watch<SettingsProvider>();

    
    if (p.scoreChangeTrigger != _lastScoreTrigger) {
      _lastScoreTrigger = p.scoreChangeTrigger;
      _scoreDelta = p.scoreDelta;
      _showScoreAnim = true;
      _animController?.forward(from: 0).then((_) {
        if (mounted) setState(() => _showScoreAnim = false);
      });
    }

    
    if (p.isGameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResultScreen())
        );
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      
      
      bottomNavigationBar: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: BannerAdWidget(),
        ),
      ),
      
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.pause_circle_filled, size: 42, color: AppColors.primaryPurple),
          onPressed: () {
            p.pauseGame();
            _showPauseDialog(context, p, s);
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            _buildTopInfo(p),
            const SizedBox(width: 15),
            
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryPurple.withOpacity(0.2))
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  
                  Text(
                    "${s.getText('score')}: ${p.score}",
                    style: const TextStyle(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    )
                  ),
                  
                  if (_showScoreAnim)
                    Positioned(
                      right: -10, top: -25,
                      child: Text(
                        _scoreDelta > 0 ? "+$_scoreDelta" : "$_scoreDelta",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _scoreDelta > 0 ? AppColors.correctGreen : AppColors.wrongRed,
                          shadows: [Shadow(blurRadius: 2, color: Colors.white, offset: const Offset(1, 1))]
                        )
                      ).animate(controller: _animController).moveY(begin: 0, end: -20).fadeOut()
                    )
                ],
              ),
            )
          ],
        )
      ),

      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              
              if (p.activeMode != GameMode.timeAttack && p.activeMode != GameMode.wordCount)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: LinearProgressIndicator(
                    value: p.timeFraction,
                    minHeight: 12,
                    color: p.timeFraction > 0.3 ? AppColors.secondaryTeal : AppColors.wrongRed,
                    backgroundColor: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              
              
              
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.primaryPurple, width: 2),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            p.currentQuestion?.word.toUpperCase() ?? "...",
                            style: TextStyle(
                              fontSize: 50, 
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple,
                              fontFamily: s.fontFamily
                            )
                          ),
                        ),
                      ),
                      
                      
                      if (p.showFeedback && p.lastSelected != p.lastCorrect)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "${s.getText('correct')}: ${p.lastCorrect}",
                              style: const TextStyle(
                                color: AppColors.secondaryTeal,
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                              )
                            ).animate().fadeIn(),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              
              
              
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: p.currentOptions.map((option) => 
                    _buildFlexibleButton(context, p, option)
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  

  Widget _buildTopInfo(GameProvider p) {
    if (p.activeMode == GameMode.timeAttack) {
      return Text(
        "${p.timeLeft.toInt()}s",
        style: const TextStyle(color: AppColors.wrongRed, fontSize: 28, fontWeight: FontWeight.bold)
      );
    }
    return Row(
      children: List.generate(3, (i) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Image.asset(
          i < p.lives ? 'assets/icons/heart.png' : 'assets/icons/heart_empty.png',
          width: 28
        ).animate(target: i < p.lives ? 0 : 1).shake()
      ))
    );
  }

  
  Widget _buildFlexibleButton(BuildContext context, GameProvider p, String option) {
    Color btnColor = AppColors.primaryPurple;
    Widget? icon;

    if (p.showFeedback) {
      if (option == p.lastCorrect) {
        btnColor = AppColors.correctGreen;
        icon = Image.asset('assets/icons/correct.png', height: 22);
      } else if (option == p.lastSelected) {
        btnColor = AppColors.wrongRed;
        icon = Image.asset('assets/icons/wrong.png', height: 22);
      } else {
        btnColor = Colors.grey.shade400;
      }
    }

    
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(
          width: double.infinity,
          height: 65, 
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              padding: const EdgeInsets.symmetric(horizontal: 10)
            ),
            onPressed: p.showFeedback ? null : () {
              AudioService().playClick();
              p.submitAnswer(option);
              if (option == p.currentQuestion?.meaning) {
                AudioService().playCorrect();
              } else {
                AudioService().playWrong();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[icon, const SizedBox(width: 8)],
                
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      option.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                )
              ]
            )
          ),
        ),
      ),
    );
  }

  void _showPauseDialog(BuildContext c, GameProvider p, dynamic s) {
    showDialog(
      context: c,
      barrierDismissible: false,
      builder: (x) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: Text(
            s.getText('paused'),
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryPurple, fontSize: 26)
          )
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.correctGreen),
                onPressed: () { Navigator.pop(x); p.resumeGame(); },
                child: Text(s.getText('resume'), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.wrongRed),
                onPressed: () { Navigator.pop(x); p.finishGame(); },
                child: Text(s.getText('finish'), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
              ),
            )
          ]
        ),
      )
    );
  }
}