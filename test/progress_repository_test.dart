import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:english_adult_learner/core/database/app_database.dart';
import 'package:english_adult_learner/features/progress/data/progress_repository.dart';

void main() {
  late AppDatabase db;
  late ProgressRepository repo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = ProgressRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('calculateStreakWithFreeze menghitung streak beruntun normal', () {
    final logs = {
      '2026-11-24': const DailyLog(
        date: '2026-11-24',
        wordsReviewed: 5,
        wordsLearned: 2,
        minutesSpent: 0,
      ),
      '2026-11-25': const DailyLog(
        date: '2026-11-25',
        wordsReviewed: 8,
        wordsLearned: 0,
        minutesSpent: 3,
      ),
      '2026-11-26': const DailyLog(
        date: '2026-11-26',
        wordsReviewed: 4,
        wordsLearned: 1,
        minutesSpent: 2,
      ),
    };

    final result = ProgressRepository.calculateStreakWithFreeze(
      logsByDate: logs,
      today: DateTime(2026, 11, 26),
    );

    expect(result.streakDays, 3);
    expect(result.usedStreakFreeze, isFalse);
    expect(result.studiedToday, isTrue);
  });

  test('calculateStreakWithFreeze menyelamatkan 1 hari kosong dengan Streak Freeze', () {
    final logs = {
      '2026-11-23': const DailyLog(
        date: '2026-11-23',
        wordsReviewed: 6,
        wordsLearned: 2,
        minutesSpent: 0,
      ),
      '2026-11-24': const DailyLog(
        date: '2026-11-24',
        wordsReviewed: 6,
        wordsLearned: 0,
        minutesSpent: 3,
      ),
      // 2026-11-25 KOSONG (lembur kerja)
      '2026-11-26': const DailyLog(
        date: '2026-11-26',
        wordsReviewed: 4,
        wordsLearned: 0,
        minutesSpent: 3,
      ),
    };

    final result = ProgressRepository.calculateStreakWithFreeze(
      logsByDate: logs,
      today: DateTime(2026, 11, 26),
    );

    expect(result.streakDays, 3);
    expect(result.usedStreakFreeze, isTrue);
    expect(result.studiedToday, isTrue);
  });

  test('calculateStreakWithFreeze memutus streak jika bolong 2 hari beruntun', () {
    final logs = {
      '2026-11-22': const DailyLog(
        date: '2026-11-22',
        wordsReviewed: 10,
        wordsLearned: 2,
        minutesSpent: 5,
      ),
      // 2026-11-23 & 2026-11-24 KOSONG (2 hari berturut-turut)
      '2026-11-25': const DailyLog(
        date: '2026-11-25',
        wordsReviewed: 5,
        wordsLearned: 1,
        minutesSpent: 0,
      ),
      '2026-11-26': const DailyLog(
        date: '2026-11-26',
        wordsReviewed: 4,
        wordsLearned: 0,
        minutesSpent: 2,
      ),
    };

    final result = ProgressRepository.calculateStreakWithFreeze(
      logsByDate: logs,
      today: DateTime(2026, 11, 26),
    );

    expect(result.streakDays, 2);
  });

  test('saveSettings dan loadSettings menyimpan target waktu, jam pengingat, dan tema', () async {
    const customSettings = UserStudySettings(
      dailyGoalMinutes: 15,
      reminderEnabled: true,
      reminderHour: 21,
      reminderMinute: 30,
      themeMode: ThemeMode.dark,
    );

    await repo.saveSettings(customSettings);
    final loaded = await repo.loadSettings();

    expect(loaded.dailyGoalMinutes, 15);
    expect(loaded.reminderEnabled, isTrue);
    expect(loaded.formattedReminderTime, '21:30');
    expect(loaded.themeMode, ThemeMode.dark);
  });
}
