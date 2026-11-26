import 'package:flutter_test/flutter_test.dart';

import 'package:english_adult_learner/core/services/tts_service.dart';
import 'package:english_adult_learner/features/srs/domain/srs_calculator.dart';

void main() {
  final baseTime = DateTime.utc(2026, 11, 26, 8, 0);

  group('SrsCalculator (Algoritma SM-2)', () {
    test('Progresi kartu baru dengan penilaian Good menuju status mastered', () {
      var state = SrsCardState(nextReviewAtMs: baseTime.millisecondsSinceEpoch);

      // Review 1 (Good): interval 1 hari, status learning
      state = SrsCalculator.calculateNext(
        current: state,
        rating: ReviewRating.good,
        reviewedAt: baseTime,
      );
      expect(state.intervalDays, 1);
      expect(state.repetitions, 1);
      expect(state.status, 'learning');
      expect(state.easeFactor, 2.5);

      // Review 2 (Good): interval 3 hari
      state = SrsCalculator.calculateNext(
        current: state,
        rating: ReviewRating.good,
        reviewedAt: baseTime.add(const Duration(days: 1)),
      );
      expect(state.intervalDays, 3);
      expect(state.repetitions, 2);
      expect(state.status, 'learning');

      // Review 3 (Good): round(3 * 2.5) = 8 hari
      state = SrsCalculator.calculateNext(
        current: state,
        rating: ReviewRating.good,
        reviewedAt: baseTime.add(const Duration(days: 4)),
      );
      expect(state.intervalDays, 8);
      expect(state.repetitions, 3);
      expect(state.status, 'learning');

      // Review 4 (Good): round(8 * 2.5) = 20 hari (belum >= 21)
      state = SrsCalculator.calculateNext(
        current: state,
        rating: ReviewRating.good,
        reviewedAt: baseTime.add(const Duration(days: 12)),
      );
      expect(state.intervalDays, 20);
      expect(state.status, 'learning');

      // Review 5 (Good): round(20 * 2.5) = 50 hari (>= 21 hari & reps >= 3 -> mastered!)
      state = SrsCalculator.calculateNext(
        current: state,
        rating: ReviewRating.good,
        reviewedAt: baseTime.add(const Duration(days: 32)),
      );
      expect(state.intervalDays, 50);
      expect(state.repetitions, 5);
      expect(state.status, 'mastered');
    });

    test('Penilaian Again (Lupa) mereset repetisi ke 0 dan menjadwalkan ulang 10 menit', () {
      final masteredState = SrsCardState(
        easeFactor: 2.5,
        intervalDays: 30,
        repetitions: 4,
        status: 'mastered',
        nextReviewAtMs: baseTime.millisecondsSinceEpoch,
      );

      final lapsed = SrsCalculator.calculateNext(
        current: masteredState,
        rating: ReviewRating.again,
        reviewedAt: baseTime,
      );

      expect(lapsed.repetitions, 0);
      expect(lapsed.intervalDays, 0);
      expect(lapsed.status, 'learning');
      expect(lapsed.easeFactor, 2.3);
      expect(
        lapsed.nextReviewAtMs,
        baseTime.add(const Duration(minutes: 10)).millisecondsSinceEpoch,
      );
    });

    test('Ease factor selalu terjaga di rentang 1.3 hingga 3.0', () {
      var lowState = SrsCardState(
        nextReviewAtMs: baseTime.millisecondsSinceEpoch,
      );
      for (var i = 0; i < 15; i++) {
        lowState = SrsCalculator.calculateNext(
          current: lowState,
          rating: ReviewRating.again,
          reviewedAt: baseTime,
        );
      }
      expect(lowState.easeFactor, SrsCalculator.minEaseFactor);

      var highState = SrsCardState(
        nextReviewAtMs: baseTime.millisecondsSinceEpoch,
      );
      for (var i = 0; i < 15; i++) {
        highState = SrsCalculator.calculateNext(
          current: highState,
          rating: ReviewRating.easy,
          reviewedAt: baseTime,
        );
      }
      expect(highState.easeFactor, SrsCalculator.maxEaseFactor);
    });

    test('previewNextIntervals menghasilkan label tombol yang mudah dibaca', () {
      final initial = SrsCardState(
        nextReviewAtMs: baseTime.millisecondsSinceEpoch,
      );
      final labels = SrsCalculator.previewNextIntervals(
        initial,
        referenceTime: baseTime,
      );

      expect(labels[ReviewRating.again], '10 mnt');
      expect(labels[ReviewRating.hard], '1 hr');
      expect(labels[ReviewRating.good], '1 hr');
      expect(labels[ReviewRating.easy], '4 hr');
    });
  });

  group('SpeechSpeed konfigurasi TTS', () {
    test('Kecepatan lambat lebih rendah dari kecepatan normal Android TTS', () {
      expect(SpeechSpeed.normal.androidTtsRate, 0.50);
      expect(SpeechSpeed.slow.androidTtsRate, 0.35);
      expect(
        SpeechSpeed.slow.androidTtsRate,
        lessThan(SpeechSpeed.normal.androidTtsRate),
      );
    });
  });
}
