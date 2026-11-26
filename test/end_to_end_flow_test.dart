import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:english_adult_learner/core/database/app_database.dart';
import 'package:english_adult_learner/core/database/seed_loader.dart';
import 'package:english_adult_learner/features/grammar/data/grammar_repository.dart';
import 'package:english_adult_learner/features/progress/data/progress_repository.dart';
import 'package:english_adult_learner/features/reading/data/reading_repository.dart';
import 'package:english_adult_learner/features/srs/data/srs_repository.dart';
import 'package:english_adult_learner/features/srs/domain/srs_calculator.dart';

void main() {
  test(
    'Alur End-to-End: Install & Seed -> Review SRS -> Baca & Simpan Kata -> Grammar -> Cek Statistik',
    () async {
      SharedPreferences.setMockInitialValues({});
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      final now = DateTime(2026, 11, 26, 20, 0);

      // 1. Pertama kali buka aplikasi -> Seed Database A1-B1
      final seedLoader = SeedLoader(database: db);
      await seedLoader.seedFromJsonStrings(
        vocabJson: File('assets/data/vocab_seed.json').readAsStringSync(),
        readingJson: File('assets/data/reading_seed.json').readAsStringSync(),
        grammarJson: File('assets/data/grammar_seed.json').readAsStringSync(),
      );

      final initialSummary =
          await db.getLearningSummary(now.millisecondsSinceEpoch);
      expect(initialSummary.totalVocab, 120);
      expect(initialSummary.totalPassagesCount, 12);
      expect(initialSummary.totalGrammarCount, 8);
      expect(initialSummary.learningCount, 0);

      // 2. Sesi Flashcard SRS + Edit Jembatan Keledai
      final srsRepo = SrsRepository(db);
      final sessionQueue = await srsRepo.buildStudySessionQueue(
        now: now,
        newWordsLimit: 3,
      );
      expect(sessionQueue.length, 3);

      await srsRepo.saveMnemonic(
        vocabId: sessionQueue[0].vocab.id,
        mnemonicNote: 'Jembatan keledai buatan sendiri',
      );
      await srsRepo.submitReview(
        card: sessionQueue[0],
        rating: ReviewRating.good,
        reviewedAt: now,
      );
      await srsRepo.submitReview(
        card: sessionQueue[1],
        rating: ReviewRating.easy,
        reviewedAt: now,
      );
      await srsRepo.submitReview(
        card: sessionQueue[2],
        rating: ReviewRating.hard,
        reviewedAt: now,
      );

      // 3. Baca Artikel -> Ketuk Kata (Tap-to-Translate) -> Simpan ke SRS -> Selesai Baca
      final readingRepo = ReadingRepository(db);
      final allPassages = await db.select(db.readingPassages).get();
      final passage = allPassages.firstWhere(
        (p) => p.title == 'Asking to Reschedule a Meeting',
      );

      final tappedLookup = await readingRepo.lookupWord('reschedule');
      expect(tappedLookup.vocabItem, isNotNull);
      expect(tappedLookup.isInSrsQueue, isFalse);

      await readingRepo.addVocabToSrsQueue(
        tappedLookup.vocabItem!.id,
        now: now,
      );

      // Tambah 1 kata kustom baru dari bacaan
      await readingRepo.saveCustomWordAndEnqueue(
        word: 'kickoff',
        meaningId: 'rapat pembuka proyek',
        contextSentenceEn: 'Our kickoff call is on Monday.',
        now: now,
      );

      await readingRepo.completePassageReading(passage, completedAt: now);

      // 4. Pelajari Pola Kalimat (Grammar) & Selesaikan Kuis Sentence Builder
      final grammarRepo = GrammarRepository(db);
      final firstLessonRow = (await db.select(db.grammarLessons).get()).first;
      final parsedLesson = GrammarRepository.parseLesson(firstLessonRow);
      for (final quiz in parsedLesson.quizzes) {
        expect(quiz.isCorrectOrder(quiz.targetWords), isTrue);
      }
      await grammarRepo.completeLesson(firstLessonRow, completedAt: now);

      // 5. Cek Dashboard Statistik & Kebiasaan Harian
      final progressRepo = ProgressRepository(db);
      final dashboard = await progressRepo.loadDashboardData(now: now);

      // 120 kata awal + 1 kata kustom 'kickoff' = 121
      expect(dashboard.summary.totalVocab, 121);
      // 3 kata dari sesi SRS + 2 kata disimpan dari bacaan ('reschedule' & 'kickoff' masih berstatus 'new' di antrean due)
      expect(dashboard.summary.learningCount, 3);
      expect(dashboard.summary.dueTodayCount, 2);
      expect(dashboard.summary.readPassagesCount, 1);
      expect(dashboard.summary.completedGrammarCount, 1);

      // Streak hari pertama aktif & menit efektif = 3 (bacaan) + 2 (grammar) + 1 (3 review SRS) = 6 menit
      expect(dashboard.streak.streakDays, 1);
      expect(dashboard.streak.studiedToday, isTrue);
      expect(dashboard.todayWordsReviewed, 3);
      expect(dashboard.todayEffectiveMinutes, 6);
    },
  );
}
