import 'dart:convert';
import 'dart:math';

import '../../../core/database/app_database.dart';
import '../../srs/data/srs_repository.dart';

/// Pasangan contoh kalimat Inggris & terjemahan Indonesianya pada materi Grammar.
class GrammarExample {
  const GrammarExample({
    required this.en,
    required this.id,
  });

  factory GrammarExample.fromJson(Map<String, dynamic> json) {
    return GrammarExample(
      en: (json['en'] as String? ?? '').trim(),
      id: (json['id'] as String? ?? '').trim(),
    );
  }

  final String en;
  final String id;
}

/// Satu soal latihan menyusun kata (Sentence Builder).
class SentenceQuizItem {
  const SentenceQuizItem({
    required this.promptId,
    required this.targetWords,
    required this.distractors,
    required this.hint,
  });

  factory SentenceQuizItem.fromJson(Map<String, dynamic> json) {
    return SentenceQuizItem(
      promptId: (json['prompt_id'] as String? ?? '').trim(),
      targetWords: (json['target_words'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      distractors: (json['distractors'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      hint: (json['hint'] as String? ?? '').trim(),
    );
  }

  final String promptId;
  final List<String> targetWords;
  final List<String> distractors;
  final String hint;

  /// Kalimat bahasa Inggris utuh yang benar (untuk dibacakan via TTS saat benar).
  String get targetSentence => targetWords.join(' ');

  /// Memeriksa apakah daftar kata yang disusun pengguna persis sama dengan target.
  bool isCorrectOrder(List<String> userWords) {
    if (userWords.length != targetWords.length) return false;
    for (var i = 0; i < targetWords.length; i++) {
      if (userWords[i] != targetWords[i]) return false;
    }
    return true;
  }

  /// Membuat bank chip kata berindeks unik (mengamankan kata kembar seperti dua kata 'at').
  List<IndexedWordChip> buildShuffledBank({Random? random}) {
    final combined = [...targetWords, ...distractors];
    final chips = [
      for (var i = 0; i < combined.length; i++)
        IndexedWordChip(id: i, text: combined[i]),
    ];
    chips.shuffle(random ?? Random());
    return chips;
  }
}

/// Representasi satu keping kata dengan ID unik agar kata yang muncul dua kali
/// dalam satu kalimat tetap dapat dipilih secara independen.
class IndexedWordChip {
  const IndexedWordChip({
    required this.id,
    required this.text,
  });

  final int id;
  final String text;
}

/// Data materi Grammar yang sudah di-decode contoh & kuisnya.
class ParsedGrammarLesson {
  const ParsedGrammarLesson({
    required this.lesson,
    required this.examples,
    required this.quizzes,
  });

  final GrammarLesson lesson;
  final List<GrammarExample> examples;
  final List<SentenceQuizItem> quizzes;
}

class GrammarRepository {
  const GrammarRepository(this._db);

  final AppDatabase _db;

  /// Mengurai JSON `examplesJson` dan `quizJson` dari baris tabel Drift.
  static ParsedGrammarLesson parseLesson(GrammarLesson row) {
    final rawExamples = (jsonDecode(row.examplesJson) as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final rawQuizzes = (jsonDecode(row.quizJson) as List<dynamic>)
        .cast<Map<String, dynamic>>();

    return ParsedGrammarLesson(
      lesson: row,
      examples: rawExamples.map(GrammarExample.fromJson).toList(),
      quizzes: rawQuizzes.map(SentenceQuizItem.fromJson).toList(),
    );
  }

  /// Menandai materi grammar selesai dan menambahkan +2 menit belajar ke `daily_logs`.
  Future<void> completeLesson(
    GrammarLesson lesson, {
    DateTime? completedAt,
  }) async {
    final dt = completedAt ?? DateTime.now();
    final dateKey = SrsRepository.formatDateKey(dt);

    await _db.transaction(() async {
      await _db.markGrammarCompleted(lesson.id, completed: true);
      if (!lesson.isCompleted) {
        await _db.recordStudyActivity(
          dateKey: dateKey,
          minutesDelta: 2,
        );
      }
    });
  }
}
