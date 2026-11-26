import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// Gabungan data kosakata beserta progres SRS-nya (jika sudah pernah dipelajari).
class VocabWithProgress {
  const VocabWithProgress({
    required this.vocab,
    this.progress,
  });

  final VocabItem vocab;
  final SrsProgressEntry? progress;

  String get effectiveStatus => progress?.status ?? 'new';
}

/// Ringkasan statistik belajar untuk ditampilkan di Beranda & halaman Progres.
class LearningSummary {
  const LearningSummary({
    required this.totalVocab,
    required this.masteredCount,
    required this.learningCount,
    required this.dueTodayCount,
    required this.readPassagesCount,
    required this.totalPassagesCount,
    required this.completedGrammarCount,
    required this.totalGrammarCount,
  });

  final int totalVocab;
  final int masteredCount;
  final int learningCount;
  final int dueTodayCount;
  final int readPassagesCount;
  final int totalPassagesCount;
  final int completedGrammarCount;
  final int totalGrammarCount;
}

@DriftDatabase(
  tables: [
    VocabItems,
    SrsProgress,
    ReadingPassages,
    GrammarLessons,
    DailyLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Konstruktor khusus untuk unit/integration test (misal NativeDatabase.memory()).
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ---------------------------------------------------------------------------
  // Query Kosakata & SRS
  // ---------------------------------------------------------------------------

  /// Mencari arti kata berdasarkan teks (case-insensitive) untuk fitur Tap-to-Translate.
  Future<VocabItem?> findVocabByWord(String rawWord) {
    final normalized = rawWord.trim().toLowerCase();
    return (select(vocabItems)
          ..where((t) => t.word.lower().equals(normalized))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Mengambil daftar kata yang jatuh tempo review hari ini (nextReviewAt <= nowMs).
  Future<List<VocabWithProgress>> getDueReviewCards(
    int nowMs, {
    int limit = 20,
  }) async {
    final query = select(srsProgress).join([
      innerJoin(vocabItems, vocabItems.id.equalsExp(srsProgress.vocabId)),
    ])
      ..where(srsProgress.nextReviewAt.isSmallerOrEqualValue(nowMs))
      ..orderBy([OrderingTerm.asc(srsProgress.nextReviewAt)])
      ..limit(limit);

    final rows = await query.get();
    return rows
        .map(
          (row) => VocabWithProgress(
            vocab: row.readTable(vocabItems),
            progress: row.readTable(srsProgress),
          ),
        )
        .toList();
  }

  /// Mengambil kata baru yang belum masuk ke tabel SrsProgress (urut level A1 -> B1).
  Future<List<VocabItem>> getUnlearnedVocab({
    String? levelFilter,
    int limit = 5,
  }) async {
    final query = select(vocabItems).join([
      leftOuterJoin(srsProgress, srsProgress.vocabId.equalsExp(vocabItems.id)),
    ])
      ..where(srsProgress.id.isNull());

    if (levelFilter != null && levelFilter.isNotEmpty) {
      query.where(vocabItems.level.equals(levelFilter));
    }

    query
      ..orderBy([
        OrderingTerm.asc(vocabItems.level),
        OrderingTerm.asc(vocabItems.id),
      ])
      ..limit(limit);

    final rows = await query.get();
    return rows.map((r) => r.readTable(vocabItems)).toList();
  }

  /// Memperbarui catatan jembatan keledai (mnemonic) milik user.
  Future<int> updateMnemonicNote(int vocabId, String? note) {
    return (update(vocabItems)..where((t) => t.id.equals(vocabId))).write(
      VocabItemsCompanion(mnemonicNote: Value(note)),
    );
  }

  /// Menambahkan kata dari bacaan langsung ke antrean belajar SRS (jika belum ada).
  Future<void> enqueueWordForSrs(int vocabId, int nowMs) async {
    await into(srsProgress).insert(
      SrsProgressCompanion.insert(
        vocabId: vocabId,
        nextReviewAt: nowMs,
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  // ---------------------------------------------------------------------------
  // Query Bacaan & Grammar
  // ---------------------------------------------------------------------------

  Stream<List<ReadingPassage>> watchAllReadingPassages() {
    return (select(readingPassages)
          ..orderBy([
            (t) => OrderingTerm.asc(t.level),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .watch();
  }

  Future<void> markPassageRead(int passageId, {bool isRead = true}) async {
    await (update(readingPassages)..where((t) => t.id.equals(passageId))).write(
      ReadingPassagesCompanion(isRead: Value(isRead)),
    );
  }

  Stream<List<GrammarLesson>> watchAllGrammarLessons() {
    return (select(grammarLessons)
          ..orderBy([
            (t) => OrderingTerm.asc(t.level),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .watch();
  }

  Future<void> markGrammarCompleted(int lessonId, {bool completed = true}) async {
    await (update(grammarLessons)..where((t) => t.id.equals(lessonId))).write(
      GrammarLessonsCompanion(isCompleted: Value(completed)),
    );
  }

  // ---------------------------------------------------------------------------
  // Query Log Harian & Ringkasan Statistik
  // ---------------------------------------------------------------------------

  Future<void> recordStudyActivity({
    required String dateKey,
    int reviewedDelta = 0,
    int learnedDelta = 0,
    int minutesDelta = 0,
  }) async {
    await transaction(() async {
      final existing = await (select(dailyLogs)
            ..where((t) => t.date.equals(dateKey)))
          .getSingleOrNull();

      if (existing == null) {
        await into(dailyLogs).insert(
          DailyLogsCompanion.insert(
            date: dateKey,
            wordsReviewed: Value(reviewedDelta),
            wordsLearned: Value(learnedDelta),
            minutesSpent: Value(minutesDelta),
          ),
        );
      } else {
        await (update(dailyLogs)..where((t) => t.date.equals(dateKey))).write(
          DailyLogsCompanion(
            wordsReviewed: Value(existing.wordsReviewed + reviewedDelta),
            wordsLearned: Value(existing.wordsLearned + learnedDelta),
            minutesSpent: Value(existing.minutesSpent + minutesDelta),
          ),
        );
      }
    });
  }

  Future<LearningSummary> getLearningSummary(int nowMs) async {
    final allVocab = await select(vocabItems).get();
    final allProgress = await select(srsProgress).get();
    final allPassages = await select(readingPassages).get();
    final allGrammar = await select(grammarLessons).get();

    final mastered = allProgress.where((p) => p.status == 'mastered').length;
    final learning = allProgress.where((p) => p.status == 'learning').length;
    final dueToday =
        allProgress.where((p) => p.nextReviewAt <= nowMs).length;

    return LearningSummary(
      totalVocab: allVocab.length,
      masteredCount: mastered,
      learningCount: learning,
      dueTodayCount: dueToday,
      readPassagesCount: allPassages.where((p) => p.isRead).length,
      totalPassagesCount: allPassages.length,
      completedGrammarCount: allGrammar.where((g) => g.isCompleted).length,
      totalGrammarCount: allGrammar.length,
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'english_adult_learner.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
