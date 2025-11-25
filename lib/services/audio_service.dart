import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _clickPlayer = AudioPlayer();
  final AudioPlayer _correctPlayer = AudioPlayer();
  final AudioPlayer _wrongPlayer = AudioPlayer();
  final AudioPlayer _owlPlayer = AudioPlayer();
  bool isMuted = false;

  Future<void> init() async {
    await _clickPlayer.setPlayerMode(PlayerMode.lowLatency);
    await _correctPlayer.setPlayerMode(PlayerMode.lowLatency);
    await _wrongPlayer.setPlayerMode(PlayerMode.lowLatency);
    await _owlPlayer.setPlayerMode(PlayerMode.lowLatency);
  }

  Future<void> _play(AudioPlayer player, String path) async {
    if (isMuted) {
      await player.setVolume(0);
      return;
    } else {
      await player.setVolume(1.0);
    }

    try {
      if (player.state == PlayerState.playing) {
        await player.stop();
      }
      await player.play(AssetSource(path));
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  void playCorrect() => _play(_correctPlayer, 'sounds/correct.wav');
  void playWrong() => _play(_wrongPlayer, 'sounds/wrong.wav');
  void playClick() => _play(_clickPlayer, 'sounds/click.mp3');
  void playOwl() => _play(_owlPlayer, 'sounds/owl-click.mp3');
}