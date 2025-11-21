enum Difficulty {
  easy,
  medium,
  hard
}

extension DifficultyExtension on Difficulty {
  String get filename {
    switch (this) {
      case Difficulty.easy:
        return 'easy_words.json';
      case Difficulty.medium:
        return 'medium_words.json';
      case Difficulty.hard:
        return 'hard_words.json';
    }
  }

  String get name {
    return toString().split('.').last.toUpperCase();
  }
}