import 'package:audioplayers/audioplayers.dart';

class MusicService {
  static final AudioPlayer _player = AudioPlayer();

  // Play music
  static Future<void> play() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(0.1);
      await _player.play(AssetSource("music.mp3"));
    } catch (e) {
      print("Error playing music: $e");
    }// add your mp3 in assets
  }

  // Stop music
  static Future<void> stop() async {
    await _player.stop();
  }

  // Toggle
  static Future<void> toggle(bool playMusic) async {
    if (playMusic) {
      await play();
    } else {
      await stop();
    }
  }
}
