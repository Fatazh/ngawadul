import 'package:drift/drift.dart';

/// Tabel 1: Bank kosakata bahasa Inggris level A1 - B1.
@DataClassName('VocabItem')
class VocabItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Kata atau frasa bahasa Inggris (unik, huruf kecil/standar).
  TextColumn get word => text().unique()();

  /// Cara baca fonetik / panduan pelafalan ramah lidah Indonesia.
  TextColumn get phonetic => text()();

  /// Kelas kata: noun, verb, adj, adv, phrase, prep.
  TextColumn get partOfSpeech => text()();

  /// Arti utama dalam bahasa Indonesia yang ringkas & tepat konteks.
  TextColumn get meaningId => text()();

  /// Contoh kalimat nyata dalam bahasa Inggris (konteks kerja/sehari-hari).
  TextColumn get exampleEn => text()();

  /// Terjemahan alami contoh kalimat dalam bahasa Indonesia.
  TextColumn get exampleId => text()();

  /// Jembatan keledai / catatan asosiasi memori (bisa diubah oleh user).
  TextColumn get mnemonicNote => text().nullable()();

  /// Kategori topik: daily, work, travel, social, tech.
  TextColumn get category => text()();

  /// Level CEFR: A1, A2, atau B1.
  TextColumn get level => text()();
}

/// Tabel 2: Status progres hafalan tiap kata (Algoritma Spaced Repetition SM-2).
@DataClassName('SrsProgressEntry')
class SrsProgress extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Relasi 1-ke-1 dengan VocabItems.
  IntColumn get vocabId =>
      integer().unique().references(VocabItems, #id, onDelete: KeyAction.cascade)();

  /// Faktor kemudahan SM-2 (default 2.5, minimum 1.3).
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();

  /// Jarak hari menuju pengulangan berikutnya.
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();

  /// Jumlah pengulangan berturut-turut yang berhasil diingat.
  IntColumn get repetitions => integer().withDefault(const Constant(0))();

  /// Status penguasaan: 'new', 'learning', atau 'mastered'.
  TextColumn get status => text().withDefault(const Constant('new'))();

  /// Jadwal review berikutnya dalam Unix epoch milliseconds.
  IntColumn get nextReviewAt => integer()();

  /// Waktu terakhir kata ini di-review (Unix epoch milliseconds).
  IntColumn get lastReviewedAt => integer().nullable()();
}

/// Tabel 3: Daftar bacaan pendek (Micro-Reading) kontekstual usia dewasa.
@DataClassName('ReadingPassage')
class ReadingPassages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().unique()();
  TextColumn get topic => text()();
  TextColumn get level => text()();
  TextColumn get contentEn => text()();
  TextColumn get contentId => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
}

/// Tabel 4: Materi pola kalimat (Grammar Intuitif) & soal Sentence Builder.
@DataClassName('GrammarLesson')
class GrammarLessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().unique()();
  TextColumn get level => text()();
  TextColumn get explanationId => text()();
  TextColumn get formula => text()();

  /// JSON list berisi pasangan contoh kalimat Inggris & Indonesia.
  TextColumn get examplesJson => text()();

  /// JSON list berisi soal interaktif Sentence Builder.
  TextColumn get quizJson => text()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}

/// Tabel 5: Log kebiasaan belajar harian (Habit & Streak Tracker).
@DataClassName('DailyLog')
class DailyLogs extends Table {
  /// Tanggal lokal format 'YYYY-MM-DD' sebagai Primary Key.
  TextColumn get date => text()();

  IntColumn get wordsReviewed => integer().withDefault(const Constant(0))();
  IntColumn get wordsLearned => integer().withDefault(const Constant(0))();
  IntColumn get minutesSpent => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {date};
}
