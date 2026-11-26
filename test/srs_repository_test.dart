import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:english_adult_learner/core/database/app_database.dart';
import 'package:english_adult_learner/core/database/seed_loader.dart';
import 'package:english_adult_learner/features/srs/data/srs_repository.dart';
import 'package:english_adult_learner/features/srs/domain/srs_calculator.dart';

void main() {
  late AppDatabase db;
  late SrsRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = SrsRepository(db);

    final loader = SeedLoader(database: db);
    await loader.seedFromJsonStrings(
      vocabJson: File('assets/data/vocab_seed.json').readAsStringSync(),
      readingJson: File('assets/data/reading_seed.json').readAsStringSync(),
      grammarJson: File('assets/data/grammar_seed.json').readAsStringSync(),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('buildStudySessionQueue mengambil 5 kata baru level A1 terlebih dahulu', () async {
    final queue = await repo.buildStudySessionQueue(
      now: DateTime.utc(2026, 11, 26, 9, 0),
      newWordsLimit: 5,
    );

    expect(queue.length, 5);
    expect(queue.every((c) => c.vocab.level == 'A1'), isTrue);
    expect(queue.every((c) => c.effectiveStatus == 'new'), isTrue);
  });

  test('submitReview menyimpan progres SRS dan mencatat daily_logs secara atomik', () async {
    final reviewTime = DateTime.utc(2026, 11, 26, 9, 0);
    final queue = await repo.buildStudySessionQueue(
      now: reviewTime,
      newWordsLimit: 2,
    );
    final firstCard = queue.first;

    final nextState = await repo.submitReview(
      card: firstCard,
      rating: ReviewRating.good,
      reviewedAt: reviewTime,
    );

    expect(nextState.intervalDays, 1);
    expect(nextState.status, 'learning');

    final logs = await db.select(db.dailyLogs).get();
    expect(logs.length, 1);
    expect(logs.first.date, '2026-11-26');
    expect(logs.first.wordsReviewed, 1);
    expect(logs.first.wordsLearned, 1);

    // Review kedua di hari berikutnya tidak menambah wordsLearned lagi, hanya wordsReviewed
    final nextDay = reviewTime.add(const Duration(days: 1, hours: 1));
    final dueNextDay = await repo.buildStudySessionQueue(
      now: nextDay,
      newWordsLimit: 0,
    );
    expect(dueNextDay.length, 1);
    expect(dueNextDay.first.vocab.id, firstCard.vocab.id);

    await repo.submitReview(
      card: dueNextDay.first,
      rating: ReviewRating.good,
      reviewedAt: nextDay,
    );

    final secondLog = await (db.select(db.dailyLogs)
          ..where((t) => t.date.equals('2026-11-27')))
        .getSingle();
    expect(secondLog.wordsReviewed, 1);
    expect(secondLog.wordsLearned, 0);
  });

  test('saveMnemonic memperbarui jembatan keledai pengguna', () async {
    final queue = await repo.buildStudySessionQueue(newWordsLimit: 1);
    final vocabId = queue.first.vocab.id;

    final updated = await repo.saveMnemonic(
      vocabId: vocabId,
      mnemonicNote: 'Catatan asosiasi pribadi saya',
    );

    expect(updated, isNotNull);
    expect(updated!.mnemonicNote, 'Catatan asosiasi pribadi saya');
  });
}
