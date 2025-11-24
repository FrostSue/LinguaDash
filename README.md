<div align="center">
  <img src="assets/icons/icon.png" alt="LinguaDash Logo" width="120" height="120">
  <h1>LinguaDash</h1>
  <p>
    <b>The Ultimate Cross-Platform Language Learning Game</b>
    <br>
    <b>Nihai Çapraz Platform Dil Öğrenme Oyunu</b>
  </p>

  <p>
    <a href="#english">🇺🇸 English</a> •
    <a href="#türkçe">🇹🇷 Türkçe</a>
  </p>

  ![Version](https://img.shields.io/badge/Version-v1.0.0-blue?style=for-the-badge&logo=git)
  ![Flutter](https://img.shields.io/badge/Flutter-3.24%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)
  ![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-red?style=for-the-badge)
  ![AdMob](https://img.shields.io/badge/AdMob-Integrated-EA4335?style=for-the-badge&logo=google-ads&logoColor=white)
</div>

---

<a name="english"></a>
## 🇬🇧 English

### 📖 Project Description

**LinguaDash** is a modern, fast-paced, and customizable mobile word game designed to improve vocabulary and reflexes. Unlike traditional learning apps, it gamifies the experience with a minimalist **Papyrus Theme**, satisfying haptic feedback, and dynamic audio effects.

The core objective is to match words with their correct meanings under pressure (time or lives). A standout feature is the **Custom Mode**, which allows users to create, edit, and play with their own word pools, making it a truly personalized learning tool.

### ✨ Features

* **🎨 Aesthetic UI:** A warm, eye-friendly "Papyrus" theme with smooth animations (Flutter Animate).
* **🎮 4 Unique Game Modes:**
    * **Classic Mode:** Test your endurance with 3 lives.
    * **Time Attack:** Race against the clock (30s - 3m). No lives, just speed.
    * **Word Count:** Sprint through 25, 50, 75, or 100 words.
    * **Custom Mode:** Add your own words manually and play with your personalized deck.
* **⚙️ Advanced Mechanics:**
    * **Dynamic Scoring:** +10 points for correct, -10 points for wrong answers (Animated).
    * **Haptic Feedback:** Physical vibration response on interactions.
    * **Low-Latency Audio:** Optimized sound engine for instant feedback.
    * **Monetization:** Integrated AdMob Banner & Interstitial ads (User-friendly & Non-intrusive).
* **💾 Local Persistence:** High scores, game history, and custom words are saved locally.
* **🌍 Localization:** Full support for English and Turkish languages.

### 📸 Screenshots

<p align="center">
  <img src="screenshots/main_menu.png" width="200" alt="Main Menu">
  <img src="screenshots/gameplay.png" width="200" alt="Gameplay">
  <img src="screenshots/settings.png" width="200" alt="Settings">
  <img src="screenshots/history.png" width="200" alt="History">
</p>

### 🛠️ Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/FrostSue/LinguaDash.git](https://github.com/FrostSue/LinguaDash.git)
    ```
2.  **Navigate to project directory:**
    ```bash
    cd linguadash
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **⚠️ AdMob Configuration (Crucial):**
    Since real AdMob IDs are hidden for security, you need to create a secrets file to run the project in Release mode.
    * Go to `lib/services/` folder.
    * Create a file named `ad_secrets.dart`.
    * Paste the following code (You can leave strings empty for development/debug):
    ```dart
    class AdSecrets {
      static const String androidBanner = '';
      static const String androidInterstitial = '';
      static const String iosBanner = '';
      static const String iosInterstitial = '';
    }
    ```
    *(Note: In Debug mode, the app automatically uses Google Test IDs).*
5.  **Run the app:**
    ```bash
    flutter run
    ```

### 🗺️ Roadmap

- [ ] **Level System:** Progressive difficulty levels with unlockable content.
- [ ] **Online Leaderboards:** Compete with friends globally.
- [ ] **Cloud Sync:** Backup your custom word pools to the cloud.
- [ ] **Dark Mode:** Alternative color palettes.

### 🤝 Contributing

Contributions are welcome!
1.  Fork the project.
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

### 📝 License

This project is licensed under the **GNU General Public License v3.0 (GPLv3)**.
This means you are free to use, modify, and distribute the code, but **you must also open-source your modifications** under the same license.

---

<a name="türkçe"></a>
## 🇹🇷 Türkçe

### 📖 Proje Tanımı

**LinguaDash**, kelime dağarcığını geliştirmek ve refleksleri test etmek için tasarlanmış modern, hızlı ve özelleştirilebilir bir mobil kelime oyunudur. Geleneksel sıkıcı öğrenme uygulamalarından uzaklaşarak, minimalist **Papirüs Teması**, titreşim geri bildirimleri ve dinamik ses efektleri ile öğrenmeyi eğlenceli bir oyuna dönüştürür.

Temel amaç, verilen kelimeleri doğru anlamlarıyla baskı altında (süre veya can) eşleştirmektir. LinguaDash'i benzersiz kılan şey, kullanıcıların kendi kelime havuzlarını oluşturmasına, düzenlemesine ve oynamasına izin veren **Özel Oyun Modu**dur.

### ✨ Özellikler

* **🎨 Estetik Arayüz:** Göz yormayan sıcak tema ve akıcı animasyonlar.
* **🎮 4 Farklı Oyun Modu:**
    * **Klasik Mod:** 3 can ile ne kadar ileri gidebileceğinizi görün.
    * **Zamana Karşı:** Süreye karşı yarışın (30sn - 3dk). Can derdi yok, sadece hız!
    * **Kelime Sayısı:** Belirli sayıda kelimeyi en hızlı sürede bitirin.
    * **Özel Mod:** Kendi kelimelerinizi ekleyin ve kişisel havuzunuzla oynayın.
* **⚙️ Teknik Detaylar:**
    * **Dinamik Puanlama:** Doğru/Yanlış cevaplarda animasyonlu puan değişimi (+10/-10).
    * **Titreşim:** Hatalarda ve tıklamalarda fiziksel tepki.
    * **Ses Motoru:** Gecikmesiz ses efektleri.
    * **Gelir Modeli:** Kullanıcıyı rahatsız etmeyen AdMob Banner ve Geçiş reklamları.
* **💾 Yerel Kayıt:** Yüksek skorlar, oyun geçmişi ve özel kelimeler cihazda saklanır.
* **🌍 Çoklu Dil:** Tamamen Türkçe ve İngilizce dil desteği.

### 📸 Ekran Görüntüleri

<p align="center">
  <img src="screenshots/main_menu.png" width="200" alt="Ana Menü">
  <img src="screenshots/gameplay.png" width="200" alt="Oyun Ekranı">
  <img src="screenshots/settings.png" width="200" alt="Ayarlar">
  <img src="screenshots/history.png" width="200" alt="Geçmiş">
</p>

### 🚀 Kurulum (Önemli)

1.  **Projeyi indirin:**
    ```bash
    git clone [https://github.com/FrostSue/LinguaDash.git](https://github.com/FrostSue/LinguaDash.git)
    ```
2.  **Paketleri yükleyin:**
    ```bash
    flutter pub get
    ```
3.  **⚠️ AdMob Ayarı (Gerekli):**
    Gerçek reklam kimlikleri güvenlik nedeniyle gizlendiği için, projeyi derlemeden önce `lib/services/` klasörü altına `ad_secrets.dart` dosyası oluşturmalı ve içine `AdSecrets` sınıfını (yukarıdaki İngilizce kısımda örneği var) eklemelisiniz.
    *(Not: Debug modunda uygulama otomatik olarak Google Test Reklamlarını kullanır).*
4.  **Başlatın:**
    ```bash
    flutter run
    ```

### 🗺️ Yol Haritası

LinguaDash sürekli gelişmeye devam edecek. Gelecek planlarımız:
- [ ] **Seviye Sistemi:** Kilidi açılabilir içeriklerle artan zorluk seviyeleri.
- [ ] **Online Sıralama:** Arkadaşlarınızla ve dünyayla yarışın.
- [ ] **Bulut Yedekleme:** Özel kelime havuzlarınızı kaybetmeyin.
- [ ] **Karanlık Mod:** Farklı tema seçenekleri.

### 🤝 Katkıda Bulunma

Katkılarınızı bekliyoruz!
1.  Projeyi fork'layın.
2.  Yeni bir özellik dalı oluşturun (`git checkout -b feature/HarikaOzellik`).
3.  Değişikliklerinizi commit edin (`git commit -m 'HarikaOzellik eklendi'`).
4.  Dalı push edin (`git push origin feature/HarikaOzellik`).
5.  Bir Pull Request oluşturun.

### 📝 Lisans

Bu proje **GNU General Public License v3.0 (GPLv3)** altında lisanslanmıştır.
Bu, kodu özgürce kullanabileceğiniz ve değiştirebileceğiniz anlamına gelir; ancak **yaptığınız değişiklikleri de aynı lisans altında açık kaynak olarak paylaşmanız zorunludur.**

---

## 📩 Contact / İletişim

* **Developer:** [@FrostSue](https://github.com/FrostSue)
* **Email:** ellstmc1@gmail.com

<div align="center">
  <sub>Built with ❤️ by FrostSue using Flutter</sub>
</div>