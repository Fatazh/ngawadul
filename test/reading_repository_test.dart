import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:english_adult_learner/core/database/app_database.dart';
import 'package:english_adult_learner/core/database/seed_loader.dart';
import 'package:english_adult_learner/features/reading/data/reading_repository.dart';

void main() {
  late AppDatabase db;
  late ReadingRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = ReadingRepository(db);

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

  test('tokenizeParagraph memisahkan kata dari tanda baca dan em-dash', () {
    final tokens = ReadingRepository.tokenizeParagraph(
      "real situations—like writing emails, commuting!",
    );
    final words = tokens
        .where((t) => t.isInteractiveWord)
        .map((t) => t.cleanWord)
        .toList();

    expect(
      words,
      ['real', 'situations', 'like', 'writing', 'emails', 'commuting'],
    );
  });

  test('lookupWord mengenali bentuk jamak/imbuhan ke vocab_items dan kamus kilat', () async {
    final pluralMeeting = await repo.lookupWord('meetings');
    expect(pluralMeeting.vocabItem, isNotNull);
    expect(pluralMeeting.vocabItem!.word, 'meeting');
    expect(pluralMeeting.isInSrsQueue, isFalse);

    final pluralPriority = await repo.lookupWord('priorities');
    expect(pluralPriority.vocabItem, isNotNull);
    expect(pluralPriority.vocabItem!.word, 'priority');

    final conjunction = await repo.lookupWord('Because');
    expect(conjunction.vocabItem, isNull);
    expect(conjunction.quickGlossId, 'karena');
  });

  test('saveCustomWordAndEnqueue menambahkan kata baru ke vocab_items dan SRS', () async {
    final saved = await repo.saveCustomWordAndEnqueue(
      word: 'spreadsheet',
      meaningId: 'lembar kerja tabel angka',
      contextSentenceEn: 'My colleague helped me fix the spreadsheet.',
      now: DateTime.utc(2026, 11, 26, 10, 0),
    );

    expect(saved.word, 'spreadsheet');
    final checkAgain = await repo.lookupWord('spreadsheet');
    expect(checkAgain.vocabItem, isNotNull);
    expect(checkAgain.isInSrsQueue, isTrue);
  });

  test('completePassageReading menandai bacaan selesai dan menambah 3 menit belajar', () async {
    final passages = await db.select(db.readingPassages).get();
    final first = passages.first;
    expect(first.isRead, isFalse);

    final now = DateTime.utc(2026, 11, 26, 12, 0);
    await repo.completePassageReading(first, completedAt: now);

    final updated = await (db.select(db.readingPassages)
          ..where((t) => t.id.equals(first.id)))
        .getSingle();
    expect(updated.isRead, isTrue);

    final log = await (db.select(db.dailyLogs)
          ..where((t) => t.date.equals('2026-11-26')))
        .getSingle();
    expect(log.minutesSpent, 3);
  });
}
