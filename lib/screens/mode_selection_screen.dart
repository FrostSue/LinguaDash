import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/enums.dart';
import '../core/difficulty.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../widgets/banner_ad_widget.dart';
import 'game_screen.dart';
import 'custom_words_screen.dart';

class ModeSelectionScreen extends StatefulWidget {
  final bool isCustom;
  const ModeSelectionScreen({super.key, this.isCustom = false});

  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  Map<String, int> _scores = {};

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final s = await StorageService().loadHighScores();
    setState(() => _scores = s);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      
      
      bottomNavigationBar: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: BannerAdWidget(),
        ),
      ),
      
      appBar: AppBar(
        title: Text(
          widget.isCustom ? settings.getText('custom') : settings.getText('select_mode'),
          style: TextStyle(
            fontFamily: settings.fontFamily,
            color: AppColors.primaryPurple,
            fontSize: 28
          )
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryPurple),
        actions: [
          if (widget.isCustom)
            IconButton(
              icon: const Icon(Icons.edit_note, size: 35),
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const CustomWordsScreen())
              )
            )
        ],
      ),
      
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (widget.isCustom)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                settings.getText('custom_desc'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontSize: 16,
                  fontFamily: settings.fontFamily
                )
              ),
            ),

          _buildCard(
            title: settings.getText('classic'),
            icon: Icons.all_inclusive,
            color: Colors.blue,
            modeKey: "classic",
            onTap: () => _startFlow(context, GameMode.classic)
          ),

          _buildCard(
            title: settings.getText('time_attack'),
            icon: Icons.timer,
            color: Colors.red,
            modeKey: "timeAttack",
            onTap: () => _timeFlow(context, settings)
          ),

          _buildCard(
            title: settings.getText('word_count'),
            icon: Icons.list_alt,
            color: Colors.purple,
            modeKey: "wordCount",
            onTap: () => _countFlow(context, settings)
          ),

          Opacity(
            opacity: 0.5,
            child: _buildCard(
              title: "${settings.getText('levels')} (${settings.getText('coming_soon')})",
              icon: Icons.lock,
              color: Colors.grey,
              modeKey: "levels",
              onTap: () {}
            )
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color color,
    required String modeKey,
    required VoidCallback onTap
  }) {
    int highScore = _scores[modeKey] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryPurple.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: const Offset(0, 3))
        ]
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle
          ),
          child: Icon(icon, color: color, size: 30)
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Monogram')
        ),
        subtitle: highScore > 0 
          ? Text(
              "${context.read<SettingsProvider>().getText('best_score')}$highScore", 
              style: TextStyle(color: color, fontWeight: FontWeight.bold)
            ) 
          : null,
        onTap: () {
          AudioService().playClick();
          onTap();
        },
      ),
    );
  }

  

  void _timeFlow(BuildContext c, SettingsProvider s) {
    _showDialog(
      c, 
      s.getText('select_duration'), 
      [30, 60, 120, 180], 
      (val) => _difficultyFlow(c, s, GameMode.timeAttack, d: val)
    );
  }

  void _countFlow(BuildContext c, SettingsProvider s) {
    _showDialog(
      c, 
      s.getText('select_count'), 
      [25, 50, 75, 100], 
      (val) => _difficultyFlow(c, s, GameMode.wordCount, n: val)
    );
  }

  void _startFlow(BuildContext c, GameMode m) {
    final s = c.read<SettingsProvider>();
    _difficultyFlow(c, s, m);
  }

  void _difficultyFlow(BuildContext c, SettingsProvider s, GameMode m, {int? d, int? n}) {
    showDialog(
      context: c,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        title: Text(
          s.getText('select_difficulty'),
          style: const TextStyle(fontFamily: 'Monogram', fontSize: 24)
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _diffTile(ctx, s.getText('easy'), Difficulty.easy, () => _launch(c, m, Difficulty.easy, d, n)),
            _diffTile(ctx, s.getText('medium'), Difficulty.medium, () => _launch(c, m, Difficulty.medium, d, n)),
            _diffTile(ctx, s.getText('hard'), Difficulty.hard, () => _launch(c, m, Difficulty.hard, d, n)),
          ]
        ),
      )
    );
  }

  Widget _diffTile(BuildContext c, String txt, Difficulty diff, VoidCallback tap) {
    Color col = diff == Difficulty.easy 
        ? Colors.green 
        : diff == Difficulty.medium 
            ? Colors.orange 
            : Colors.red;
            
    return ListTile(
      title: Text(
        txt,
        style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 20)
      ),
      onTap: () {
        Navigator.pop(c);
        tap();
      }
    );
  }

  Future<void> _launch(BuildContext c, GameMode m, Difficulty diff, int? d, int? n) async {
    if (widget.isCustom) {
      final w = await StorageService().loadCustomWords();
      if (w.isEmpty) {
        ScaffoldMessenger.of(c).showSnackBar(
          SnackBar(
            content: Text(c.read<SettingsProvider>().getText('no_custom_words')),
            backgroundColor: AppColors.wrongRed
          )
        );
        return;
      }
    }
    c.read<GameProvider>().startGame(
      mode: widget.isCustom ? GameMode.custom : m,
      difficulty: diff,
      useCustomWords: widget.isCustom,
      duration: d,
      count: n
    );
    Navigator.push(c, MaterialPageRoute(builder: (_) => const GameScreen()));
  }

  void _showDialog(BuildContext ctx, String t, List<int> v, Function(int) sel) {
    final ctrl = TextEditingController();
    final s = ctx.read<SettingsProvider>();
    
    showDialog(
      context: ctx,
      builder: (d) => AlertDialog(
        backgroundColor: AppColors.white,
        title: Text(t, style: const TextStyle(fontFamily: 'Monogram', fontSize: 24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...v.map((val) => ListTile(
              title: Text("$val", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              onTap: () { Navigator.pop(d); sel(val); },
            )),
            const Divider(),
            ListTile(
              title: Text(
                s.getText('other'),
                style: const TextStyle(color: AppColors.secondaryTeal, fontWeight: FontWeight.bold)
              ),
              onTap: () {
                Navigator.pop(d);
                showDialog(
                  context: ctx,
                  builder: (dx) => AlertDialog(
                    title: Text(s.getText('enter_value')),
                    content: TextField(
                      controller: ctrl,
                      keyboardType: TextInputType.number
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dx),
                        child: Text(s.getText('cancel'))
                      ),
                      ElevatedButton(
                        onPressed: () {
                          int? i = int.tryParse(ctrl.text);
                          if(i != null && i > 0) {
                            Navigator.pop(dx);
                            sel(i);
                          }
                        },
                        child: Text(s.getText('ok'))
                      )
                    ]
                  )
                );
              }
            )
          ]
        )
      )
    );
  }
}