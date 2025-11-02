import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Play button click sound (next.wav)
  Future<void> playButtonClick() async {
    try {
      await _audioPlayer.play(AssetSource('audio/next.wav'));
    } catch (e) {
      // Silently fail if audio can't be played
      print('Error playing button click sound: $e');
    }
  }

  /// Play win sound when item is added (win.wav)
  Future<void> playWinSound() async {
    try {
      await _audioPlayer.play(AssetSource('audio/win.wav'));
    } catch (e) {
      // Silently fail if audio can't be played
      print('Error playing win sound: $e');
    }
  }

  /// Dispose of the audio player
  void dispose() {
    _audioPlayer.dispose();
  }
}
