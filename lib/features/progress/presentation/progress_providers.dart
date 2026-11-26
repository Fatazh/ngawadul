import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_providers.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_theme.dart';
import '../data/progress_repository.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ProgressRepository(db);
});

/// Provider data statistik lengkap (terikat otomatis pada penyegaran `learningSummaryProvider`).
final progressDashboardProvider =
    FutureProvider<ProgressDashboardData>((ref) async {
  await ref.watch(databaseSeedFutureProvider.future);
  // Ikut me-refresh setiap kali learningSummaryProvider di-invalidate oleh SRS/Bacaan/Grammar
  ref.watch(learningSummaryProvider);
  final repo = ref.watch(progressRepositoryProvider);
  return repo.loadDashboardData();
});

/// StateNotifier untuk mengelola pengaturan target harian, pengingat lokal, dan mode tema.
class StudySettingsController extends StateNotifier<UserStudySettings> {
  StudySettingsController(this._ref) : super(const UserStudySettings()) {
    _loadInitial();
  }

  final Ref _ref;

  Future<void> _loadInitial() async {
    try {
      final repo = _ref.read(progressRepositoryProvider);
      final loaded = await repo.loadSettings();
      state = loaded;
      _ref.read(themeModeProvider.notifier).state = loaded.themeMode;
    } catch (_) {
      // Gunakan nilai default jika SharedPreferences belum tersedia (misal pada test)
    }
  }

  Future<void> setDailyGoalMinutes(int minutes) async {
    final next = state.copyWith(dailyGoalMinutes: minutes);
    state = next;
    await _persistAndSyncNotification(next);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final next = state.copyWith(themeMode: mode);
    state = next;
    _ref.read(themeModeProvider.notifier).state = mode;
    try {
      await _ref.read(progressRepositoryProvider).saveSettings(next);
    } catch (_) {}
  }

  Future<void> toggleReminder(bool enabled) async {
    final next = state.copyWith(reminderEnabled: enabled);
    state = next;
    await _persistAndSyncNotification(next);
  }

  Future<void> setReminderTime({
    required int hour,
    required int minute,
  }) async {
    final next = state.copyWith(
      reminderEnabled: true,
      reminderHour: hour,
      reminderMinute: minute,
    );
    state = next;
    await _persistAndSyncNotification(next);
  }

  Future<void> _persistAndSyncNotification(UserStudySettings next) async {
    try {
      await _ref.read(progressRepositoryProvider).saveSettings(next);
      final notifier = _ref.read(notificationServiceProvider);
      if (next.reminderEnabled) {
        await notifier.scheduleDailyReminder(
          hour: next.reminderHour,
          minute: next.reminderMinute,
          dailyGoalMinutes: next.dailyGoalMinutes,
        );
      } else {
        await notifier.cancelDailyReminder();
      }
    } catch (_) {}
  }
}

final studySettingsProvider =
    StateNotifierProvider<StudySettingsController, UserStudySettings>((ref) {
  return StudySettingsController(ref);
});
