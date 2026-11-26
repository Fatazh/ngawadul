import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';
import '../data/reading_repository.dart';

final readingRepositoryProvider = Provider<ReadingRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReadingRepository(db);
});

/// Filter level aktif pada halaman daftar Bacaan ('ALL', 'A1', 'A2', 'B1').
final readingLevelFilterProvider = StateProvider<String>((ref) => 'ALL');

/// Stream reaktif daftar bacaan dari Drift SQLite yang sudah difilter levelnya.
final filteredReadingPassagesProvider =
    StreamProvider<List<ReadingPassage>>((ref) async* {
  await ref.watch(databaseSeedFutureProvider.future);
  final db = ref.watch(appDatabaseProvider);
  final filter = ref.watch(readingLevelFilterProvider);

  await for (final passages in db.watchAllReadingPassages()) {
    if (filter == 'ALL') {
      yield passages;
    } else {
      yield passages.where((p) => p.level == filter).toList();
    }
  }
});
