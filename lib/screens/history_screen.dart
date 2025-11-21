import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../services/storage_service.dart';
import '../providers/settings_provider.dart';
import '../widgets/banner_ad_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await StorageService().loadHistory();
    setState(() => _history = data);
  }

  
  String _getTranslatedMode(String rawMode, SettingsProvider s) {
    switch (rawMode) {
      case 'timeAttack': return s.getText('time_attack');
      case 'wordCount': return s.getText('word_count');
      case 'classic': return s.getText('classic');
      case 'custom': return s.getText('custom');
      default: return rawMode.toUpperCase();
    }
  }

  
  String _getTranslatedDiff(String? rawDiff, SettingsProvider s) {
    if (rawDiff == null) return "";
    return s.getText(rawDiff.toLowerCase());
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
          settings.getText('history'), 
          style: TextStyle(color: AppColors.primaryPurple, fontFamily: settings.fontFamily)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryPurple),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await StorageService().clearHistory();
              _load();
            }
          )
        ]
      ),
      
      body: _history.isEmpty
        ? Center(
            child: Text(
              settings.getText('no_history'), 
              style: TextStyle(
                fontFamily: settings.fontFamily, 
                fontSize: 18, 
                color: AppColors.primaryPurple
              )
            )
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _history.length,
            itemBuilder: (context, index) {
              final item = _history[index];
              
              
              String modeText = _getTranslatedMode(item['mode'], settings);
              String diffText = _getTranslatedDiff(item['difficulty'], settings);
              String fullTitle = diffText.isNotEmpty ? "$modeText • $diffText" : modeText;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                color: AppColors.cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            fullTitle, 
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 16, 
                              color: AppColors.primaryPurple
                            )
                          ),
                          Text(
                            item['date'], 
                            style: TextStyle(color: Colors.grey[600], fontSize: 12)
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${settings.getText('score')}: ${item['score']}", 
                            style: const TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 18, 
                              color: AppColors.secondaryTeal
                            )
                          ),
                          Row(
                            children: [
                              Image.asset('assets/icons/correct.png', width: 20),
                              const SizedBox(width: 5),
                              Text("${item['correct']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              
                              const SizedBox(width: 15),
                              
                              Image.asset('assets/icons/wrong.png', width: 20),
                              const SizedBox(width: 5),
                              Text("${item['wrong']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            ]
                          )
                        ]
                      )
                    ]
                  )
                )
              ).animate().fadeIn(delay: (index * 50).ms).slideX();
            }
          )
    );
  }
}