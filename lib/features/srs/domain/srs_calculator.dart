/// Penilaian user setelah membuka jawaban kartu kosakata.
enum ReviewRating {
  /// Lupa sama sekali -> ulangi dalam 10 menit (tetap di sesi/hari ini).
  again('Lupa', 1),

  /// Ingat tapi butuh mikir keras -> interval naik sedikit.
  hard('Susah', 3),

  /// Ingat dengan lancar -> interval naik sesuai faktor kemudahan SM-2.
  good('Ingat', 4),

  /// Sangat mudah & langsung terbayang -> interval lompat lebih jauh.
  easy('Mudah', 5);

  const ReviewRating(this.labelId, this.quality);

  final String labelId;
  final int quality;
}

/// Representasi state SRS murni (tidak bergantung pada kelas database) agar mudah diuji.
class SrsCardState {
  const SrsCardState({
    this.easeFactor = SrsCalculator.defaultEaseFactor,
    this.intervalDays = 0,
    this.repetitions = 0,
    this.status = 'new',
    required this.nextReviewAtMs,
    this.lastReviewedAtMs,
  });

  final double easeFactor;
  final int intervalDays;
  final int repetitions;

  /// Salah satu dari: 'new', 'learning', 'mastered'.
  final String status;

  final int nextReviewAtMs;
  final int? lastReviewedAtMs;
}

/// Kalkulator Spaced Repetition berbasis algoritma SM-2 yang diadaptasi untuk
/// pembelajar dewasa (interval awal 1 -> 3 hari agar tidak keburu lupa sebelum review ke-2).
class SrsCalculator {
  const SrsCalculator._();

  static const double defaultEaseFactor = 2.5;
  static const double minEaseFactor = 1.3;
  static const double maxEaseFactor = 3.0;

  /// Jeda ulang singkat (10 menit) ketika user menekan 'Lupa' (Again).
  static const Duration lapseRelearnDelay = Duration(minutes: 10);

  /// Ambang batas kata dianggap masuk memori jangka panjang ('mastered').
  static const int masteredMinIntervalDays = 21;
  static const int masteredMinRepetitions = 3;

  /// Menghitung jadwal & parameter SRS berikutnya berdasarkan penilaian user.
  static SrsCardState calculateNext({
    required SrsCardState current,
    required ReviewRating rating,
    required DateTime reviewedAt,
  }) {
    final nowMs = reviewedAt.millisecondsSinceEpoch;
    var ef = current.easeFactor;
    var reps = current.repetitions;
    var interval = current.intervalDays;
    late final int nextReviewMs;

    switch (rating) {
      case ReviewRating.again:
        reps = 0;
        interval = 0;
        ef = _clampEase(ef - 0.20);
        nextReviewMs = reviewedAt.add(lapseRelearnDelay).millisecondsSinceEpoch;

      case ReviewRating.hard:
        if (reps == 0) {
          interval = 1;
        } else if (reps == 1) {
          interval = 2;
        } else {
          final scaled = (interval * 1.2).round();
          interval = scaled > interval ? scaled : interval + 1;
        }
        reps += 1;
        ef = _clampEase(ef - 0.15);
        nextReviewMs =
            reviewedAt.add(Duration(days: interval)).millisecondsSinceEpoch;

      case ReviewRating.good:
        if (reps == 0) {
          interval = 1;
        } else if (reps == 1) {
          interval = 3;
        } else {
          final scaled = (interval * ef).round();
          interval = scaled > interval ? scaled : interval + 1;
        }
        reps += 1;
        // Pada SM-2 untuk quality=4, perubahan EF adalah 0.0 (stabil)
        ef = _clampEase(ef);
        nextReviewMs =
            reviewedAt.add(Duration(days: interval)).millisecondsSinceEpoch;

      case ReviewRating.easy:
        if (reps == 0) {
          interval = 4;
        } else if (reps == 1) {
          interval = 7;
        } else {
          final scaled = (interval * ef * 1.3).round();
          interval = scaled > interval ? scaled : interval + 2;
        }
        reps += 1;
        ef = _clampEase(ef + 0.15);
        nextReviewMs =
            reviewedAt.add(Duration(days: interval)).millisecondsSinceEpoch;
    }

    final newStatus =
        (interval >= masteredMinIntervalDays && reps >= masteredMinRepetitions)
            ? 'mastered'
            : 'learning';

    return SrsCardState(
      easeFactor: double.parse(ef.toStringAsFixed(2)),
      intervalDays: interval,
      repetitions: reps,
      status: newStatus,
      nextReviewAtMs: nextReviewMs,
      lastReviewedAtMs: nowMs,
    );
  }

  /// Menghasilkan label pratinjau interval untuk tiap tombol (misal '10 mnt', '3 hr', '1 bln').
  static Map<ReviewRating, String> previewNextIntervals(
    SrsCardState current, {
    DateTime? referenceTime,
  }) {
    final now = referenceTime ?? DateTime.fromMillisecondsSinceEpoch(0);
    return {
      for (final rating in ReviewRating.values)
        rating: _formatIntervalLabel(
          calculateNext(
            current: current,
            rating: rating,
            reviewedAt: now,
          ),
        ),
    };
  }

  static String _formatIntervalLabel(SrsCardState nextState) {
    if (nextState.intervalDays <= 0) {
      return '${lapseRelearnDelay.inMinutes} mnt';
    }
    final days = nextState.intervalDays;
    if (days < 30) {
      return '$days hr';
    }
    final months = (days / 30).toStringAsFixed(1);
    return months.endsWith('.0')
        ? '${days ~/ 30} bln'
        : '$months bln';
  }

  static double _clampEase(double value) {
    if (value < minEaseFactor) return minEaseFactor;
    if (value > maxEaseFactor) return maxEaseFactor;
    return value;
  }
}
