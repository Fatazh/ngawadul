import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_database.dart';

/// Mengisi tabel SQLite (Drift) dengan data awal A1-B1 dari file JSON assets
/// dalam satu transaksi batch yang idempotent (aman dijalankan ulang saat update versi konten).
class SeedLoader {
  SeedLoader({
    required this.database,
    AssetBundle? bundle,
  }) : _bundle = bundle ?? rootBundle;

  final AppDatabase database;
  final AssetBundle _bundle;

  /// Naikkan angka versi ini jika di masa depan kita menambah kosakata/bacaan baru di JSON.
  static const int currentContentSeedVersion = 1;
  static const String _prefsSeedVersionKey = 'content_seed_version';

  static const String vocabAssetPath = 'assets/data/vocab_seed.json';
  static const String readingAssetPath = 'assets/data/reading_seed.json';
  static const String grammarAssetPath = 'assets/data/grammar_seed.json';

  /// Memastikan data awal terisi pada saat pertama kali aplikasi dijalankan
  /// atau ketika `currentContentSeedVersion` meningkat.
  Future<bool> ensureSeeded({SharedPreferences? prefs}) async {
    final preferences = prefs ?? await SharedPreferences.getInstance();
    final installedVersion = preferences.getInt(_prefsSeedVersionKey) ?? 0;

    if (installedVersion >= currentContentSeedVersion) {
      // Cek pengaman tambahan (O(1) LIMIT 1) jika DB terhapus manual tapi prefs masih ada
      final existingSample =
          await (database.select(database.vocabItems)..limit(1)).get();
      if (existingSample.isNotEmpty) {
        return false;
      }
    }

    final vocabRaw = await _bundle.loadString(vocabAssetPath);
    final readingRaw = await _bundle.loadString(readingAssetPath);
    final grammarRaw = await _bundle.loadString(grammarAssetPath);

    await seedFromJsonStrings(
      vocabJson: vocabRaw,
      readingJson: readingRaw,
      grammarJson: grammarRaw,
    );

    await preferences.setInt(_prefsSeedVersionKey, currentContentSeedVersion);
    return true;
  }

  /// Memasukkan seluruh JSON string ke dalam Drift menggunakan satu transaksi `batch`
  /// dengan `InsertMode.insertOrIgnore` sehingga catatan/progres user tetap aman.
  Future<void> seedFromJsonStrings({
    required String vocabJson,
    required String readingJson,
    required String grammarJson,
  }) async {
    final vocabList = (jsonDecode(vocabJson) as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final readingList = (jsonDecode(readingJson) as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final grammarList = (jsonDecode(grammarJson) as List<dynamic>)
        .cast<Map<String, dynamic>>();

    await database.batch((batch) {
      if (vocabList.isNotEmpty) {
        batch.insertAll(
          database.vocabItems,
          vocabList.map((item) {
            final note = item['mnemonic_note'] as String?;
            return VocabItemsCompanion.insert(
              word: (item['word'] as String).trim(),
              phonetic: (item['phonetic'] as String).trim(),
              partOfSpeech: (item['part_of_speech'] as String).trim(),
              meaningId: (item['meaning_id'] as String).trim(),
              exampleEn: (item['example_en'] as String).trim(),
              exampleId: (item['example_id'] as String).trim(),
              mnemonicNote: Value(
                note != null && note.trim().isNotEmpty ? note.trim() : null,
              ),
              category: (item['category'] as String).trim(),
              level: (item['level'] as String).trim(),
            );
          }).toList(),
          mode: InsertMode.insertOrIgnore,
        );
      }

      if (readingList.isNotEmpty) {
        batch.insertAll(
          database.readingPassages,
          readingList.map((item) {
            return ReadingPassagesCompanion.insert(
              title: (item['title'] as String).trim(),
              topic: (item['topic'] as String).trim(),
              level: (item['level'] as String).trim(),
              contentEn: (item['content_en'] as String).trim(),
              contentId: (item['content_id'] as String).trim(),
            );
          }).toList(),
          mode: InsertMode.insertOrIgnore,
        );
      }

      if (grammarList.isNotEmpty) {
        batch.insertAll(
          database.grammarLessons,
          grammarList.map((item) {
            final examplesEncoded = jsonEncode(item['examples'] ?? const []);
            final quizEncoded = jsonEncode(item['quiz'] ?? const []);
            return GrammarLessonsCompanion.insert(
              title: (item['title'] as String).trim(),
              level: (item['level'] as String).trim(),
              explanationId: (item['explanation_id'] as String).trim(),
              formula: (item['formula'] as String).trim(),
              examplesJson: examplesEncoded,
              quizJson: quizEncoded,
            );
          }).toList(),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }
}
