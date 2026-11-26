// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VocabItemsTable extends VocabItems
    with TableInfo<$VocabItemsTable, VocabItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
      'word', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _phoneticMeta =
      const VerificationMeta('phonetic');
  @override
  late final GeneratedColumn<String> phonetic = GeneratedColumn<String>(
      'phonetic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _partOfSpeechMeta =
      const VerificationMeta('partOfSpeech');
  @override
  late final GeneratedColumn<String> partOfSpeech = GeneratedColumn<String>(
      'part_of_speech', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _meaningIdMeta =
      const VerificationMeta('meaningId');
  @override
  late final GeneratedColumn<String> meaningId = GeneratedColumn<String>(
      'meaning_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exampleEnMeta =
      const VerificationMeta('exampleEn');
  @override
  late final GeneratedColumn<String> exampleEn = GeneratedColumn<String>(
      'example_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exampleIdMeta =
      const VerificationMeta('exampleId');
  @override
  late final GeneratedColumn<String> exampleId = GeneratedColumn<String>(
      'example_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mnemonicNoteMeta =
      const VerificationMeta('mnemonicNote');
  @override
  late final GeneratedColumn<String> mnemonicNote = GeneratedColumn<String>(
      'mnemonic_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        word,
        phonetic,
        partOfSpeech,
        meaningId,
        exampleEn,
        exampleId,
        mnemonicNote,
        category,
        level
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocab_items';
  @override
  VerificationContext validateIntegrity(Insertable<VocabItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word')) {
      context.handle(
          _wordMeta, word.isAcceptableOrUnknown(data['word']!, _wordMeta));
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('phonetic')) {
      context.handle(_phoneticMeta,
          phonetic.isAcceptableOrUnknown(data['phonetic']!, _phoneticMeta));
    } else if (isInserting) {
      context.missing(_phoneticMeta);
    }
    if (data.containsKey('part_of_speech')) {
      context.handle(
          _partOfSpeechMeta,
          partOfSpeech.isAcceptableOrUnknown(
              data['part_of_speech']!, _partOfSpeechMeta));
    } else if (isInserting) {
      context.missing(_partOfSpeechMeta);
    }
    if (data.containsKey('meaning_id')) {
      context.handle(_meaningIdMeta,
          meaningId.isAcceptableOrUnknown(data['meaning_id']!, _meaningIdMeta));
    } else if (isInserting) {
      context.missing(_meaningIdMeta);
    }
    if (data.containsKey('example_en')) {
      context.handle(_exampleEnMeta,
          exampleEn.isAcceptableOrUnknown(data['example_en']!, _exampleEnMeta));
    } else if (isInserting) {
      context.missing(_exampleEnMeta);
    }
    if (data.containsKey('example_id')) {
      context.handle(_exampleIdMeta,
          exampleId.isAcceptableOrUnknown(data['example_id']!, _exampleIdMeta));
    } else if (isInserting) {
      context.missing(_exampleIdMeta);
    }
    if (data.containsKey('mnemonic_note')) {
      context.handle(
          _mnemonicNoteMeta,
          mnemonicNote.isAcceptableOrUnknown(
              data['mnemonic_note']!, _mnemonicNoteMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      word: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}word'])!,
      phonetic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phonetic'])!,
      partOfSpeech: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}part_of_speech'])!,
      meaningId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meaning_id'])!,
      exampleEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_en'])!,
      exampleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_id'])!,
      mnemonicNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mnemonic_note']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
    );
  }

  @override
  $VocabItemsTable createAlias(String alias) {
    return $VocabItemsTable(attachedDatabase, alias);
  }
}

class VocabItem extends DataClass implements Insertable<VocabItem> {
  final int id;

  /// Kata atau frasa bahasa Inggris (unik, huruf kecil/standar).
  final String word;

  /// Cara baca fonetik / panduan pelafalan ramah lidah Indonesia.
  final String phonetic;

  /// Kelas kata: noun, verb, adj, adv, phrase, prep.
  final String partOfSpeech;

  /// Arti utama dalam bahasa Indonesia yang ringkas & tepat konteks.
  final String meaningId;

  /// Contoh kalimat nyata dalam bahasa Inggris (konteks kerja/sehari-hari).
  final String exampleEn;

  /// Terjemahan alami contoh kalimat dalam bahasa Indonesia.
  final String exampleId;

  /// Jembatan keledai / catatan asosiasi memori (bisa diubah oleh user).
  final String? mnemonicNote;

  /// Kategori topik: daily, work, travel, social, tech.
  final String category;

  /// Level CEFR: A1, A2, atau B1.
  final String level;
  const VocabItem(
      {required this.id,
      required this.word,
      required this.phonetic,
      required this.partOfSpeech,
      required this.meaningId,
      required this.exampleEn,
      required this.exampleId,
      this.mnemonicNote,
      required this.category,
      required this.level});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word'] = Variable<String>(word);
    map['phonetic'] = Variable<String>(phonetic);
    map['part_of_speech'] = Variable<String>(partOfSpeech);
    map['meaning_id'] = Variable<String>(meaningId);
    map['example_en'] = Variable<String>(exampleEn);
    map['example_id'] = Variable<String>(exampleId);
    if (!nullToAbsent || mnemonicNote != null) {
      map['mnemonic_note'] = Variable<String>(mnemonicNote);
    }
    map['category'] = Variable<String>(category);
    map['level'] = Variable<String>(level);
    return map;
  }

  VocabItemsCompanion toCompanion(bool nullToAbsent) {
    return VocabItemsCompanion(
      id: Value(id),
      word: Value(word),
      phonetic: Value(phonetic),
      partOfSpeech: Value(partOfSpeech),
      meaningId: Value(meaningId),
      exampleEn: Value(exampleEn),
      exampleId: Value(exampleId),
      mnemonicNote: mnemonicNote == null && nullToAbsent
          ? const Value.absent()
          : Value(mnemonicNote),
      category: Value(category),
      level: Value(level),
    );
  }

  factory VocabItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabItem(
      id: serializer.fromJson<int>(json['id']),
      word: serializer.fromJson<String>(json['word']),
      phonetic: serializer.fromJson<String>(json['phonetic']),
      partOfSpeech: serializer.fromJson<String>(json['partOfSpeech']),
      meaningId: serializer.fromJson<String>(json['meaningId']),
      exampleEn: serializer.fromJson<String>(json['exampleEn']),
      exampleId: serializer.fromJson<String>(json['exampleId']),
      mnemonicNote: serializer.fromJson<String?>(json['mnemonicNote']),
      category: serializer.fromJson<String>(json['category']),
      level: serializer.fromJson<String>(json['level']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'word': serializer.toJson<String>(word),
      'phonetic': serializer.toJson<String>(phonetic),
      'partOfSpeech': serializer.toJson<String>(partOfSpeech),
      'meaningId': serializer.toJson<String>(meaningId),
      'exampleEn': serializer.toJson<String>(exampleEn),
      'exampleId': serializer.toJson<String>(exampleId),
      'mnemonicNote': serializer.toJson<String?>(mnemonicNote),
      'category': serializer.toJson<String>(category),
      'level': serializer.toJson<String>(level),
    };
  }

  VocabItem copyWith(
          {int? id,
          String? word,
          String? phonetic,
          String? partOfSpeech,
          String? meaningId,
          String? exampleEn,
          String? exampleId,
          Value<String?> mnemonicNote = const Value.absent(),
          String? category,
          String? level}) =>
      VocabItem(
        id: id ?? this.id,
        word: word ?? this.word,
        phonetic: phonetic ?? this.phonetic,
        partOfSpeech: partOfSpeech ?? this.partOfSpeech,
        meaningId: meaningId ?? this.meaningId,
        exampleEn: exampleEn ?? this.exampleEn,
        exampleId: exampleId ?? this.exampleId,
        mnemonicNote:
            mnemonicNote.present ? mnemonicNote.value : this.mnemonicNote,
        category: category ?? this.category,
        level: level ?? this.level,
      );
  VocabItem copyWithCompanion(VocabItemsCompanion data) {
    return VocabItem(
      id: data.id.present ? data.id.value : this.id,
      word: data.word.present ? data.word.value : this.word,
      phonetic: data.phonetic.present ? data.phonetic.value : this.phonetic,
      partOfSpeech: data.partOfSpeech.present
          ? data.partOfSpeech.value
          : this.partOfSpeech,
      meaningId: data.meaningId.present ? data.meaningId.value : this.meaningId,
      exampleEn: data.exampleEn.present ? data.exampleEn.value : this.exampleEn,
      exampleId: data.exampleId.present ? data.exampleId.value : this.exampleId,
      mnemonicNote: data.mnemonicNote.present
          ? data.mnemonicNote.value
          : this.mnemonicNote,
      category: data.category.present ? data.category.value : this.category,
      level: data.level.present ? data.level.value : this.level,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabItem(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('phonetic: $phonetic, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('meaningId: $meaningId, ')
          ..write('exampleEn: $exampleEn, ')
          ..write('exampleId: $exampleId, ')
          ..write('mnemonicNote: $mnemonicNote, ')
          ..write('category: $category, ')
          ..write('level: $level')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, word, phonetic, partOfSpeech, meaningId,
      exampleEn, exampleId, mnemonicNote, category, level);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabItem &&
          other.id == this.id &&
          other.word == this.word &&
          other.phonetic == this.phonetic &&
          other.partOfSpeech == this.partOfSpeech &&
          other.meaningId == this.meaningId &&
          other.exampleEn == this.exampleEn &&
          other.exampleId == this.exampleId &&
          other.mnemonicNote == this.mnemonicNote &&
          other.category == this.category &&
          other.level == this.level);
}

class VocabItemsCompanion extends UpdateCompanion<VocabItem> {
  final Value<int> id;
  final Value<String> word;
  final Value<String> phonetic;
  final Value<String> partOfSpeech;
  final Value<String> meaningId;
  final Value<String> exampleEn;
  final Value<String> exampleId;
  final Value<String?> mnemonicNote;
  final Value<String> category;
  final Value<String> level;
  const VocabItemsCompanion({
    this.id = const Value.absent(),
    this.word = const Value.absent(),
    this.phonetic = const Value.absent(),
    this.partOfSpeech = const Value.absent(),
    this.meaningId = const Value.absent(),
    this.exampleEn = const Value.absent(),
    this.exampleId = const Value.absent(),
    this.mnemonicNote = const Value.absent(),
    this.category = const Value.absent(),
    this.level = const Value.absent(),
  });
  VocabItemsCompanion.insert({
    this.id = const Value.absent(),
    required String word,
    required String phonetic,
    required String partOfSpeech,
    required String meaningId,
    required String exampleEn,
    required String exampleId,
    this.mnemonicNote = const Value.absent(),
    required String category,
    required String level,
  })  : word = Value(word),
        phonetic = Value(phonetic),
        partOfSpeech = Value(partOfSpeech),
        meaningId = Value(meaningId),
        exampleEn = Value(exampleEn),
        exampleId = Value(exampleId),
        category = Value(category),
        level = Value(level);
  static Insertable<VocabItem> custom({
    Expression<int>? id,
    Expression<String>? word,
    Expression<String>? phonetic,
    Expression<String>? partOfSpeech,
    Expression<String>? meaningId,
    Expression<String>? exampleEn,
    Expression<String>? exampleId,
    Expression<String>? mnemonicNote,
    Expression<String>? category,
    Expression<String>? level,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (word != null) 'word': word,
      if (phonetic != null) 'phonetic': phonetic,
      if (partOfSpeech != null) 'part_of_speech': partOfSpeech,
      if (meaningId != null) 'meaning_id': meaningId,
      if (exampleEn != null) 'example_en': exampleEn,
      if (exampleId != null) 'example_id': exampleId,
      if (mnemonicNote != null) 'mnemonic_note': mnemonicNote,
      if (category != null) 'category': category,
      if (level != null) 'level': level,
    });
  }

  VocabItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? word,
      Value<String>? phonetic,
      Value<String>? partOfSpeech,
      Value<String>? meaningId,
      Value<String>? exampleEn,
      Value<String>? exampleId,
      Value<String?>? mnemonicNote,
      Value<String>? category,
      Value<String>? level}) {
    return VocabItemsCompanion(
      id: id ?? this.id,
      word: word ?? this.word,
      phonetic: phonetic ?? this.phonetic,
      partOfSpeech: partOfSpeech ?? this.partOfSpeech,
      meaningId: meaningId ?? this.meaningId,
      exampleEn: exampleEn ?? this.exampleEn,
      exampleId: exampleId ?? this.exampleId,
      mnemonicNote: mnemonicNote ?? this.mnemonicNote,
      category: category ?? this.category,
      level: level ?? this.level,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (phonetic.present) {
      map['phonetic'] = Variable<String>(phonetic.value);
    }
    if (partOfSpeech.present) {
      map['part_of_speech'] = Variable<String>(partOfSpeech.value);
    }
    if (meaningId.present) {
      map['meaning_id'] = Variable<String>(meaningId.value);
    }
    if (exampleEn.present) {
      map['example_en'] = Variable<String>(exampleEn.value);
    }
    if (exampleId.present) {
      map['example_id'] = Variable<String>(exampleId.value);
    }
    if (mnemonicNote.present) {
      map['mnemonic_note'] = Variable<String>(mnemonicNote.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabItemsCompanion(')
          ..write('id: $id, ')
          ..write('word: $word, ')
          ..write('phonetic: $phonetic, ')
          ..write('partOfSpeech: $partOfSpeech, ')
          ..write('meaningId: $meaningId, ')
          ..write('exampleEn: $exampleEn, ')
          ..write('exampleId: $exampleId, ')
          ..write('mnemonicNote: $mnemonicNote, ')
          ..write('category: $category, ')
          ..write('level: $level')
          ..write(')'))
        .toString();
  }
}

class $SrsProgressTable extends SrsProgress
    with TableInfo<$SrsProgressTable, SrsProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrsProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _vocabIdMeta =
      const VerificationMeta('vocabId');
  @override
  late final GeneratedColumn<int> vocabId = GeneratedColumn<int>(
      'vocab_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'UNIQUE REFERENCES vocab_items (id) ON DELETE CASCADE'));
  static const VerificationMeta _easeFactorMeta =
      const VerificationMeta('easeFactor');
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
      'ease_factor', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(2.5));
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
      'interval_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _repetitionsMeta =
      const VerificationMeta('repetitions');
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
      'repetitions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('new'));
  static const VerificationMeta _nextReviewAtMeta =
      const VerificationMeta('nextReviewAt');
  @override
  late final GeneratedColumn<int> nextReviewAt = GeneratedColumn<int>(
      'next_review_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastReviewedAtMeta =
      const VerificationMeta('lastReviewedAt');
  @override
  late final GeneratedColumn<int> lastReviewedAt = GeneratedColumn<int>(
      'last_reviewed_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        vocabId,
        easeFactor,
        intervalDays,
        repetitions,
        status,
        nextReviewAt,
        lastReviewedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srs_progress';
  @override
  VerificationContext validateIntegrity(Insertable<SrsProgressEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vocab_id')) {
      context.handle(_vocabIdMeta,
          vocabId.isAcceptableOrUnknown(data['vocab_id']!, _vocabIdMeta));
    } else if (isInserting) {
      context.missing(_vocabIdMeta);
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
          _easeFactorMeta,
          easeFactor.isAcceptableOrUnknown(
              data['ease_factor']!, _easeFactorMeta));
    }
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    }
    if (data.containsKey('repetitions')) {
      context.handle(
          _repetitionsMeta,
          repetitions.isAcceptableOrUnknown(
              data['repetitions']!, _repetitionsMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('next_review_at')) {
      context.handle(
          _nextReviewAtMeta,
          nextReviewAt.isAcceptableOrUnknown(
              data['next_review_at']!, _nextReviewAtMeta));
    } else if (isInserting) {
      context.missing(_nextReviewAtMeta);
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
          _lastReviewedAtMeta,
          lastReviewedAt.isAcceptableOrUnknown(
              data['last_reviewed_at']!, _lastReviewedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SrsProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrsProgressEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      vocabId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vocab_id'])!,
      easeFactor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ease_factor'])!,
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_days'])!,
      repetitions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}repetitions'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      nextReviewAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}next_review_at'])!,
      lastReviewedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_reviewed_at']),
    );
  }

  @override
  $SrsProgressTable createAlias(String alias) {
    return $SrsProgressTable(attachedDatabase, alias);
  }
}

class SrsProgressEntry extends DataClass
    implements Insertable<SrsProgressEntry> {
  final int id;

  /// Relasi 1-ke-1 dengan VocabItems.
  final int vocabId;

  /// Faktor kemudahan SM-2 (default 2.5, minimum 1.3).
  final double easeFactor;

  /// Jarak hari menuju pengulangan berikutnya.
  final int intervalDays;

  /// Jumlah pengulangan berturut-turut yang berhasil diingat.
  final int repetitions;

  /// Status penguasaan: 'new', 'learning', atau 'mastered'.
  final String status;

  /// Jadwal review berikutnya dalam Unix epoch milliseconds.
  final int nextReviewAt;

  /// Waktu terakhir kata ini di-review (Unix epoch milliseconds).
  final int? lastReviewedAt;
  const SrsProgressEntry(
      {required this.id,
      required this.vocabId,
      required this.easeFactor,
      required this.intervalDays,
      required this.repetitions,
      required this.status,
      required this.nextReviewAt,
      this.lastReviewedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vocab_id'] = Variable<int>(vocabId);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['interval_days'] = Variable<int>(intervalDays);
    map['repetitions'] = Variable<int>(repetitions);
    map['status'] = Variable<String>(status);
    map['next_review_at'] = Variable<int>(nextReviewAt);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<int>(lastReviewedAt);
    }
    return map;
  }

  SrsProgressCompanion toCompanion(bool nullToAbsent) {
    return SrsProgressCompanion(
      id: Value(id),
      vocabId: Value(vocabId),
      easeFactor: Value(easeFactor),
      intervalDays: Value(intervalDays),
      repetitions: Value(repetitions),
      status: Value(status),
      nextReviewAt: Value(nextReviewAt),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
    );
  }

  factory SrsProgressEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrsProgressEntry(
      id: serializer.fromJson<int>(json['id']),
      vocabId: serializer.fromJson<int>(json['vocabId']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      status: serializer.fromJson<String>(json['status']),
      nextReviewAt: serializer.fromJson<int>(json['nextReviewAt']),
      lastReviewedAt: serializer.fromJson<int?>(json['lastReviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vocabId': serializer.toJson<int>(vocabId),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'repetitions': serializer.toJson<int>(repetitions),
      'status': serializer.toJson<String>(status),
      'nextReviewAt': serializer.toJson<int>(nextReviewAt),
      'lastReviewedAt': serializer.toJson<int?>(lastReviewedAt),
    };
  }

  SrsProgressEntry copyWith(
          {int? id,
          int? vocabId,
          double? easeFactor,
          int? intervalDays,
          int? repetitions,
          String? status,
          int? nextReviewAt,
          Value<int?> lastReviewedAt = const Value.absent()}) =>
      SrsProgressEntry(
        id: id ?? this.id,
        vocabId: vocabId ?? this.vocabId,
        easeFactor: easeFactor ?? this.easeFactor,
        intervalDays: intervalDays ?? this.intervalDays,
        repetitions: repetitions ?? this.repetitions,
        status: status ?? this.status,
        nextReviewAt: nextReviewAt ?? this.nextReviewAt,
        lastReviewedAt:
            lastReviewedAt.present ? lastReviewedAt.value : this.lastReviewedAt,
      );
  SrsProgressEntry copyWithCompanion(SrsProgressCompanion data) {
    return SrsProgressEntry(
      id: data.id.present ? data.id.value : this.id,
      vocabId: data.vocabId.present ? data.vocabId.value : this.vocabId,
      easeFactor:
          data.easeFactor.present ? data.easeFactor.value : this.easeFactor,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      repetitions:
          data.repetitions.present ? data.repetitions.value : this.repetitions,
      status: data.status.present ? data.status.value : this.status,
      nextReviewAt: data.nextReviewAt.present
          ? data.nextReviewAt.value
          : this.nextReviewAt,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrsProgressEntry(')
          ..write('id: $id, ')
          ..write('vocabId: $vocabId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('repetitions: $repetitions, ')
          ..write('status: $status, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, vocabId, easeFactor, intervalDays,
      repetitions, status, nextReviewAt, lastReviewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrsProgressEntry &&
          other.id == this.id &&
          other.vocabId == this.vocabId &&
          other.easeFactor == this.easeFactor &&
          other.intervalDays == this.intervalDays &&
          other.repetitions == this.repetitions &&
          other.status == this.status &&
          other.nextReviewAt == this.nextReviewAt &&
          other.lastReviewedAt == this.lastReviewedAt);
}

class SrsProgressCompanion extends UpdateCompanion<SrsProgressEntry> {
  final Value<int> id;
  final Value<int> vocabId;
  final Value<double> easeFactor;
  final Value<int> intervalDays;
  final Value<int> repetitions;
  final Value<String> status;
  final Value<int> nextReviewAt;
  final Value<int?> lastReviewedAt;
  const SrsProgressCompanion({
    this.id = const Value.absent(),
    this.vocabId = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.status = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
  });
  SrsProgressCompanion.insert({
    this.id = const Value.absent(),
    required int vocabId,
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.status = const Value.absent(),
    required int nextReviewAt,
    this.lastReviewedAt = const Value.absent(),
  })  : vocabId = Value(vocabId),
        nextReviewAt = Value(nextReviewAt);
  static Insertable<SrsProgressEntry> custom({
    Expression<int>? id,
    Expression<int>? vocabId,
    Expression<double>? easeFactor,
    Expression<int>? intervalDays,
    Expression<int>? repetitions,
    Expression<String>? status,
    Expression<int>? nextReviewAt,
    Expression<int>? lastReviewedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vocabId != null) 'vocab_id': vocabId,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (repetitions != null) 'repetitions': repetitions,
      if (status != null) 'status': status,
      if (nextReviewAt != null) 'next_review_at': nextReviewAt,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
    });
  }

  SrsProgressCompanion copyWith(
      {Value<int>? id,
      Value<int>? vocabId,
      Value<double>? easeFactor,
      Value<int>? intervalDays,
      Value<int>? repetitions,
      Value<String>? status,
      Value<int>? nextReviewAt,
      Value<int?>? lastReviewedAt}) {
    return SrsProgressCompanion(
      id: id ?? this.id,
      vocabId: vocabId ?? this.vocabId,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      repetitions: repetitions ?? this.repetitions,
      status: status ?? this.status,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vocabId.present) {
      map['vocab_id'] = Variable<int>(vocabId.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (nextReviewAt.present) {
      map['next_review_at'] = Variable<int>(nextReviewAt.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<int>(lastReviewedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrsProgressCompanion(')
          ..write('id: $id, ')
          ..write('vocabId: $vocabId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('repetitions: $repetitions, ')
          ..write('status: $status, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }
}

class $ReadingPassagesTable extends ReadingPassages
    with TableInfo<$ReadingPassagesTable, ReadingPassage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingPassagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
      'topic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentEnMeta =
      const VerificationMeta('contentEn');
  @override
  late final GeneratedColumn<String> contentEn = GeneratedColumn<String>(
      'content_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentIdMeta =
      const VerificationMeta('contentId');
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
      'content_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, topic, level, contentEn, contentId, isRead];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_passages';
  @override
  VerificationContext validateIntegrity(Insertable<ReadingPassage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
          _topicMeta, topic.isAcceptableOrUnknown(data['topic']!, _topicMeta));
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('content_en')) {
      context.handle(_contentEnMeta,
          contentEn.isAcceptableOrUnknown(data['content_en']!, _contentEnMeta));
    } else if (isInserting) {
      context.missing(_contentEnMeta);
    }
    if (data.containsKey('content_id')) {
      context.handle(_contentIdMeta,
          contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta));
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingPassage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingPassage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      topic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      contentEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_en'])!,
      contentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_id'])!,
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
    );
  }

  @override
  $ReadingPassagesTable createAlias(String alias) {
    return $ReadingPassagesTable(attachedDatabase, alias);
  }
}

class ReadingPassage extends DataClass implements Insertable<ReadingPassage> {
  final int id;
  final String title;
  final String topic;
  final String level;
  final String contentEn;
  final String contentId;
  final bool isRead;
  const ReadingPassage(
      {required this.id,
      required this.title,
      required this.topic,
      required this.level,
      required this.contentEn,
      required this.contentId,
      required this.isRead});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['topic'] = Variable<String>(topic);
    map['level'] = Variable<String>(level);
    map['content_en'] = Variable<String>(contentEn);
    map['content_id'] = Variable<String>(contentId);
    map['is_read'] = Variable<bool>(isRead);
    return map;
  }

  ReadingPassagesCompanion toCompanion(bool nullToAbsent) {
    return ReadingPassagesCompanion(
      id: Value(id),
      title: Value(title),
      topic: Value(topic),
      level: Value(level),
      contentEn: Value(contentEn),
      contentId: Value(contentId),
      isRead: Value(isRead),
    );
  }

  factory ReadingPassage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingPassage(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      topic: serializer.fromJson<String>(json['topic']),
      level: serializer.fromJson<String>(json['level']),
      contentEn: serializer.fromJson<String>(json['contentEn']),
      contentId: serializer.fromJson<String>(json['contentId']),
      isRead: serializer.fromJson<bool>(json['isRead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'topic': serializer.toJson<String>(topic),
      'level': serializer.toJson<String>(level),
      'contentEn': serializer.toJson<String>(contentEn),
      'contentId': serializer.toJson<String>(contentId),
      'isRead': serializer.toJson<bool>(isRead),
    };
  }

  ReadingPassage copyWith(
          {int? id,
          String? title,
          String? topic,
          String? level,
          String? contentEn,
          String? contentId,
          bool? isRead}) =>
      ReadingPassage(
        id: id ?? this.id,
        title: title ?? this.title,
        topic: topic ?? this.topic,
        level: level ?? this.level,
        contentEn: contentEn ?? this.contentEn,
        contentId: contentId ?? this.contentId,
        isRead: isRead ?? this.isRead,
      );
  ReadingPassage copyWithCompanion(ReadingPassagesCompanion data) {
    return ReadingPassage(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      topic: data.topic.present ? data.topic.value : this.topic,
      level: data.level.present ? data.level.value : this.level,
      contentEn: data.contentEn.present ? data.contentEn.value : this.contentEn,
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingPassage(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('topic: $topic, ')
          ..write('level: $level, ')
          ..write('contentEn: $contentEn, ')
          ..write('contentId: $contentId, ')
          ..write('isRead: $isRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, topic, level, contentEn, contentId, isRead);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingPassage &&
          other.id == this.id &&
          other.title == this.title &&
          other.topic == this.topic &&
          other.level == this.level &&
          other.contentEn == this.contentEn &&
          other.contentId == this.contentId &&
          other.isRead == this.isRead);
}

class ReadingPassagesCompanion extends UpdateCompanion<ReadingPassage> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> topic;
  final Value<String> level;
  final Value<String> contentEn;
  final Value<String> contentId;
  final Value<bool> isRead;
  const ReadingPassagesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.topic = const Value.absent(),
    this.level = const Value.absent(),
    this.contentEn = const Value.absent(),
    this.contentId = const Value.absent(),
    this.isRead = const Value.absent(),
  });
  ReadingPassagesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String topic,
    required String level,
    required String contentEn,
    required String contentId,
    this.isRead = const Value.absent(),
  })  : title = Value(title),
        topic = Value(topic),
        level = Value(level),
        contentEn = Value(contentEn),
        contentId = Value(contentId);
  static Insertable<ReadingPassage> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? topic,
    Expression<String>? level,
    Expression<String>? contentEn,
    Expression<String>? contentId,
    Expression<bool>? isRead,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (topic != null) 'topic': topic,
      if (level != null) 'level': level,
      if (contentEn != null) 'content_en': contentEn,
      if (contentId != null) 'content_id': contentId,
      if (isRead != null) 'is_read': isRead,
    });
  }

  ReadingPassagesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? topic,
      Value<String>? level,
      Value<String>? contentEn,
      Value<String>? contentId,
      Value<bool>? isRead}) {
    return ReadingPassagesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      topic: topic ?? this.topic,
      level: level ?? this.level,
      contentEn: contentEn ?? this.contentEn,
      contentId: contentId ?? this.contentId,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (contentEn.present) {
      map['content_en'] = Variable<String>(contentEn.value);
    }
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingPassagesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('topic: $topic, ')
          ..write('level: $level, ')
          ..write('contentEn: $contentEn, ')
          ..write('contentId: $contentId, ')
          ..write('isRead: $isRead')
          ..write(')'))
        .toString();
  }
}

class $GrammarLessonsTable extends GrammarLessons
    with TableInfo<$GrammarLessonsTable, GrammarLesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarLessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _explanationIdMeta =
      const VerificationMeta('explanationId');
  @override
  late final GeneratedColumn<String> explanationId = GeneratedColumn<String>(
      'explanation_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _formulaMeta =
      const VerificationMeta('formula');
  @override
  late final GeneratedColumn<String> formula = GeneratedColumn<String>(
      'formula', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _examplesJsonMeta =
      const VerificationMeta('examplesJson');
  @override
  late final GeneratedColumn<String> examplesJson = GeneratedColumn<String>(
      'examples_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quizJsonMeta =
      const VerificationMeta('quizJson');
  @override
  late final GeneratedColumn<String> quizJson = GeneratedColumn<String>(
      'quiz_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        level,
        explanationId,
        formula,
        examplesJson,
        quizJson,
        isCompleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_lessons';
  @override
  VerificationContext validateIntegrity(Insertable<GrammarLesson> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('explanation_id')) {
      context.handle(
          _explanationIdMeta,
          explanationId.isAcceptableOrUnknown(
              data['explanation_id']!, _explanationIdMeta));
    } else if (isInserting) {
      context.missing(_explanationIdMeta);
    }
    if (data.containsKey('formula')) {
      context.handle(_formulaMeta,
          formula.isAcceptableOrUnknown(data['formula']!, _formulaMeta));
    } else if (isInserting) {
      context.missing(_formulaMeta);
    }
    if (data.containsKey('examples_json')) {
      context.handle(
          _examplesJsonMeta,
          examplesJson.isAcceptableOrUnknown(
              data['examples_json']!, _examplesJsonMeta));
    } else if (isInserting) {
      context.missing(_examplesJsonMeta);
    }
    if (data.containsKey('quiz_json')) {
      context.handle(_quizJsonMeta,
          quizJson.isAcceptableOrUnknown(data['quiz_json']!, _quizJsonMeta));
    } else if (isInserting) {
      context.missing(_quizJsonMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarLesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarLesson(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      explanationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explanation_id'])!,
      formula: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}formula'])!,
      examplesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}examples_json'])!,
      quizJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}quiz_json'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
    );
  }

  @override
  $GrammarLessonsTable createAlias(String alias) {
    return $GrammarLessonsTable(attachedDatabase, alias);
  }
}

class GrammarLesson extends DataClass implements Insertable<GrammarLesson> {
  final int id;
  final String title;
  final String level;
  final String explanationId;
  final String formula;

  /// JSON list berisi pasangan contoh kalimat Inggris & Indonesia.
  final String examplesJson;

  /// JSON list berisi soal interaktif Sentence Builder.
  final String quizJson;
  final bool isCompleted;
  const GrammarLesson(
      {required this.id,
      required this.title,
      required this.level,
      required this.explanationId,
      required this.formula,
      required this.examplesJson,
      required this.quizJson,
      required this.isCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['level'] = Variable<String>(level);
    map['explanation_id'] = Variable<String>(explanationId);
    map['formula'] = Variable<String>(formula);
    map['examples_json'] = Variable<String>(examplesJson);
    map['quiz_json'] = Variable<String>(quizJson);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  GrammarLessonsCompanion toCompanion(bool nullToAbsent) {
    return GrammarLessonsCompanion(
      id: Value(id),
      title: Value(title),
      level: Value(level),
      explanationId: Value(explanationId),
      formula: Value(formula),
      examplesJson: Value(examplesJson),
      quizJson: Value(quizJson),
      isCompleted: Value(isCompleted),
    );
  }

  factory GrammarLesson.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarLesson(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      level: serializer.fromJson<String>(json['level']),
      explanationId: serializer.fromJson<String>(json['explanationId']),
      formula: serializer.fromJson<String>(json['formula']),
      examplesJson: serializer.fromJson<String>(json['examplesJson']),
      quizJson: serializer.fromJson<String>(json['quizJson']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'level': serializer.toJson<String>(level),
      'explanationId': serializer.toJson<String>(explanationId),
      'formula': serializer.toJson<String>(formula),
      'examplesJson': serializer.toJson<String>(examplesJson),
      'quizJson': serializer.toJson<String>(quizJson),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  GrammarLesson copyWith(
          {int? id,
          String? title,
          String? level,
          String? explanationId,
          String? formula,
          String? examplesJson,
          String? quizJson,
          bool? isCompleted}) =>
      GrammarLesson(
        id: id ?? this.id,
        title: title ?? this.title,
        level: level ?? this.level,
        explanationId: explanationId ?? this.explanationId,
        formula: formula ?? this.formula,
        examplesJson: examplesJson ?? this.examplesJson,
        quizJson: quizJson ?? this.quizJson,
        isCompleted: isCompleted ?? this.isCompleted,
      );
  GrammarLesson copyWithCompanion(GrammarLessonsCompanion data) {
    return GrammarLesson(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      level: data.level.present ? data.level.value : this.level,
      explanationId: data.explanationId.present
          ? data.explanationId.value
          : this.explanationId,
      formula: data.formula.present ? data.formula.value : this.formula,
      examplesJson: data.examplesJson.present
          ? data.examplesJson.value
          : this.examplesJson,
      quizJson: data.quizJson.present ? data.quizJson.value : this.quizJson,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarLesson(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('level: $level, ')
          ..write('explanationId: $explanationId, ')
          ..write('formula: $formula, ')
          ..write('examplesJson: $examplesJson, ')
          ..write('quizJson: $quizJson, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, level, explanationId, formula,
      examplesJson, quizJson, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarLesson &&
          other.id == this.id &&
          other.title == this.title &&
          other.level == this.level &&
          other.explanationId == this.explanationId &&
          other.formula == this.formula &&
          other.examplesJson == this.examplesJson &&
          other.quizJson == this.quizJson &&
          other.isCompleted == this.isCompleted);
}

class GrammarLessonsCompanion extends UpdateCompanion<GrammarLesson> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> level;
  final Value<String> explanationId;
  final Value<String> formula;
  final Value<String> examplesJson;
  final Value<String> quizJson;
  final Value<bool> isCompleted;
  const GrammarLessonsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.level = const Value.absent(),
    this.explanationId = const Value.absent(),
    this.formula = const Value.absent(),
    this.examplesJson = const Value.absent(),
    this.quizJson = const Value.absent(),
    this.isCompleted = const Value.absent(),
  });
  GrammarLessonsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String level,
    required String explanationId,
    required String formula,
    required String examplesJson,
    required String quizJson,
    this.isCompleted = const Value.absent(),
  })  : title = Value(title),
        level = Value(level),
        explanationId = Value(explanationId),
        formula = Value(formula),
        examplesJson = Value(examplesJson),
        quizJson = Value(quizJson);
  static Insertable<GrammarLesson> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? level,
    Expression<String>? explanationId,
    Expression<String>? formula,
    Expression<String>? examplesJson,
    Expression<String>? quizJson,
    Expression<bool>? isCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (level != null) 'level': level,
      if (explanationId != null) 'explanation_id': explanationId,
      if (formula != null) 'formula': formula,
      if (examplesJson != null) 'examples_json': examplesJson,
      if (quizJson != null) 'quiz_json': quizJson,
      if (isCompleted != null) 'is_completed': isCompleted,
    });
  }

  GrammarLessonsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? level,
      Value<String>? explanationId,
      Value<String>? formula,
      Value<String>? examplesJson,
      Value<String>? quizJson,
      Value<bool>? isCompleted}) {
    return GrammarLessonsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      level: level ?? this.level,
      explanationId: explanationId ?? this.explanationId,
      formula: formula ?? this.formula,
      examplesJson: examplesJson ?? this.examplesJson,
      quizJson: quizJson ?? this.quizJson,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (explanationId.present) {
      map['explanation_id'] = Variable<String>(explanationId.value);
    }
    if (formula.present) {
      map['formula'] = Variable<String>(formula.value);
    }
    if (examplesJson.present) {
      map['examples_json'] = Variable<String>(examplesJson.value);
    }
    if (quizJson.present) {
      map['quiz_json'] = Variable<String>(quizJson.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarLessonsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('level: $level, ')
          ..write('explanationId: $explanationId, ')
          ..write('formula: $formula, ')
          ..write('examplesJson: $examplesJson, ')
          ..write('quizJson: $quizJson, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }
}

class $DailyLogsTable extends DailyLogs
    with TableInfo<$DailyLogsTable, DailyLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _wordsReviewedMeta =
      const VerificationMeta('wordsReviewed');
  @override
  late final GeneratedColumn<int> wordsReviewed = GeneratedColumn<int>(
      'words_reviewed', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _wordsLearnedMeta =
      const VerificationMeta('wordsLearned');
  @override
  late final GeneratedColumn<int> wordsLearned = GeneratedColumn<int>(
      'words_learned', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _minutesSpentMeta =
      const VerificationMeta('minutesSpent');
  @override
  late final GeneratedColumn<int> minutesSpent = GeneratedColumn<int>(
      'minutes_spent', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [date, wordsReviewed, wordsLearned, minutesSpent];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_logs';
  @override
  VerificationContext validateIntegrity(Insertable<DailyLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('words_reviewed')) {
      context.handle(
          _wordsReviewedMeta,
          wordsReviewed.isAcceptableOrUnknown(
              data['words_reviewed']!, _wordsReviewedMeta));
    }
    if (data.containsKey('words_learned')) {
      context.handle(
          _wordsLearnedMeta,
          wordsLearned.isAcceptableOrUnknown(
              data['words_learned']!, _wordsLearnedMeta));
    }
    if (data.containsKey('minutes_spent')) {
      context.handle(
          _minutesSpentMeta,
          minutesSpent.isAcceptableOrUnknown(
              data['minutes_spent']!, _minutesSpentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DailyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyLog(
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      wordsReviewed: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}words_reviewed'])!,
      wordsLearned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}words_learned'])!,
      minutesSpent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minutes_spent'])!,
    );
  }

  @override
  $DailyLogsTable createAlias(String alias) {
    return $DailyLogsTable(attachedDatabase, alias);
  }
}

class DailyLog extends DataClass implements Insertable<DailyLog> {
  /// Tanggal lokal format 'YYYY-MM-DD' sebagai Primary Key.
  final String date;
  final int wordsReviewed;
  final int wordsLearned;
  final int minutesSpent;
  const DailyLog(
      {required this.date,
      required this.wordsReviewed,
      required this.wordsLearned,
      required this.minutesSpent});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['words_reviewed'] = Variable<int>(wordsReviewed);
    map['words_learned'] = Variable<int>(wordsLearned);
    map['minutes_spent'] = Variable<int>(minutesSpent);
    return map;
  }

  DailyLogsCompanion toCompanion(bool nullToAbsent) {
    return DailyLogsCompanion(
      date: Value(date),
      wordsReviewed: Value(wordsReviewed),
      wordsLearned: Value(wordsLearned),
      minutesSpent: Value(minutesSpent),
    );
  }

  factory DailyLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyLog(
      date: serializer.fromJson<String>(json['date']),
      wordsReviewed: serializer.fromJson<int>(json['wordsReviewed']),
      wordsLearned: serializer.fromJson<int>(json['wordsLearned']),
      minutesSpent: serializer.fromJson<int>(json['minutesSpent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'wordsReviewed': serializer.toJson<int>(wordsReviewed),
      'wordsLearned': serializer.toJson<int>(wordsLearned),
      'minutesSpent': serializer.toJson<int>(minutesSpent),
    };
  }

  DailyLog copyWith(
          {String? date,
          int? wordsReviewed,
          int? wordsLearned,
          int? minutesSpent}) =>
      DailyLog(
        date: date ?? this.date,
        wordsReviewed: wordsReviewed ?? this.wordsReviewed,
        wordsLearned: wordsLearned ?? this.wordsLearned,
        minutesSpent: minutesSpent ?? this.minutesSpent,
      );
  DailyLog copyWithCompanion(DailyLogsCompanion data) {
    return DailyLog(
      date: data.date.present ? data.date.value : this.date,
      wordsReviewed: data.wordsReviewed.present
          ? data.wordsReviewed.value
          : this.wordsReviewed,
      wordsLearned: data.wordsLearned.present
          ? data.wordsLearned.value
          : this.wordsLearned,
      minutesSpent: data.minutesSpent.present
          ? data.minutesSpent.value
          : this.minutesSpent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyLog(')
          ..write('date: $date, ')
          ..write('wordsReviewed: $wordsReviewed, ')
          ..write('wordsLearned: $wordsLearned, ')
          ..write('minutesSpent: $minutesSpent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(date, wordsReviewed, wordsLearned, minutesSpent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyLog &&
          other.date == this.date &&
          other.wordsReviewed == this.wordsReviewed &&
          other.wordsLearned == this.wordsLearned &&
          other.minutesSpent == this.minutesSpent);
}

class DailyLogsCompanion extends UpdateCompanion<DailyLog> {
  final Value<String> date;
  final Value<int> wordsReviewed;
  final Value<int> wordsLearned;
  final Value<int> minutesSpent;
  final Value<int> rowid;
  const DailyLogsCompanion({
    this.date = const Value.absent(),
    this.wordsReviewed = const Value.absent(),
    this.wordsLearned = const Value.absent(),
    this.minutesSpent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyLogsCompanion.insert({
    required String date,
    this.wordsReviewed = const Value.absent(),
    this.wordsLearned = const Value.absent(),
    this.minutesSpent = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyLog> custom({
    Expression<String>? date,
    Expression<int>? wordsReviewed,
    Expression<int>? wordsLearned,
    Expression<int>? minutesSpent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (wordsReviewed != null) 'words_reviewed': wordsReviewed,
      if (wordsLearned != null) 'words_learned': wordsLearned,
      if (minutesSpent != null) 'minutes_spent': minutesSpent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyLogsCompanion copyWith(
      {Value<String>? date,
      Value<int>? wordsReviewed,
      Value<int>? wordsLearned,
      Value<int>? minutesSpent,
      Value<int>? rowid}) {
    return DailyLogsCompanion(
      date: date ?? this.date,
      wordsReviewed: wordsReviewed ?? this.wordsReviewed,
      wordsLearned: wordsLearned ?? this.wordsLearned,
      minutesSpent: minutesSpent ?? this.minutesSpent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (wordsReviewed.present) {
      map['words_reviewed'] = Variable<int>(wordsReviewed.value);
    }
    if (wordsLearned.present) {
      map['words_learned'] = Variable<int>(wordsLearned.value);
    }
    if (minutesSpent.present) {
      map['minutes_spent'] = Variable<int>(minutesSpent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyLogsCompanion(')
          ..write('date: $date, ')
          ..write('wordsReviewed: $wordsReviewed, ')
          ..write('wordsLearned: $wordsLearned, ')
          ..write('minutesSpent: $minutesSpent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VocabItemsTable vocabItems = $VocabItemsTable(this);
  late final $SrsProgressTable srsProgress = $SrsProgressTable(this);
  late final $ReadingPassagesTable readingPassages =
      $ReadingPassagesTable(this);
  late final $GrammarLessonsTable grammarLessons = $GrammarLessonsTable(this);
  late final $DailyLogsTable dailyLogs = $DailyLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [vocabItems, srsProgress, readingPassages, grammarLessons, dailyLogs];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('vocab_items',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('srs_progress', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$VocabItemsTableCreateCompanionBuilder = VocabItemsCompanion Function({
  Value<int> id,
  required String word,
  required String phonetic,
  required String partOfSpeech,
  required String meaningId,
  required String exampleEn,
  required String exampleId,
  Value<String?> mnemonicNote,
  required String category,
  required String level,
});
typedef $$VocabItemsTableUpdateCompanionBuilder = VocabItemsCompanion Function({
  Value<int> id,
  Value<String> word,
  Value<String> phonetic,
  Value<String> partOfSpeech,
  Value<String> meaningId,
  Value<String> exampleEn,
  Value<String> exampleId,
  Value<String?> mnemonicNote,
  Value<String> category,
  Value<String> level,
});

final class $$VocabItemsTableReferences
    extends BaseReferences<_$AppDatabase, $VocabItemsTable, VocabItem> {
  $$VocabItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SrsProgressTable, List<SrsProgressEntry>>
      _srsProgressRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.srsProgress,
              aliasName: 'vocab_items__id__srs_progress__vocab_id');

  $$SrsProgressTableProcessedTableManager get srsProgressRefs {
    final manager = $$SrsProgressTableTableManager($_db, $_db.srsProgress)
        .filter((f) => f.vocabId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_srsProgressRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$VocabItemsTableFilterComposer
    extends Composer<_$AppDatabase, $VocabItemsTable> {
  $$VocabItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phonetic => $composableBuilder(
      column: $table.phonetic, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meaningId => $composableBuilder(
      column: $table.meaningId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleEn => $composableBuilder(
      column: $table.exampleEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exampleId => $composableBuilder(
      column: $table.exampleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mnemonicNote => $composableBuilder(
      column: $table.mnemonicNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  Expression<bool> srsProgressRefs(
      Expression<bool> Function($$SrsProgressTableFilterComposer f) f) {
    final $$SrsProgressTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.srsProgress,
        getReferencedColumn: (t) => t.vocabId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SrsProgressTableFilterComposer(
              $db: $db,
              $table: $db.srsProgress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VocabItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabItemsTable> {
  $$VocabItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get word => $composableBuilder(
      column: $table.word, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phonetic => $composableBuilder(
      column: $table.phonetic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meaningId => $composableBuilder(
      column: $table.meaningId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleEn => $composableBuilder(
      column: $table.exampleEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exampleId => $composableBuilder(
      column: $table.exampleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mnemonicNote => $composableBuilder(
      column: $table.mnemonicNote,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));
}

class $$VocabItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabItemsTable> {
  $$VocabItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get phonetic =>
      $composableBuilder(column: $table.phonetic, builder: (column) => column);

  GeneratedColumn<String> get partOfSpeech => $composableBuilder(
      column: $table.partOfSpeech, builder: (column) => column);

  GeneratedColumn<String> get meaningId =>
      $composableBuilder(column: $table.meaningId, builder: (column) => column);

  GeneratedColumn<String> get exampleEn =>
      $composableBuilder(column: $table.exampleEn, builder: (column) => column);

  GeneratedColumn<String> get exampleId =>
      $composableBuilder(column: $table.exampleId, builder: (column) => column);

  GeneratedColumn<String> get mnemonicNote => $composableBuilder(
      column: $table.mnemonicNote, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  Expression<T> srsProgressRefs<T extends Object>(
      Expression<T> Function($$SrsProgressTableAnnotationComposer a) f) {
    final $$SrsProgressTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.srsProgress,
        getReferencedColumn: (t) => t.vocabId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SrsProgressTableAnnotationComposer(
              $db: $db,
              $table: $db.srsProgress,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VocabItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VocabItemsTable,
    VocabItem,
    $$VocabItemsTableFilterComposer,
    $$VocabItemsTableOrderingComposer,
    $$VocabItemsTableAnnotationComposer,
    $$VocabItemsTableCreateCompanionBuilder,
    $$VocabItemsTableUpdateCompanionBuilder,
    (VocabItem, $$VocabItemsTableReferences),
    VocabItem,
    PrefetchHooks Function({bool srsProgressRefs})> {
  $$VocabItemsTableTableManager(_$AppDatabase db, $VocabItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> word = const Value.absent(),
            Value<String> phonetic = const Value.absent(),
            Value<String> partOfSpeech = const Value.absent(),
            Value<String> meaningId = const Value.absent(),
            Value<String> exampleEn = const Value.absent(),
            Value<String> exampleId = const Value.absent(),
            Value<String?> mnemonicNote = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> level = const Value.absent(),
          }) =>
              VocabItemsCompanion(
            id: id,
            word: word,
            phonetic: phonetic,
            partOfSpeech: partOfSpeech,
            meaningId: meaningId,
            exampleEn: exampleEn,
            exampleId: exampleId,
            mnemonicNote: mnemonicNote,
            category: category,
            level: level,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String word,
            required String phonetic,
            required String partOfSpeech,
            required String meaningId,
            required String exampleEn,
            required String exampleId,
            Value<String?> mnemonicNote = const Value.absent(),
            required String category,
            required String level,
          }) =>
              VocabItemsCompanion.insert(
            id: id,
            word: word,
            phonetic: phonetic,
            partOfSpeech: partOfSpeech,
            meaningId: meaningId,
            exampleEn: exampleEn,
            exampleId: exampleId,
            mnemonicNote: mnemonicNote,
            category: category,
            level: level,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$VocabItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({srsProgressRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (srsProgressRefs) db.srsProgress],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (srsProgressRefs)
                    await $_getPrefetchedData<VocabItem, $VocabItemsTable,
                            SrsProgressEntry>(
                        currentTable: table,
                        referencedTable: $$VocabItemsTableReferences
                            ._srsProgressRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$VocabItemsTableReferences(db, table, p0)
                                .srsProgressRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.vocabId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$VocabItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VocabItemsTable,
    VocabItem,
    $$VocabItemsTableFilterComposer,
    $$VocabItemsTableOrderingComposer,
    $$VocabItemsTableAnnotationComposer,
    $$VocabItemsTableCreateCompanionBuilder,
    $$VocabItemsTableUpdateCompanionBuilder,
    (VocabItem, $$VocabItemsTableReferences),
    VocabItem,
    PrefetchHooks Function({bool srsProgressRefs})>;
typedef $$SrsProgressTableCreateCompanionBuilder = SrsProgressCompanion
    Function({
  Value<int> id,
  required int vocabId,
  Value<double> easeFactor,
  Value<int> intervalDays,
  Value<int> repetitions,
  Value<String> status,
  required int nextReviewAt,
  Value<int?> lastReviewedAt,
});
typedef $$SrsProgressTableUpdateCompanionBuilder = SrsProgressCompanion
    Function({
  Value<int> id,
  Value<int> vocabId,
  Value<double> easeFactor,
  Value<int> intervalDays,
  Value<int> repetitions,
  Value<String> status,
  Value<int> nextReviewAt,
  Value<int?> lastReviewedAt,
});

final class $$SrsProgressTableReferences
    extends BaseReferences<_$AppDatabase, $SrsProgressTable, SrsProgressEntry> {
  $$SrsProgressTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VocabItemsTable _vocabIdTable(_$AppDatabase db) =>
      db.vocabItems.createAlias('srs_progress__vocab_id__vocab_items__id');

  $$VocabItemsTableProcessedTableManager get vocabId {
    final $_column = $_itemColumn<int>('vocab_id')!;

    final manager = $$VocabItemsTableTableManager($_db, $_db.vocabItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vocabIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SrsProgressTableFilterComposer
    extends Composer<_$AppDatabase, $SrsProgressTable> {
  $$SrsProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnFilters(column));

  $$VocabItemsTableFilterComposer get vocabId {
    final $$VocabItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vocabId,
        referencedTable: $db.vocabItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabItemsTableFilterComposer(
              $db: $db,
              $table: $db.vocabItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SrsProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $SrsProgressTable> {
  $$SrsProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt,
      builder: (column) => ColumnOrderings(column));

  $$VocabItemsTableOrderingComposer get vocabId {
    final $$VocabItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vocabId,
        referencedTable: $db.vocabItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabItemsTableOrderingComposer(
              $db: $db,
              $table: $db.vocabItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SrsProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrsProgressTable> {
  $$SrsProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
      column: $table.easeFactor, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
      column: $table.repetitions, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get nextReviewAt => $composableBuilder(
      column: $table.nextReviewAt, builder: (column) => column);

  GeneratedColumn<int> get lastReviewedAt => $composableBuilder(
      column: $table.lastReviewedAt, builder: (column) => column);

  $$VocabItemsTableAnnotationComposer get vocabId {
    final $$VocabItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vocabId,
        referencedTable: $db.vocabItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VocabItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.vocabItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SrsProgressTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SrsProgressTable,
    SrsProgressEntry,
    $$SrsProgressTableFilterComposer,
    $$SrsProgressTableOrderingComposer,
    $$SrsProgressTableAnnotationComposer,
    $$SrsProgressTableCreateCompanionBuilder,
    $$SrsProgressTableUpdateCompanionBuilder,
    (SrsProgressEntry, $$SrsProgressTableReferences),
    SrsProgressEntry,
    PrefetchHooks Function({bool vocabId})> {
  $$SrsProgressTableTableManager(_$AppDatabase db, $SrsProgressTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrsProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrsProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrsProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> vocabId = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<int> repetitions = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> nextReviewAt = const Value.absent(),
            Value<int?> lastReviewedAt = const Value.absent(),
          }) =>
              SrsProgressCompanion(
            id: id,
            vocabId: vocabId,
            easeFactor: easeFactor,
            intervalDays: intervalDays,
            repetitions: repetitions,
            status: status,
            nextReviewAt: nextReviewAt,
            lastReviewedAt: lastReviewedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int vocabId,
            Value<double> easeFactor = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<int> repetitions = const Value.absent(),
            Value<String> status = const Value.absent(),
            required int nextReviewAt,
            Value<int?> lastReviewedAt = const Value.absent(),
          }) =>
              SrsProgressCompanion.insert(
            id: id,
            vocabId: vocabId,
            easeFactor: easeFactor,
            intervalDays: intervalDays,
            repetitions: repetitions,
            status: status,
            nextReviewAt: nextReviewAt,
            lastReviewedAt: lastReviewedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SrsProgressTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({vocabId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (vocabId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.vocabId,
                    referencedTable:
                        $$SrsProgressTableReferences._vocabIdTable(db),
                    referencedColumn:
                        $$SrsProgressTableReferences._vocabIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SrsProgressTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SrsProgressTable,
    SrsProgressEntry,
    $$SrsProgressTableFilterComposer,
    $$SrsProgressTableOrderingComposer,
    $$SrsProgressTableAnnotationComposer,
    $$SrsProgressTableCreateCompanionBuilder,
    $$SrsProgressTableUpdateCompanionBuilder,
    (SrsProgressEntry, $$SrsProgressTableReferences),
    SrsProgressEntry,
    PrefetchHooks Function({bool vocabId})>;
typedef $$ReadingPassagesTableCreateCompanionBuilder = ReadingPassagesCompanion
    Function({
  Value<int> id,
  required String title,
  required String topic,
  required String level,
  required String contentEn,
  required String contentId,
  Value<bool> isRead,
});
typedef $$ReadingPassagesTableUpdateCompanionBuilder = ReadingPassagesCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<String> topic,
  Value<String> level,
  Value<String> contentEn,
  Value<String> contentId,
  Value<bool> isRead,
});

class $$ReadingPassagesTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingPassagesTable> {
  $$ReadingPassagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get topic => $composableBuilder(
      column: $table.topic, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentEn => $composableBuilder(
      column: $table.contentEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentId => $composableBuilder(
      column: $table.contentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnFilters(column));
}

class $$ReadingPassagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingPassagesTable> {
  $$ReadingPassagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get topic => $composableBuilder(
      column: $table.topic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentEn => $composableBuilder(
      column: $table.contentEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentId => $composableBuilder(
      column: $table.contentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnOrderings(column));
}

class $$ReadingPassagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingPassagesTable> {
  $$ReadingPassagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get contentEn =>
      $composableBuilder(column: $table.contentEn, builder: (column) => column);

  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);
}

class $$ReadingPassagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReadingPassagesTable,
    ReadingPassage,
    $$ReadingPassagesTableFilterComposer,
    $$ReadingPassagesTableOrderingComposer,
    $$ReadingPassagesTableAnnotationComposer,
    $$ReadingPassagesTableCreateCompanionBuilder,
    $$ReadingPassagesTableUpdateCompanionBuilder,
    (
      ReadingPassage,
      BaseReferences<_$AppDatabase, $ReadingPassagesTable, ReadingPassage>
    ),
    ReadingPassage,
    PrefetchHooks Function()> {
  $$ReadingPassagesTableTableManager(
      _$AppDatabase db, $ReadingPassagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingPassagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingPassagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingPassagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> topic = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> contentEn = const Value.absent(),
            Value<String> contentId = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
          }) =>
              ReadingPassagesCompanion(
            id: id,
            title: title,
            topic: topic,
            level: level,
            contentEn: contentEn,
            contentId: contentId,
            isRead: isRead,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String topic,
            required String level,
            required String contentEn,
            required String contentId,
            Value<bool> isRead = const Value.absent(),
          }) =>
              ReadingPassagesCompanion.insert(
            id: id,
            title: title,
            topic: topic,
            level: level,
            contentEn: contentEn,
            contentId: contentId,
            isRead: isRead,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReadingPassagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReadingPassagesTable,
    ReadingPassage,
    $$ReadingPassagesTableFilterComposer,
    $$ReadingPassagesTableOrderingComposer,
    $$ReadingPassagesTableAnnotationComposer,
    $$ReadingPassagesTableCreateCompanionBuilder,
    $$ReadingPassagesTableUpdateCompanionBuilder,
    (
      ReadingPassage,
      BaseReferences<_$AppDatabase, $ReadingPassagesTable, ReadingPassage>
    ),
    ReadingPassage,
    PrefetchHooks Function()>;
typedef $$GrammarLessonsTableCreateCompanionBuilder = GrammarLessonsCompanion
    Function({
  Value<int> id,
  required String title,
  required String level,
  required String explanationId,
  required String formula,
  required String examplesJson,
  required String quizJson,
  Value<bool> isCompleted,
});
typedef $$GrammarLessonsTableUpdateCompanionBuilder = GrammarLessonsCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<String> level,
  Value<String> explanationId,
  Value<String> formula,
  Value<String> examplesJson,
  Value<String> quizJson,
  Value<bool> isCompleted,
});

class $$GrammarLessonsTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarLessonsTable> {
  $$GrammarLessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get explanationId => $composableBuilder(
      column: $table.explanationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get formula => $composableBuilder(
      column: $table.formula, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get examplesJson => $composableBuilder(
      column: $table.examplesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get quizJson => $composableBuilder(
      column: $table.quizJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));
}

class $$GrammarLessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarLessonsTable> {
  $$GrammarLessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get explanationId => $composableBuilder(
      column: $table.explanationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get formula => $composableBuilder(
      column: $table.formula, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get examplesJson => $composableBuilder(
      column: $table.examplesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get quizJson => $composableBuilder(
      column: $table.quizJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));
}

class $$GrammarLessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarLessonsTable> {
  $$GrammarLessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get explanationId => $composableBuilder(
      column: $table.explanationId, builder: (column) => column);

  GeneratedColumn<String> get formula =>
      $composableBuilder(column: $table.formula, builder: (column) => column);

  GeneratedColumn<String> get examplesJson => $composableBuilder(
      column: $table.examplesJson, builder: (column) => column);

  GeneratedColumn<String> get quizJson =>
      $composableBuilder(column: $table.quizJson, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);
}

class $$GrammarLessonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GrammarLessonsTable,
    GrammarLesson,
    $$GrammarLessonsTableFilterComposer,
    $$GrammarLessonsTableOrderingComposer,
    $$GrammarLessonsTableAnnotationComposer,
    $$GrammarLessonsTableCreateCompanionBuilder,
    $$GrammarLessonsTableUpdateCompanionBuilder,
    (
      GrammarLesson,
      BaseReferences<_$AppDatabase, $GrammarLessonsTable, GrammarLesson>
    ),
    GrammarLesson,
    PrefetchHooks Function()> {
  $$GrammarLessonsTableTableManager(
      _$AppDatabase db, $GrammarLessonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarLessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarLessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarLessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> explanationId = const Value.absent(),
            Value<String> formula = const Value.absent(),
            Value<String> examplesJson = const Value.absent(),
            Value<String> quizJson = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
          }) =>
              GrammarLessonsCompanion(
            id: id,
            title: title,
            level: level,
            explanationId: explanationId,
            formula: formula,
            examplesJson: examplesJson,
            quizJson: quizJson,
            isCompleted: isCompleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String level,
            required String explanationId,
            required String formula,
            required String examplesJson,
            required String quizJson,
            Value<bool> isCompleted = const Value.absent(),
          }) =>
              GrammarLessonsCompanion.insert(
            id: id,
            title: title,
            level: level,
            explanationId: explanationId,
            formula: formula,
            examplesJson: examplesJson,
            quizJson: quizJson,
            isCompleted: isCompleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GrammarLessonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GrammarLessonsTable,
    GrammarLesson,
    $$GrammarLessonsTableFilterComposer,
    $$GrammarLessonsTableOrderingComposer,
    $$GrammarLessonsTableAnnotationComposer,
    $$GrammarLessonsTableCreateCompanionBuilder,
    $$GrammarLessonsTableUpdateCompanionBuilder,
    (
      GrammarLesson,
      BaseReferences<_$AppDatabase, $GrammarLessonsTable, GrammarLesson>
    ),
    GrammarLesson,
    PrefetchHooks Function()>;
typedef $$DailyLogsTableCreateCompanionBuilder = DailyLogsCompanion Function({
  required String date,
  Value<int> wordsReviewed,
  Value<int> wordsLearned,
  Value<int> minutesSpent,
  Value<int> rowid,
});
typedef $$DailyLogsTableUpdateCompanionBuilder = DailyLogsCompanion Function({
  Value<String> date,
  Value<int> wordsReviewed,
  Value<int> wordsLearned,
  Value<int> minutesSpent,
  Value<int> rowid,
});

class $$DailyLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wordsReviewed => $composableBuilder(
      column: $table.wordsReviewed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wordsLearned => $composableBuilder(
      column: $table.wordsLearned, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minutesSpent => $composableBuilder(
      column: $table.minutesSpent, builder: (column) => ColumnFilters(column));
}

class $$DailyLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wordsReviewed => $composableBuilder(
      column: $table.wordsReviewed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wordsLearned => $composableBuilder(
      column: $table.wordsLearned,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minutesSpent => $composableBuilder(
      column: $table.minutesSpent,
      builder: (column) => ColumnOrderings(column));
}

class $$DailyLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get wordsReviewed => $composableBuilder(
      column: $table.wordsReviewed, builder: (column) => column);

  GeneratedColumn<int> get wordsLearned => $composableBuilder(
      column: $table.wordsLearned, builder: (column) => column);

  GeneratedColumn<int> get minutesSpent => $composableBuilder(
      column: $table.minutesSpent, builder: (column) => column);
}

class $$DailyLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyLogsTable,
    DailyLog,
    $$DailyLogsTableFilterComposer,
    $$DailyLogsTableOrderingComposer,
    $$DailyLogsTableAnnotationComposer,
    $$DailyLogsTableCreateCompanionBuilder,
    $$DailyLogsTableUpdateCompanionBuilder,
    (DailyLog, BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog>),
    DailyLog,
    PrefetchHooks Function()> {
  $$DailyLogsTableTableManager(_$AppDatabase db, $DailyLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> date = const Value.absent(),
            Value<int> wordsReviewed = const Value.absent(),
            Value<int> wordsLearned = const Value.absent(),
            Value<int> minutesSpent = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyLogsCompanion(
            date: date,
            wordsReviewed: wordsReviewed,
            wordsLearned: wordsLearned,
            minutesSpent: minutesSpent,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String date,
            Value<int> wordsReviewed = const Value.absent(),
            Value<int> wordsLearned = const Value.absent(),
            Value<int> minutesSpent = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailyLogsCompanion.insert(
            date: date,
            wordsReviewed: wordsReviewed,
            wordsLearned: wordsLearned,
            minutesSpent: minutesSpent,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyLogsTable,
    DailyLog,
    $$DailyLogsTableFilterComposer,
    $$DailyLogsTableOrderingComposer,
    $$DailyLogsTableAnnotationComposer,
    $$DailyLogsTableCreateCompanionBuilder,
    $$DailyLogsTableUpdateCompanionBuilder,
    (DailyLog, BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog>),
    DailyLog,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VocabItemsTableTableManager get vocabItems =>
      $$VocabItemsTableTableManager(_db, _db.vocabItems);
  $$SrsProgressTableTableManager get srsProgress =>
      $$SrsProgressTableTableManager(_db, _db.srsProgress);
  $$ReadingPassagesTableTableManager get readingPassages =>
      $$ReadingPassagesTableTableManager(_db, _db.readingPassages);
  $$GrammarLessonsTableTableManager get grammarLessons =>
      $$GrammarLessonsTableTableManager(_db, _db.grammarLessons);
  $$DailyLogsTableTableManager get dailyLogs =>
      $$DailyLogsTableTableManager(_db, _db.dailyLogs);
}
