import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:english_adult_learner/core/database/app_database.dart';
import 'package:english_adult_learner/core/database/database_providers.dart';
import 'package:english_adult_learner/features/progress/data/progress_repository.dart';
import 'package:english_adult_learner/features/progress/presentation/progress_providers.dart';
import 'package:english_adult_learner/main.dart';

void main() {
  testWidgets('Menampilkan layar utama Rencana Hari Ini, streak, dan progres harian', (
    WidgetTester tester,
  ) async {
    final memoryDb = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(memoryDb.close);

    const mockSummary = LearningSummary(
      totalVocab: 120,
      masteredCount: 5,
      learningCount: 10,
      dueTodayCount: 4,
      readPassagesCount: 1,
      totalPassagesCount: 12,
      completedGrammarCount: 1,
      totalGrammarCount: 8,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(memoryDb),
          databaseSeedFutureProvider.overrideWith((ref) async => false),
          progressDashboardProvider.overrideWith(
            (ref) async => const ProgressDashboardData(
              summary: mockSummary,
              streak: StreakStatus(
                streakDays: 3,
                usedStreakFreeze: false,
                studiedToday: true,
              ),
              todayEffectiveMinutes: 8,
              todayWordsReviewed: 12,
              last7Days: [],
            ),
          ),
        ],
        child: const EnglishAdultLearnerApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Rencana Hari Ini'), findsOneWidget);
    expect(find.text('3 Hari'), findsOneWidget);
    expect(find.text('8 / 10 mnt'), findsOneWidget);
    expect(find.text('5/120'), findsOneWidget);
    expect(find.text('1/12'), findsOneWidget);
    expect(find.text('Hari Ini'), findsOneWidget);
    expect(find.text('Hafalan'), findsOneWidget);
    expect(find.text('Bacaan'), findsOneWidget);
    expect(find.text('Pola'), findsOneWidget);
    expect(find.text('Progres'), findsOneWidget);
  });
}
