import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'seed_loader.dart';

/// Singleton instance AppDatabase (Drift SQLite) selama aplikasi berjalan.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Provider untuk menjalankan pengecekan & pengisian data awal A1-B1 (first-run seeder).
final databaseSeedFutureProvider = FutureProvider<bool>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final loader = SeedLoader(database: db);
  return loader.ensureSeeded();
});

/// Ringkasan statistik belajar terkini (menunggu seeder selesai terlebih dahulu).
final learningSummaryProvider = FutureProvider<LearningSummary>((ref) async {
  await ref.watch(databaseSeedFutureProvider.future);
  final db = ref.watch(appDatabaseProvider);
  final nowMs = DateTime.now().millisecondsSinceEpoch;
  return db.getLearningSummary(nowMs);
});
