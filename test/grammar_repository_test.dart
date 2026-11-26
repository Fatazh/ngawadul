import 'dart:io';
import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:english_adult_learner/core/database/app_database.dart';
import 'package:english_adult_learner/core/database/seed_loader.dart';
import 'package:english_adult_learner/features/grammar/data/grammar_repository.dart';

void main() {
  late AppDatabase db;
  late GrammarRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = GrammarRepository(db);

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

  test('parseLesson mengurai 8 materi dan 24 soal Sentence Builder dengan valid', () async {
    final rows = await db.select(db.grammarLessons).get();
    expect(rows.length, 8);

    final parsedList = rows.map(GrammarRepository.parseLesson).toList();
    final totalQuizzes =
        parsedList.fold<int>(0, (sum, item) => sum + item.quizzes.length);
    expect(totalQuizzes, 24);

    for (final p in parsedList) {
      expect(p.examples, isNotEmpty);
      for (final q in p.quizzes) {
        expect(q.promptId, isNotEmpty);
        expect(q.targetWords, isNotEmpty);
        expect(q.isCorrectOrder(q.targetWords), isTrue);
      }
    }
  });

  test('buildShuffledBank menjaga keunikan ID pada kata berulang (misal dua kata at)', () {
    const quiz = SentenceQuizItem(
      promptId: 'Saya tiba di bandara jam enam.',
      targetWords: ['I', 'arrive', 'at', 'the', 'airport', 'at', 'six.'],
      distractors: ['in', 'on'],
      hint: 'Gunakan at untuk titik lokasi dan jam.',
    );

    final bank = quiz.buildShuffledBank(random: Random(42));
    expect(bank.length, 9);

    final ids = bank.map((c) => c.id).toSet();
    expect(ids.length, 9);

    final atChips = bank.where((c) => c.text == 'at').toList();
    expect(atChips.length, 2);
    expect(atChips[0].id, isNot(equals(atChips[1].id)));

    expect(
      quiz.isCorrectOrder(['I', 'arrive', 'at', 'the', 'airport', 'at', 'six.']),
      isTrue,
    );
    expect(
      quiz.isCorrectOrder(['I', 'arrive', 'in', 'the', 'airport', 'at', 'six.']),
      isFalse,
    );
  });

  test('completeLesson menandai materi selesai dan menambah 2 menit belajar', () async {
    final first = (await db.select(db.grammarLessons).get()).first;
    expect(first.isCompleted, isFalse);

    await repo.completeLesson(
      first,
      completedAt: DateTime.utc(2026, 11, 26, 20, 0),
    );

    final refreshed = await (db.select(db.grammarLessons)
          ..where((t) => t.id.equals(first.id)))
        .getSingle();
    expect(refreshed.isCompleted, isTrue);

    final log = await (db.select(db.dailyLogs)
          ..where((t) => t.date.equals('2026-11-26')))
        .getSingle();
    expect(log.minutesSpent, 2);
  });
}
