import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../core/difficulty.dart';
import '../core/enums.dart';
import '../models/word.dart';
import '../services/storage_service.dart';
import '../services/vibration_service.dart';

class GameProvider extends ChangeNotifier {
  
  GameMode activeMode = GameMode.classic;
  Difficulty currentDifficulty = Difficulty.easy;
  bool _isCustomRun = false; 
  
  
  List<Word> _words = [];
  List<String> _distractorPool = [];
  
  
  int _currentIndex = 0;
  Word? currentQuestion;
  List<String> currentOptions = [];
  
  int score = 0;
  int correctCount = 0;
  int wrongCount = 0;
  int lives = 3;

  
  int timeAttackDuration = 60; 
  int targetWordCount = 25;
  final double _defaultQuestionTime = 4.0;

  
  Timer? _timer;
  double timeLeft = 0;
  double totalTime = 0;
  bool isTimerRunning = false;

  
  bool showFeedback = false;
  bool isProcessing = false;
  bool isGameOver = false;
  String? lastSelected;
  String? lastCorrect;
  
  
  int scoreDelta = 0; 
  int scoreChangeTrigger = 0;

  final StorageService _storage = StorageService();

  double get timeFraction => totalTime > 0 ? timeLeft / totalTime : 0;

  
  
  
  Future<void> startGame({
    required GameMode mode, 
    required Difficulty difficulty,
    required bool useCustomWords,
    int? duration,
    int? count
  }) async {
    _timer?.cancel();
    
    
    
    
    
    activeMode = mode;
    currentDifficulty = difficulty;
    _isCustomRun = useCustomWords;
    
    score = 0;
    correctCount = 0;
    wrongCount = 0;
    _currentIndex = 0;
    isGameOver = false;
    isProcessing = false;
    showFeedback = false;
    isTimerRunning = false;

    
    if (mode == GameMode.timeAttack) {
      timeAttackDuration = duration ?? 60;
      lives = 9999; 
      totalTime = timeAttackDuration.toDouble();
      timeLeft = totalTime;
    } else if (mode == GameMode.wordCount) {
      targetWordCount = count ?? 25;
      lives = 3;
      totalTime = 0;
    } else {
      
      lives = 3;
      totalTime = _defaultQuestionTime;
    }

    await _loadWords(useCustomWords);
    
    if (_words.isEmpty) {
      isGameOver = true;
      notifyListeners();
      return;
    }

    nextRound();
  }

  Future<void> _loadWords(bool useCustom) async {
    final jsonString = await rootBundle.loadString('assets/data/${currentDifficulty.filename}');
    final List<dynamic> jsonList = json.decode(jsonString);
    List<Word> systemWords = jsonList.map((e) => Word.fromJson(e)).toList();
    
    if (useCustom) {
      List<Word> customWords = await _storage.loadCustomWords();
      
      _words = List.from(customWords);
      
      
      _distractorPool = [
        ...customWords.map((e) => e.meaning),
        ...systemWords.map((e) => e.meaning)
      ];
    } else {
      
      _words = List.from(systemWords);
      _distractorPool = systemWords.map((e) => e.meaning).toList();
    }
    _words.shuffle();
  }

  
  
  
  void nextRound() {
    if (isGameOver) return;

    
    if (activeMode == GameMode.wordCount && correctCount >= targetWordCount) {
      finishGame();
      return;
    }

    
    if (_currentIndex >= _words.length) {
      
      if (activeMode == GameMode.wordCount || _isCustomRun) {
         finishGame();
         return;
      }
      
      _words.shuffle();
      _currentIndex = 0;
    }

    isProcessing = false;
    showFeedback = false;
    
    currentQuestion = _words[_currentIndex];
    _currentIndex++;
    
    _prepareOptions();
    
    if (activeMode == GameMode.timeAttack) {
      if (!isTimerRunning) _startGlobalTimer();
    } else if (activeMode != GameMode.wordCount) {
      _startQuestionTimer();
    }
    
    notifyListeners();
  }

  void _prepareOptions() {
    if (currentQuestion == null) return;
    
    final distractors = _distractorPool.where((m) => m != currentQuestion!.meaning).toList();
    
    int takeCount = 3;
    if (distractors.length < 3) takeCount = distractors.length;
    
    distractors.shuffle();
    final options = [currentQuestion!.meaning, ...distractors.take(takeCount)];
    options.shuffle();
    currentOptions = options;
  }

  
  
  
  void _startQuestionTimer() {
    _timer?.cancel();
    timeLeft = _defaultQuestionTime;
    totalTime = _defaultQuestionTime;
    
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (isGameOver || isProcessing) {
        timer.cancel(); return;
      }
      if (timeLeft <= 0) {
        _handleWrong(timeout: true);
      } else {
        timeLeft -= 0.1;
        notifyListeners();
      }
    });
  }

  void _startGlobalTimer() {
    isTimerRunning = true;
    _timer?.cancel();
    
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (isGameOver) {
        timer.cancel(); return;
      }
      if (timeLeft <= 0) {
        finishGame();
      } else {
        timeLeft -= 0.1;
        notifyListeners();
      }
    });
  }

  
  
  
  void submitAnswer(String answer) {
    if (isProcessing) return;
    if (activeMode != GameMode.timeAttack) _timer?.cancel();

    isProcessing = true;
    lastSelected = answer;
    lastCorrect = currentQuestion?.meaning;
    showFeedback = true;

    if (answer == currentQuestion!.meaning) {
      correctCount++;
      _updateScore(10);
      notifyListeners();
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!isGameOver) nextRound();
      });
    } else {
      _handleWrong(timeout: false);
    }
  }

  void _handleWrong({required bool timeout}) {
    if (activeMode != GameMode.timeAttack) _timer?.cancel();
    
    isProcessing = true;
    if (timeout) {
      lastSelected = "TIMEOUT";
      lastCorrect = currentQuestion?.meaning;
      showFeedback = true;
    }

    wrongCount++;
    _updateScore(-10);
    VibrationService().vibrateError();
    
    if (activeMode != GameMode.timeAttack) {
      lives--;
      notifyListeners();
      if (lives <= 0) {
        Future.delayed(const Duration(milliseconds: 1500), () => finishGame());
        return;
      }
    }
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!isGameOver) nextRound();
    });
    
    notifyListeners();
  }

  void _updateScore(int delta) {
    score += delta;
    if (score < 0) score = 0;
    scoreDelta = delta;
    scoreChangeTrigger++;
  }

  void pauseGame() { _timer?.cancel(); isTimerRunning = false; notifyListeners(); }

  void resumeGame() {
    if (isGameOver) return;
    if (activeMode == GameMode.timeAttack) {
       _startGlobalTimer();
    } else if (activeMode != GameMode.wordCount) {
       _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          if (timeLeft <= 0) _handleWrong(timeout: true);
          else { timeLeft -= 0.1; notifyListeners(); }
       });
    }
    notifyListeners();
  }

  Future<void> finishGame() async {
    _timer?.cancel();
    isGameOver = true;
    
    if (score > 0 || correctCount > 0) {
       
       String modeKey = activeMode.toString().split('.').last;
       if (_isCustomRun) {
         modeKey = "custom_$modeKey";
       }

       final entry = {
         "date": DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
         "score": score,
         "mode": modeKey,
         "correct": correctCount,
         "wrong": wrongCount,
         "difficulty": currentDifficulty.name
       };
       await _storage.saveHistoryEntry(entry);
    }
    notifyListeners();
  }
}