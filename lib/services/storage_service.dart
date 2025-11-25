import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Future<String> _getFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('daily_streak') ?? 0;
  }

  Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDateStr = prefs.getString('last_played_date');
    int currentStreak = prefs.getInt('daily_streak') ?? 0;
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";

    if (lastDateStr == todayStr) {
      return;
    }

    if (lastDateStr != null) {
      final lastDate = DateTime.parse(lastDateStr);
      final difference = now.difference(lastDate).inDays;

      if (difference == 1) {
        currentStreak++;
      } else {
        currentStreak = 1;
      }
    } else {
      currentStreak = 1;
    }

    await prefs.setString('last_played_date', todayStr);
    await prefs.setInt('daily_streak', currentStreak);
  }

  Future<void> saveHistoryEntry(Map<String, dynamic> entry) async {
    final history = await loadHistory();
    history.insert(0, entry);
    final path = await _getFilePath('history.json');
    final file = File(path);
    await file.writeAsString(json.encode(history));
    await _checkAndSaveHighScore(entry['mode'], entry['score']);
    await updateStreak();
  }
  Future<List<dynamic>> loadHistory() async {
    try {
      final path = await _getFilePath('history.json');
      final file = File(path);
      return await file.exists() ? json.decode(await file.readAsString()) : [];
    } catch (e) { return []; }
  }

  Future<void> _checkAndSaveHighScore(String mode, int score) async {
    final highScores = await loadHighScores();
    final currentHigh = highScores[mode] ?? 0;
    if (score > currentHigh) {
      highScores[mode] = score;
      final path = await _getFilePath('high_scores.json');
      await File(path).writeAsString(json.encode(highScores));
    }
  }

  Future<Map<String, int>> loadHighScores() async {
    try {
      final path = await _getFilePath('high_scores.json');
      final file = File(path);
      return await file.exists() ? Map<String, int>.from(json.decode(await file.readAsString())) : {};
    } catch (e) { return {}; }
  }

  Future<List<Word>> loadCustomWords() async {
    try {
      final path = await _getFilePath('custom_words.json');
      final file = File(path);
      if (!await file.exists()) return [];
      final List<dynamic> list = json.decode(await file.readAsString());
      return list.map((e) => Word.fromJson(e)).toList();
    } catch (e) { return []; }
  }

  Future<void> addCustomWord(Word word) async {
    final words = await loadCustomWords();
    words.add(word);
    final path = await _getFilePath('custom_words.json');
    await File(path).writeAsString(json.encode(words.map((w) => w.toJson()).toList()));
  }

  Future<void> deleteCustomWord(int index) async {
    final words = await loadCustomWords();
    if (index >= 0 && index < words.length) {
      words.removeAt(index);
      final path = await _getFilePath('custom_words.json');
      await File(path).writeAsString(json.encode(words.map((w) => w.toJson()).toList()));
    }
  }

  Future<void> clearHistory() async {
    final path = await _getFilePath('history.json');
    final file = File(path);
    if (await file.exists()) await file.delete();
  }
}