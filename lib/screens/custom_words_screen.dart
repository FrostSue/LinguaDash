import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/word.dart';
import '../services/storage_service.dart';
import '../providers/settings_provider.dart';
import '../widgets/banner_ad_widget.dart';

class CustomWordsScreen extends StatefulWidget {
  const CustomWordsScreen({super.key});
  @override 
  State<CustomWordsScreen> createState() => _CustomWordsScreenState();
}

class _CustomWordsScreenState extends State<CustomWordsScreen> {
  final _wordController = TextEditingController(); 
  final _meaningController = TextEditingController();
  List<Word> _wordList = [];

  @override 
  void initState() { 
    super.initState(); 
    _loadWords(); 
  }
  
  Future<void> _loadWords() async { 
    final list = await StorageService().loadCustomWords(); 
    setState(() => _wordList = list); 
  }
  
  Future<void> _addWord() async { 
    if (_wordController.text.isEmpty || _meaningController.text.isEmpty) return; 
    
    await StorageService().addCustomWord(
      Word(
        word: _wordController.text.trim(), 
        meaning: _meaningController.text.trim()
      )
    ); 
    
    _wordController.clear(); 
    _meaningController.clear(); 
    FocusManager.instance.primaryFocus?.unfocus(); 
    _loadWords(); 
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
      
      appBar: AppBar(
        title: Text(
          s.getText('edit_words'), 
          style: TextStyle(color: AppColors.primaryPurple, fontFamily: s.fontFamily)
        ), 
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: const IconThemeData(color: AppColors.primaryPurple)
      ),
      
      body: Column(
        children: [
          
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [ 
                TextField(
                  controller: _wordController, 
                  decoration: InputDecoration(
                    labelText: s.getText('word_hint'), 
                    border: const OutlineInputBorder()
                  )
                ), 
                const SizedBox(height: 10),
                TextField(
                  controller: _meaningController, 
                  decoration: InputDecoration(
                    labelText: s.getText('meaning_hint'), 
                    border: const OutlineInputBorder()
                  )
                ), 
                const SizedBox(height: 10), 
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.correctGreen, 
                      padding: const EdgeInsets.all(15)
                    ), 
                    onPressed: _addWord, 
                    child: Text(
                      s.getText('add_btn'), 
                      style: const TextStyle(color: Colors.white, fontSize: 18)
                    )
                  ),
                ) 
              ]
            )
          ),
          
          
          Expanded(
            child: ListView.builder(
              itemCount: _wordList.length, 
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListTile(
                  title: Text(
                    _wordList[index].word, 
                    style: const TextStyle(fontWeight: FontWeight.bold)
                  ), 
                  subtitle: Text(_wordList[index].meaning), 
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red), 
                    onPressed: () async { 
                      await StorageService().deleteCustomWord(index); 
                      _loadWords(); 
                    }
                  )
                )
              )
            )
          )
        ]
      )
    );
  }
}