import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Pilihan kecepatan bicara untuk melatih pendengaran pembelajar dewasa.
enum SpeechSpeed {
  /// Kecepatan percakapan normal sehari-hari (1.0x).
  normal('1.0x Normal', 0.50),

  /// Kecepatan lebih pelan (0.75x) untuk menangkap pengucapan tiap suku kata.
  slow('0.75x Lambat', 0.35);

  const SpeechSpeed(this.label, this.androidTtsRate);

  final String label;

  /// Pada plugin `flutter_tts` Android, nilai 0.5 setara kecepatan bicara normal (1.0x native),
  /// sedangkan 0.35 setara kecepatan lambat (~0.75x native) yang tetap terdengar alami.
  final double androidTtsRate;
}

/// Pembungkus layanan Text-to-Speech (offline-capable di Android).
class TtsService {
  TtsService({FlutterTts? tts}) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;
  bool _isInitialized = false;

  /// Notifier apakah suara sedang diputar (berguna untuk animasi ikon speaker di UI).
  final ValueNotifier<bool> isSpeaking = ValueNotifier<bool>(false);

  /// Menginisialisasi engine TTS dengan bahasa Inggris (prioritas en-US, fallback en-GB).
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await _tts.awaitSpeakCompletion(true);

      // Pilih bahasa Inggris yang tersedia di perangkat (mendukung offline voice pack Android)
      final isUsAvailable = await _tts.isLanguageAvailable('en-US') == true;
      if (isUsAvailable) {
        await _tts.setLanguage('en-US');
      } else {
        final isGbAvailable = await _tts.isLanguageAvailable('en-GB') == true;
        if (isGbAvailable) {
          await _tts.setLanguage('en-GB');
        } else {
          await _tts.setLanguage('en');
        }
      }

      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      await _tts.setSpeechRate(SpeechSpeed.normal.androidTtsRate);

      _tts.setStartHandler(() {
        isSpeaking.value = true;
      });
      _tts.setCompletionHandler(() {
        isSpeaking.value = false;
      });
      _tts.setCancelHandler(() {
        isSpeaking.value = false;
      });
      _tts.setErrorHandler((_) {
        isSpeaking.value = false;
      });

      _isInitialized = true;
    } catch (_) {
      // Aman diabaikan pada lingkungan test atau perangkat tanpa engine TTS aktif
      isSpeaking.value = false;
    }
  }

  /// Memutar teks bahasa Inggris dengan kecepatan yang dipilih.
  /// Otomatis menghentikan pemutaran sebelumnya agar suara tidak bertumpuk.
  Future<void> speak(
    String text, {
    SpeechSpeed speed = SpeechSpeed.normal,
  }) async {
    final cleaned = text.trim();
    if (cleaned.isEmpty) return;

    try {
      await init();
      await _tts.stop();
      await _tts.setSpeechRate(speed.androidTtsRate);
      isSpeaking.value = true;
      await _tts.speak(cleaned);
    } catch (_) {
      isSpeaking.value = false;
    }
  }

  /// Menghentikan suara yang sedang berjalan.
  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {
      // Abaikan jika engine belum siap
    } finally {
      isSpeaking.value = false;
    }
  }

  void dispose() {
    stop();
    isSpeaking.dispose();
  }
}

/// Provider global untuk TtsService.
final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  ref.onDispose(service.dispose);
  return service;
});

/// Provider pilihan kecepatan default saat memutar kalimat/kosakata.
final preferredSpeechSpeedProvider = StateProvider<SpeechSpeed>(
  (ref) => SpeechSpeed.normal,
);
