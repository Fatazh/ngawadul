import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:english_adult_learner/core/database/app_database.dart';
import 'package:english_adult_learner/core/database/seed_loader.dart';

void main() {
  late AppDatabase db;
  late SeedLoader loader;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    loader = SeedLoader(database: db);
  });

  tearDown(() async {
    await db.close();
  });

  test('SeedLoader mengisi 120 kata, 12 bacaan, dan 8 grammar secara idempotent', () async {
    final vocabJson = File('assets/data/vocab_seed.json').readAsStringSync();
    final readingJson = File('assets/data/reading_seed.json').readAsStringSync();
    final grammarJson = File('assets/data/grammar_seed.json').readAsStringSync();

    await loader.seedFromJsonStrings(
      vocabJson: vocabJson,
      readingJson: readingJson,
      grammarJson: grammarJson,
    );

    // Jalankan kedua kali untuk memastikan InsertMode.insertOrIgnore tidak menduplikasi data
    await loader.seedFromJsonStrings(
      vocabJson: vocabJson,
      readingJson: readingJson,
      grammarJson: grammarJson,
    );

    final summary = await db.getLearningSummary(
      DateTime.now().millisecondsSinceEpoch,
    );
    expect(summary.totalVocab, 120);
    expect(summary.totalPassagesCount, 12);
    expect(summary.totalGrammarCount, 8);

    // Uji pencarian kata (Tap-to-Translate)
    final found = await db.findVocabByWord('Schedule');
    expect(found, isNotNull);
    expect(found!.level, 'A2');
    expect(found.meaningId, contains('jadwal'));

    // Uji tambah ke SRS & cek antrean jatuh tempo
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    await db.enqueueWordForSrs(found.id, nowMs);
    final dueCards = await db.getDueReviewCards(nowMs);
    expect(dueCards.length, 1);
    expect(dueCards.first.vocab.word, 'schedule');
  });
}
