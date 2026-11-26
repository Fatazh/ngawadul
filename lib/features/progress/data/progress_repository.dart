import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/database/app_database.dart';
import '../../srs/data/srs_repository.dart';

/// Satu titik data aktivitas harian untuk grafik 7 hari terakhir.
class DailyActivityPoint {
  const DailyActivityPoint({
    required this.dateKey,
    required this.dayShortLabel,
    required this.effectiveMinutes,
    required this.wordsReviewed,
    required this.wordsLearned,
    required this.isToday,
  });

  final String dateKey;
  final String dayShortLabel;
  final int effectiveMinutes;
  final int wordsReviewed;
  final int wordsLearned;
  final bool isToday;

  bool get isActive =>
      effectiveMinutes > 0 || wordsReviewed > 0 || wordsLearned > 0;
}

/// Hasil perhitungan streak lengkap dengan fitur penyelamat 1 hari sibuk (Streak Freeze).
class StreakStatus {
  const StreakStatus({
    required this.streakDays,
    required this.usedStreakFreeze,
    required this.studiedToday,
  });

  final int streakDays;

  /// Bernilai true jika dalam rentetan streak saat ini terdapat 1 hari kosong
  /// yang diselamatkan otomatis oleh fitur Streak Freeze dewasa.
  final bool usedStreakFreeze;

  final bool studiedToday;
}

/// Pengaturan kebiasaan belajar yang disimpan di SharedPreferences.
class UserStudySettings {
  const UserStudySettings({
    this.dailyGoalMinutes = 10,
    this.reminderEnabled = false,
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.themeMode = ThemeMode.system,
  });

  final int dailyGoalMinutes;
  final bool reminderEnabled;
  final int reminderHour;
  final int reminderMinute;
  final ThemeMode themeMode;

  String get formattedReminderTime {
    final h = reminderHour.toString().padLeft(2, '0');
    final m = reminderMinute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  UserStudySettings copyWith({
    int? dailyGoalMinutes,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
    ThemeMode? themeMode,
  }) {
    return UserStudySettings(
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

/// Gabungan seluruh data dashboard progres & kebiasaan.
class ProgressDashboardData {
  const ProgressDashboardData({
    required this.summary,
    required this.streak,
    required this.todayEffectiveMinutes,
    required this.todayWordsReviewed,
    required this.last7Days,
  });

  final LearningSummary summary;
  final StreakStatus streak;
  final int todayEffectiveMinutes;
  final int todayWordsReviewed;
  final List<DailyActivityPoint> last7Days;

  int get weeklyReviewedTotal =>
      last7Days.fold<int>(0, (sum, d) => sum + d.wordsReviewed);
}

class ProgressRepository {
  const ProgressRepository(this._db);

  final AppDatabase _db;

  static const String _keyGoalMinutes = 'study_daily_goal_minutes';
  static const String _keyReminderEnabled = 'study_reminder_enabled';
  static const String _keyReminderHour = 'study_reminder_hour';
  static const String _keyReminderMinute = 'study_reminder_minute';
  static const String _keyThemeMode = 'study_theme_mode';

  static const List<String> _weekdayLabelsId = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  /// Menghitung estimasi menit belajar efektif dari suatu `DailyLog`
  /// (menggabungkan menit bacaan/grammar + ~1 menit tiap 4 review kartu SRS).
  static int computeEffectiveMinutes(DailyLog? log) {
    if (log == null) return 0;
    final srsMinutes =
        log.wordsReviewed > 0 ? ((log.wordsReviewed + 3) ~/ 4) : 0;
    return log.minutesSpent + srsMinutes;
  }

  static bool _isLogActive(DailyLog? log) {
    if (log == null) return false;
    return log.wordsReviewed > 0 ||
        log.wordsLearned > 0 ||
        log.minutesSpent > 0;
  }

  /// Menghitung streak harian dengan 1 kuota Streak Freeze otomatis (toleransi 1 hari bolong
  /// jika hari sebelumnya tetap aktif belajar, sehingga lembur 1 hari tidak menghanguskan motivasi).
  static StreakStatus calculateStreakWithFreeze({
    required Map<String, DailyLog> logsByDate,
    required DateTime today,
  }) {
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final todayKey = SrsRepository.formatDateKey(normalizedToday);
    final studiedToday = _isLogActive(logsByDate[todayKey]);

    var streak = studiedToday ? 1 : 0;
    var freezeAvailable = true;
    var freezeUsed = false;

    // Mulai telusuri mundur dari kemarin (H-1)
    var cursor = normalizedToday.subtract(const Duration(days: 1));

    while (true) {
      final key = SrsRepository.formatDateKey(cursor);
      final active = _isLogActive(logsByDate[key]);

      if (active) {
        streak += 1;
        cursor = cursor.subtract(const Duration(days: 1));
        continue;
      }

      // Hari ini kosong di riwayat: cek apakah H-1 dari cursor aktif & freeze masih tersedia
      if (freezeAvailable) {
        final dayBeforeCursor = cursor.subtract(const Duration(days: 1));
        final dayBeforeKey = SrsRepository.formatDateKey(dayBeforeCursor);
        if (_isLogActive(logsByDate[dayBeforeKey])) {
          freezeAvailable = false;
          freezeUsed = true;
          cursor = dayBeforeCursor;
          continue;
        }
      }

      break;
    }

    return StreakStatus(
      streakDays: streak,
      usedStreakFreeze: freezeUsed,
      studiedToday: studiedToday,
    );
  }

  /// Mengambil data lengkap untuk Beranda & halaman Statistik Progres.
  Future<ProgressDashboardData> loadDashboardData({DateTime? now}) async {
    final current = now ?? DateTime.now();
    final summary = await _db.getLearningSummary(current.millisecondsSinceEpoch);
    final allLogs = await _db.select(_db.dailyLogs).get();
    final logsMap = {for (final log in allLogs) log.date: log};

    final streak = calculateStreakWithFreeze(
      logsByDate: logsMap,
      today: current,
    );

    final normalizedToday = DateTime(current.year, current.month, current.day);
    final todayKey = SrsRepository.formatDateKey(normalizedToday);
    final todayLog = logsMap[todayKey];

    final last7Days = <DailyActivityPoint>[];
    for (var offset = 6; offset >= 0; offset--) {
      final d = normalizedToday.subtract(Duration(days: offset));
      final key = SrsRepository.formatDateKey(d);
      final log = logsMap[key];
      last7Days.add(
        DailyActivityPoint(
          dateKey: key,
          dayShortLabel: _weekdayLabelsId[d.weekday - 1],
          effectiveMinutes: computeEffectiveMinutes(log),
          wordsReviewed: log?.wordsReviewed ?? 0,
          wordsLearned: log?.wordsLearned ?? 0,
          isToday: offset == 0,
        ),
      );
    }

    return ProgressDashboardData(
      summary: summary,
      streak: streak,
      todayEffectiveMinutes: computeEffectiveMinutes(todayLog),
      todayWordsReviewed: todayLog?.wordsReviewed ?? 0,
      last7Days: last7Days,
    );
  }

  // ---------------------------------------------------------------------------
  // Pengaturan Preferensi (SharedPreferences)
  // ---------------------------------------------------------------------------

  Future<UserStudySettings> loadSettings({SharedPreferences? prefs}) async {
    final p = prefs ?? await SharedPreferences.getInstance();
    final goal = p.getInt(_keyGoalMinutes) ?? 10;
    final reminderOn = p.getBool(_keyReminderEnabled) ?? false;
    final hour = p.getInt(_keyReminderHour) ?? 20;
    final minute = p.getInt(_keyReminderMinute) ?? 0;
    final rawTheme = p.getString(_keyThemeMode) ?? 'system';

    final theme = switch (rawTheme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    return UserStudySettings(
      dailyGoalMinutes: goal,
      reminderEnabled: reminderOn,
      reminderHour: hour,
      reminderMinute: minute,
      themeMode: theme,
    );
  }

  Future<void> saveSettings(
    UserStudySettings settings, {
    SharedPreferences? prefs,
  }) async {
    final p = prefs ?? await SharedPreferences.getInstance();
    await p.setInt(_keyGoalMinutes, settings.dailyGoalMinutes);
    await p.setBool(_keyReminderEnabled, settings.reminderEnabled);
    await p.setInt(_keyReminderHour, settings.reminderHour);
    await p.setInt(_keyReminderMinute, settings.reminderMinute);

    final themeStr = switch (settings.themeMode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await p.setString(_keyThemeMode, themeStr);
  }
}
