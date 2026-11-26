import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_providers.dart';
import '../data/grammar_repository.dart';

final grammarRepositoryProvider = Provider<GrammarRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return GrammarRepository(db);
});

/// Filter level aktif pada halaman daftar Pola Kalimat ('ALL', 'A1', 'A2', 'B1').
final grammarLevelFilterProvider = StateProvider<String>((ref) => 'ALL');

/// Stream reaktif daftar materi Grammar yang sudah di-parse beserta filter levelnya.
final filteredGrammarLessonsProvider =
    StreamProvider<List<ParsedGrammarLesson>>((ref) async* {
  await ref.watch(databaseSeedFutureProvider.future);
  final db = ref.watch(appDatabaseProvider);
  final filter = ref.watch(grammarLevelFilterProvider);

  await for (final rows in db.watchAllGrammarLessons()) {
    final filtered = filter == 'ALL'
        ? rows
        : rows.where((r) => r.level == filter).toList();
    yield filtered.map(GrammarRepository.parseLesson).toList();
  }
});
