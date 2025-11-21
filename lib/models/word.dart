class Word {
  final String word;
  final String meaning;

  Word({required this.word, required this.meaning});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'] ?? '',
      meaning: json['meaning'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'word': word, 'meaning': meaning};
}