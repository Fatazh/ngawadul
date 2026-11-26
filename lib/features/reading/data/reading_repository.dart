import '../../../core/database/app_database.dart';
import '../../srs/data/srs_repository.dart';

/// Token hasil pemecahan paragraf menjadi potongan kata yang bisa diketuk dan tanda baca/spasi.
class TextToken {
  const TextToken({
    required this.raw,
    required this.cleanWord,
  });

  final String raw;

  /// Kosong jika token ini hanya spasi atau tanda baca (misal ', ', '. ', '—').
  final String cleanWord;

  bool get isInteractiveWord => cleanWord.isNotEmpty;
}

/// Hasil inspeksi sebuah kata ketika pengguna mengetuknya di dalam bacaan.
class WordLookupResult {
  const WordLookupResult({
    required this.tappedWord,
    this.vocabItem,
    this.quickGlossId,
    this.isInSrsQueue = false,
  });

  final String tappedWord;

  /// Terisi jika kata (atau bentuk dasarnya) ditemukan di tabel `vocab_items`.
  final VocabItem? vocabItem;

  /// Arti cepat bawaan untuk kata penghubung/umum yang tidak ada di `vocab_items`.
  final String? quickGlossId;

  /// Apakah kata ini sudah masuk ke jadwal review `srs_progress`.
  final bool isInSrsQueue;

  bool get hasDefinition => vocabItem != null || quickGlossId != null;
}

class ReadingRepository {
  const ReadingRepository(this._db);

  final AppDatabase _db;

  static final RegExp _tokenRegex = RegExp(r"[A-Za-z]+(?:'[A-Za-z]+)?|[^A-Za-z]+");

  /// Peta bentuk lampau / tidak beraturan populer ke kata dasar agar ketuk-kata akurat.
  static const Map<String, String> _irregularLemmas = {
    'woke': 'early', // fallback ditangani di _quickGlossary juga
    'went': 'go',
    'bought': 'buy',
    'paid': 'pay',
    'ate': 'eat',
    'drank': 'drink',
    'slept': 'sleep',
    'left': 'leave',
    'sent': 'message',
    'felt': 'feel',
    'taught': 'teach',
    'took': 'take',
    'made': 'make',
    'had': 'have',
    'has': 'have',
    'did': 'do',
    'does': 'do',
    'was': 'be',
    'were': 'be',
    'am': 'be',
    'is': 'be',
    'are': 'be',
    'won\'t': 'will',
    'don\'t': 'do',
    'didn\'t': 'do',
    'haven\'t': 'have',
  };

  /// Kamus kilat offline untuk kata penghubung, kata ganti, & kosakata umum di bacaan.
  static const Map<String, String> _quickGlossary = {
    'a': 'sebuah / seorang / suatu',
    'an': 'sebuah / seorang (di depan bunyi vokal)',
    'the': 'itu / tersebut (penegas benda spesifik)',
    'and': 'dan',
    'or': 'atau',
    'but': 'tetapi',
    'so': 'jadi / sehingga',
    'because': 'karena',
    'if': 'jika / kalau',
    'unless': 'kecuali jika',
    'while': 'sementara / sambil',
    'when': 'ketika / saat',
    'whenever': 'setiap kali / kapan pun',
    'before': 'sebelum',
    'after': 'setelah / sesudah',
    'until': 'sampai / hingga',
    'during': 'selama (berlangsungnya sesuatu)',
    'between': 'di antara (dua hal)',
    'without': 'tanpa',
    'with': 'dengan / bersama',
    'about': 'tentang / sekitar',
    'from': 'dari',
    'into': 'ke dalam',
    'through': 'melalui / melewati',
    'instead': 'sebaliknya / alih-alih',
    'however': 'namun / akan tetapi',
    'unfortunately': 'sayangnya',
    'recently': 'baru-baru ini',
    'usually': 'biasanya',
    'always': 'selalu',
    'often': 'sering',
    'sometimes': 'kadang-kadang',
    'never': 'tidak pernah',
    'already': 'sudah',
    'still': 'masih',
    'yet': 'belum (di akhir kalimat negatif/tanya)',
    'every': 'setiap',
    'everyone': 'semua orang',
    'everything': 'semuanya / segala sesuatu',
    'something': 'sesuatu',
    'anything': 'apa pun / sesuatu',
    'wake': 'bangun tidur (wake up)',
    'woke': 'bangun tidur (bentuk lampau dari wake)',
    'cook': 'memasak',
    'save': 'menabung / menyimpan',
    'ask': 'bertanya / meminta',
    'asked': 'meminta / bertanya (lampau)',
    'write': 'menulis',
    'writing': 'sedang menulis',
    'worked': 'bekerja (bentuk lampau dari work)',
    'work': 'bekerja / pekerjaan',
    'learning': 'sedang belajar / mempelajari',
    'learn': 'belajar',
    'check': 'mengecek / memeriksa',
    'checking': 'sedang mengecek',
    'order': 'memesan / urutan',
    'visit': 'mengunjungi / berkunjung',
    'visits': 'mengunjungi',
    'rest': 'istirahat',
    'glass': 'gelas',
    'warm': 'hangat',
    'water': 'air',
    'lunch': 'makan siang',
    'breakfast': 'sarapan',
    'dinner': 'makan malam',
    'report': 'laporan',
    'reports': 'laporan-laporan',
    'project': 'proyek',
    'client': 'klien / pelanggan bisnis',
    'aisle': 'lorong (kursi pinggir jalan di pesawat/kereta)',
    'seat': 'kursi / tempat duduk',
    'gate': 'gerbang',
    'snack': 'camilan',
    'snacks': 'camilan-camilan',
    'delivery': 'pesan-antar / pengiriman',
    'fee': 'biaya / ongkos',
    'fees': 'biaya-biaya / ongkos',
    'adult': 'orang dewasa',
    'adults': 'orang-orang dewasa',
    'language': 'bahasa',
    'advantage': 'keuntungan / keunggulan',
    'brain': 'otak',
    'natural': 'alami',
    'naturally': 'secara alami',
    'shame': 'rasa malu',
    'overtime': 'lembur',
    'boundary': 'batasan sehat',
    'boundaries': 'batasan-batasan sehat',
    'workload': 'beban kerja',
    'summary': 'ringkasan',
    'be': 'kata penghubung kondisi/sifat (am, is, are, was, were)',
    'will': 'akan',
    'won\'t': 'tidak akan (singkatan will not)',
    'don\'t': 'tidak (singkatan do not)',
    'didn\'t': 'tidak (lampau, singkatan did not)',
  };

  /// Memecah paragraf bahasa Inggris menjadi daftar token kata & tanda baca tanpa merusak spasi.
  static List<TextToken> tokenizeParagraph(String text) {
    final matches = _tokenRegex.allMatches(text);
    return matches.map((m) {
      final raw = m.group(0)!;
      final isWord = RegExp(r'^[A-Za-z]').hasMatch(raw);
      return TextToken(
        raw: raw,
        cleanWord: isWord ? raw.toLowerCase() : '',
      );
    }).toList();
  }

  /// Menghasilkan kandidat kata dasar (stemming ringan bahasa Inggris) untuk dicari di DB.
  static List<String> generateLemmaCandidates(String rawWord) {
    final w = rawWord.trim().toLowerCase();
    if (w.isEmpty) return const [];

    final candidates = <String>{w};

    final irregular = _irregularLemmas[w];
    if (irregular != null) {
      candidates.add(irregular);
    }

    if (w.endsWith("n't") && w.length > 4) {
      candidates.add(w.substring(0, w.length - 3));
    }
    if (w.endsWith("'s") && w.length > 3) {
      candidates.add(w.substring(0, w.length - 2));
    }
    if (w.endsWith('ies') && w.length > 4) {
      candidates.add('${w.substring(0, w.length - 3)}y');
    }
    if (w.endsWith('es') && w.length > 4) {
      candidates.add(w.substring(0, w.length - 2));
      candidates.add(w.substring(0, w.length - 1));
    }
    if (w.endsWith('s') && !w.endsWith('ss') && w.length > 3) {
      candidates.add(w.substring(0, w.length - 1));
    }
    if (w.endsWith('ed') && w.length > 4) {
      candidates.add(w.substring(0, w.length - 2));
      candidates.add(w.substring(0, w.length - 1));
      if (w.endsWith('ied')) {
        candidates.add('${w.substring(0, w.length - 3)}y');
      }
    }
    if (w.endsWith('ing') && w.length > 5) {
      final stem = w.substring(0, w.length - 3);
      candidates.add(stem);
      candidates.add('${stem}e');
    }
    if (w.endsWith('ly') && w.length > 4) {
      candidates.add(w.substring(0, w.length - 2));
    }

    return candidates.toList();
  }

  /// Mencari arti kata di tabel `vocab_items` (termasuk bentuk dasarnya) dan mengecek status SRS.
  Future<WordLookupResult> lookupWord(String tappedWord) async {
    final candidates = generateLemmaCandidates(tappedWord);

    for (final candidate in candidates) {
      final vocab = await _db.findVocabByWord(candidate);
      if (vocab != null) {
        final srsRow = await (_db.select(_db.srsProgress)
              ..where((t) => t.vocabId.equals(vocab.id)))
            .getSingleOrNull();
        return WordLookupResult(
          tappedWord: tappedWord,
          vocabItem: vocab,
          isInSrsQueue: srsRow != null,
        );
      }
    }

    for (final candidate in candidates) {
      final gloss = _quickGlossary[candidate];
      if (gloss != null) {
        return WordLookupResult(
          tappedWord: tappedWord,
          quickGlossId: gloss,
        );
      }
    }

    return WordLookupResult(tappedWord: tappedWord);
  }

  /// Memasukkan kata dari `vocab_items` ke antrean SRS harian.
  Future<void> addVocabToSrsQueue(int vocabId, {DateTime? now}) async {
    final nowMs = (now ?? DateTime.now()).millisecondsSinceEpoch;
    await _db.enqueueWordForSrs(vocabId, nowMs);
  }

  /// Menambahkan kata baru temuan user dari bacaan ke `vocab_items` sekaligus ke antrean SRS!
  Future<VocabItem> saveCustomWordAndEnqueue({
    required String word,
    required String meaningId,
    required String contextSentenceEn,
    DateTime? now,
  }) async {
    final normalizedWord = word.trim().toLowerCase();
    final nowMs = (now ?? DateTime.now()).millisecondsSinceEpoch;

    return _db.transaction(() async {
      final existing = await _db.findVocabByWord(normalizedWord);
      late final VocabItem item;

      if (existing != null) {
        item = existing;
      } else {
        final insertedId = await _db.into(_db.vocabItems).insert(
              VocabItemsCompanion.insert(
                word: normalizedWord,
                phonetic: '/$normalizedWord/',
                partOfSpeech: 'vocab',
                meaningId: meaningId.trim(),
                exampleEn: contextSentenceEn.trim(),
                exampleId: 'Disimpan dari bacaan kontekstual.',
                category: 'reading',
                level: 'A2',
              ),
            );
        item = await (_db.select(_db.vocabItems)
              ..where((t) => t.id.equals(insertedId)))
            .getSingle();
      }

      await _db.enqueueWordForSrs(item.id, nowMs);
      return item;
    });
  }

  /// Menandai bacaan telah selesai dibaca dan mencatat durasi 3 menit di `daily_logs`.
  Future<void> completePassageReading(
    ReadingPassage passage, {
    DateTime? completedAt,
  }) async {
    final dt = completedAt ?? DateTime.now();
    final dateKey = SrsRepository.formatDateKey(dt);

    await _db.transaction(() async {
      await _db.markPassageRead(passage.id, isRead: true);
      if (!passage.isRead) {
        await _db.recordStudyActivity(
          dateKey: dateKey,
          minutesDelta: 3,
        );
      }
    });
  }
}
