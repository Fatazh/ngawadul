import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/srs_calculator.dart';

/// Repository yang menghubungkan algoritma SM-2 dengan tabel Drift SQLite
/// (`vocab_items`, `srs_progress`, dan `daily_logs`).
class SrsRepository {
  const SrsRepository(this._db);

  final AppDatabase _db;

  /// Menyusun antrean sesi belajar harian:
  /// 1. Dahulukan kata yang jatuh tempo review (`nextReviewAt <= nowMs`).
  /// 2. Tambahkan kata baru yang belum pernah dipelajari hingga `newWordsLimit`.
  Future<List<VocabWithProgress>> buildStudySessionQueue({
    DateTime? now,
    String? levelFilter,
    int dueLimit = 20,
    int newWordsLimit = 5,
  }) async {
    final currentTime = now ?? DateTime.now();
    final nowMs = currentTime.millisecondsSinceEpoch;

    var dueCards = await _db.getDueReviewCards(nowMs, limit: dueLimit);
    if (levelFilter != null && levelFilter.isNotEmpty && levelFilter != 'ALL') {
      dueCards = dueCards
          .where((item) => item.vocab.level == levelFilter)
          .toList();
    }

    final effectiveLevel =
        (levelFilter == null || levelFilter == 'ALL') ? null : levelFilter;
    final newVocab = await _db.getUnlearnedVocab(
      levelFilter: effectiveLevel,
      limit: newWordsLimit,
    );

    final newCards = newVocab
        .map((vocab) => VocabWithProgress(vocab: vocab))
        .toList();

    return [...dueCards, ...newCards];
  }

  /// Menyimpan hasil review satu kartu ke `srs_progress` dan mencatat log harian
  /// dalam satu transaksi SQLite yang atomik.
  Future<SrsCardState> submitReview({
    required VocabWithProgress card,
    required ReviewRating rating,
    DateTime? reviewedAt,
  }) async {
    final reviewTime = reviewedAt ?? DateTime.now();
    final existing = card.progress;
    final isFirstTimeLearned = existing == null;

    final currentState = existing != null
        ? SrsCardState(
            easeFactor: existing.easeFactor,
            intervalDays: existing.intervalDays,
            repetitions: existing.repetitions,
            status: existing.status,
            nextReviewAtMs: existing.nextReviewAt,
            lastReviewedAtMs: existing.lastReviewedAt,
          )
        : SrsCardState(
            nextReviewAtMs: reviewTime.millisecondsSinceEpoch,
          );

    final nextState = SrsCalculator.calculateNext(
      current: currentState,
      rating: rating,
      reviewedAt: reviewTime,
    );

    final dateKey = formatDateKey(reviewTime);

    await _db.transaction(() async {
      final currentRow = await (_db.select(_db.srsProgress)
            ..where((t) => t.vocabId.equals(card.vocab.id)))
          .getSingleOrNull();

      if (currentRow == null) {
        await _db.into(_db.srsProgress).insert(
              SrsProgressCompanion.insert(
                vocabId: card.vocab.id,
                easeFactor: Value(nextState.easeFactor),
                intervalDays: Value(nextState.intervalDays),
                repetitions: Value(nextState.repetitions),
                status: Value(nextState.status),
                nextReviewAt: nextState.nextReviewAtMs,
                lastReviewedAt: Value(nextState.lastReviewedAtMs),
              ),
            );
      } else {
        await (_db.update(_db.srsProgress)
              ..where((t) => t.vocabId.equals(card.vocab.id)))
            .write(
          SrsProgressCompanion(
            easeFactor: Value(nextState.easeFactor),
            intervalDays: Value(nextState.intervalDays),
            repetitions: Value(nextState.repetitions),
            status: Value(nextState.status),
            nextReviewAt: Value(nextState.nextReviewAtMs),
            lastReviewedAt: Value(nextState.lastReviewedAtMs),
          ),
        );
      }

      await _db.recordStudyActivity(
        dateKey: dateKey,
        reviewedDelta: 1,
        learnedDelta: isFirstTimeLearned ? 1 : 0,
      );
    });

    return nextState;
  }

  /// Memperbarui jembatan keledai (mnemonic) milik pengguna dan mengembalikan item terbaru.
  Future<VocabItem?> saveMnemonic({
    required int vocabId,
    required String? mnemonicNote,
  }) async {
    final cleaned =
        (mnemonicNote == null || mnemonicNote.trim().isEmpty)
            ? null
            : mnemonicNote.trim();
    await _db.updateMnemonicNote(vocabId, cleaned);
    return (_db.select(_db.vocabItems)..where((t) => t.id.equals(vocabId)))
        .getSingleOrNull();
  }

  /// Format tanggal lokal ke 'YYYY-MM-DD' untuk Primary Key `daily_logs`.
  static String formatDateKey(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
