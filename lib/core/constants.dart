import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF5E6D3);
  static const Color primaryPurple = Color(0xFF4A2C40);
  static const Color secondaryTeal = Color(0xFF2E8B57);
  static const Color correctGreen = Color(0xFF228B22);
  static const Color wrongRed = Color(0xFFB22222);


  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A1A1A);
  static const Color cardColor = Color(0xFFFFFAF0);
}

class AppTexts {

  static const String privacyPolicyTr = """
GİZLİLİK POLİTİKASI
Son Güncelleme: 2025

1. Veri Toplama
LinguaDash, kişisel verilerinizi sunucularında saklamaz. Oyun ilerlemeniz ve özel kelimeleriniz yalnızca cihazınızda yerel olarak tutulur.

2. İzinler
Uygulama, oyun deneyimi için titreşim ve ses özelliklerini kullanır. Başka bir özel erişim talebi yoktur.

3. İletişim
Sorularınız için bize ulaşın butonunu kullanabilirsiniz.
""";

  static const String termsOfUseTr = """
KULLANIM KOŞULLARI
Son Güncelleme: 2025

1. Kabul
Oyunu indirerek ve oynayarak bu koşulları kabul etmiş sayılırsınız.

2. Kullanım
LinguaDash, dil öğrenme amaçlı eğlenceli bir araçtır. İçeriklerin doğruluğu konusunda azami özen gösterilse de garanti verilmez.

3. Değişiklikler
Geliştirici, oyunun özelliklerini dilediği zaman değiştirme hakkını saklı tutar.
""";

  static const String privacyPolicyEn = """
PRIVACY POLICY
Last Updated: 2025

1. Data Collection
LinguaDash does not store your personal data on servers. Your game progress and custom words are stored locally on your device.

2. Permissions
The app uses vibration and audio features for gameplay. No other special access is requested.

3. Contact
You can use the 'Contact Us' button for any questions.
""";

  static const String termsOfUseEn = """
TERMS OF USE
Last Updated: 2025

1. Acceptance
By downloading and playing the game, you agree to these terms.

2. Usage
LinguaDash is a fun tool for language learning. While every effort is made to ensure accuracy, it is not guaranteed.

3. Changes
The developer reserves the right to modify game features at any time.
""";

  static const Map<String, List<String>> owlTips = {
'tr': [
      // Motivasyon
      "Her gün 5 dakika ayırmak hafızanı uçurur! 🚀",
      "Hata yapmaktan korkma, öğrenmenin en iyi yolu bu! 🦉",
      "Bugün harika gidiyorsun, sakın durma! 🔥",
      "Serini bozmamak için yarın yine gel! 📅",
      "Bir dil, bir insan demektir. Devam et! 🌍",
      "Başarı, her gün tekrarlanan küçük çabaların toplamıdır. ✨",
      "Pes etmediğin sürece asla kaybetmezsin. 💪",
      
      // Oyun İpuçları
      "Zamana Karşı modunda panik yapma, derin nefes al. 🧘",
      "Klasik Modda canlarını idareli kullan! ❤️",
      "Özel Mod ile kendi sınavına hazırlanabilirsin. 📝",
      "500 puan topla, Özel Modun kilidini aç! 🔓",
      "Yanlışlarını 'Geçmiş' ekranından inceleyebilirsin. 📜",
      "Skorunu arkadaşlarınla paylaş, rekabet et! 🏆",
      
      // İngilizce Bilgileri & Eğlence
      "İngilizce'de en çok kullanılan kelime 'the'dır. 🤓",
      "Ben gece kușuyum ama sen erken uyu. 🌙",
      "Yeni kelimeleri sesli tekrar etmek akılda tutmayı kolaylaştırır. 🗣️",
      "Film izlerken altyazıları İngilizce yapmayı dene! 🎬",
      "Gözlerim üzerinizde, doğru şıkkı seç! 👀",
      "'Queue' kelimesi 'Q' gibi okunur, gerisi süs! 😂",
      "Kelime hazineni geliştirmek senin elinde.",
      "Hoo! Hoo! Sıradaki kelimeyi bilebilecek misin?",
    ],
    'en': [
      // Motivation
      "Just 5 minutes a day boosts your memory! 🚀",
      "Don't fear mistakes, it's the best way to learn! 🦉",
      "You're doing great today, keep going! 🔥",
      "Come back tomorrow to keep your streak alive! 📅",
      "A new language is a new life. Keep it up! 🌍",
      "Success is the sum of small efforts repeated daily. ✨",
      "You never lose unless you quit. 💪",
      
      // Game Tips
      "Don't panic in Time Attack, take a deep breath. 🧘",
      "Save your lives in Classic Mode! ❤️",
      "Use Custom Mode to study for your exams. 📝",
      "Score 500 points to unlock Custom Mode! 🔓",
      "Check your mistakes in the 'History' screen. 📜",
      "Share your score and challenge your friends! 🏆",
      
      // Facts & Fun
      "The most used word in English is 'the'. 🤓",
      "I'm a night owl, but you should sleep early. 🌙",
      "Repeating words out loud helps you remember them. 🗣️",
      "Try watching movies with English subtitles! 🎬",
      "I'm watching you, pick the right one! 👀",
      "'Queue' is just 'Q' followed by four silent vowels! 😂",
      "Expanding your vocabulary is in your hands.",
      "Hoo! Hoo! Can you guess the next word?",
    ]
  };

  static Map<String, Map<String, String>> translations = {
    'tr': {
      'game_title': 'LinguaDash',
      'select_mode': 'MOD SEÇ',
      'play': 'OYNA',
      'settings': 'AYARLAR',
      'history': 'OYUN GEÇMIŞI',
      'main_menu': 'ANA MENÜ',
      'quit': 'ÇIKIŞ',
      'loading': 'Yükleniyor...',
      'score': 'Puan',
      'game_over': 'OYUN BITTI',
      'resume': 'DEVAM ET',
      'finish': 'BITIR',
      'classic': 'Klasik Mod',
      'time_attack': 'Zamana Karşı',
      'word_count': 'Kelime Sayısı',
      'levels': 'Seviyeler',
      'custom': 'ÖZEL OYUN',
      'coming_soon': 'Yakında',
      'save_back': 'KAYDET & ÇIK',
      'sound': 'Ses',
      'vibration': 'Titreşim',
      'language': 'Dil',
      'font': 'Yazı Tipi',
      'select_duration': 'Süre Seç (Saniye)',
      'select_difficulty': 'Zorluk Seç',
      'easy': 'Kolay',
      'medium': 'Orta',
      'hard': 'Zor',
      'select_count': 'Kelime Sayısı Seç',
      'best_score': 'En Yüksek Skor: ',
      'edit_words': 'Kelimeleri Düzenle',
      'custom_desc': 'Kendi kelimelerinle oyna! Eklemek için sağ üstteki ikona tıkla.',
      'correct': 'Doğru',
      'wrong': 'Yanlış',
      'no_custom_words': 'Kelime havuzu boş! Lütfen kelime ekleyin.',
      'no_history': 'Henüz oyun geçmişi yok.',
      'add_word_title': 'Kelime Ekle',
      'word_hint': 'Kelime (Örn: Apple)',
      'meaning_hint': 'Anlamı (Örn: Elma)',
      'add_btn': 'EKLE',
      'paused': 'DURAKLATILDI',
      'other': 'Diğer...',
      'enter_value': 'Değer Girin',
      'cancel': 'İptal',
      'ok': 'Tamam',
      'max_input_error': 'Maksimum değer 300 olabilir!',
      'contact_us': 'Bize Ulaşın',
      'github_repo': 'GitHub Deposu',
      'privacy_policy': 'Gizlilik Politikası',
      'terms_of_use': 'Kullanım Koşulları',
      'developer': 'Geliştirici',
      'version': 'Sürüm 1.0.0',
      'mail_subject': 'LinguaDash Destek',
      'mail_error': 'Mail uygulaması bulunamadı.',
      'locked_title': 'Kilitli!',
      'locked_msg': 'Özel Modu açmak için normal modların birinde en az 500 puan yapmalısın.',
      'share_score': 'Skoru Paylaş',
      'share_msg': 'LinguaDash\'te {score} puan yaptım! Beni geçebilir misin? 😎',
      'streak_label': 'SERi'
    },
    'en': {
      'game_title': 'LinguaDash',
      'select_mode': 'SELECT MODE',
      'play': 'PLAY',
      'settings': 'SETTINGS',
      'history': 'GAME HISTORY',
      'main_menu': 'MAIN MENU',
      'quit': 'QUIT',
      'loading': 'Loading...',
      'score': 'Score',
      'game_over': 'GAME OVER',
      'resume': 'RESUME',
      'finish': 'FINISH',
      'classic': 'Classic Mode',
      'time_attack': 'Time Attack',
      'word_count': 'Word Count',
      'levels': 'Levels',
      'custom': 'CUSTOM GAME',
      'coming_soon': 'Coming Soon',
      'save_back': 'SAVE & BACK',
      'sound': 'Sound',
      'vibration': 'Vibration',
      'language': 'Language',
      'font': 'Font',
      'select_duration': 'Select Duration (Sec)',
      'select_count': 'Select Word Count',
      'select_difficulty': 'Select Difficulty',
      'easy': 'Easy',
      'medium': 'Medium',
      'hard': 'Hard',
      'best_score': 'Best Score: ',
      'edit_words': 'Edit Words',
      'custom_desc': 'Play with your own words! Click the top right icon to add words.',
      'correct': 'Correct',
      'wrong': 'Wrong',
      'no_custom_words': 'Word pool is empty! Please add words.',
      'no_history': 'No game history yet.',
      'add_word_title': 'Add Word',
      'word_hint': 'Word (e.g. Apple)',
      'meaning_hint': 'Meaning (e.g. Elma)',
      'add_btn': 'ADD',
      'paused': 'PAUSED',
      'other': 'Other...',
      'enter_value': 'Enter Value',
      'cancel': 'Cancel',
      'ok': 'OK',
      'max_input_error': 'Maximum value can be 300!',
      'contact_us': 'Contact Us',
      'github_repo': 'GitHub Repository',
      'privacy_policy': 'Privacy Policy',
      'terms_of_use': 'Terms of Use',
      'developer': 'Developer',
      'version': 'Version 1.0.0',
      'mail_subject': 'LinguaDash Support',
      'mail_error': 'No email client found.',
      'locked_title': 'Locked!',
      'locked_msg': 'You must score at least 500 points in any normal mode to unlock Custom Mode.',
      'share_score': 'Share Score',
      'share_msg': 'I scored {score} points in LinguaDash! Can you beat me? 😎',
      'streak_label': 'STREAK'
    }
  };
}
