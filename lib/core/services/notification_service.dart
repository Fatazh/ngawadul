import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Layanan pengingat lokal harian di Android agar kebiasaan belajar tetap terjaga
/// tanpa memerlukan server atau koneksi internet.
class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  static const int dailyReminderId = 1001;
  static const String channelId = 'daily_study_reminder';
  static const String channelName = 'Pengingat Belajar Harian';

  Future<void> init() async {
    if (_initialized) return;

    try {
      tz_data.initializeTimeZones();

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const settings = InitializationSettings(android: androidSettings);

      await _plugin.initialize(settings);
      _initialized = true;
    } catch (_) {
      // Aman diabaikan pada lingkungan unit test non-perangkat
    }
  }

  /// Meminta izin notifikasi pada Android 13 - Android 16+.
  Future<bool> requestPermissionIfNeeded() async {
    try {
      await init();
      final androidImpl = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl == null) return false;
      final granted = await androidImpl.requestNotificationsPermission();
      return granted ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Menjadwalkan pengingat harian pada jam & menit lokal pilihan pengguna.
  /// Menggunakan `inexactAllowWhileIdle` agar ramah baterai dan tidak memerlukan
  /// izin khusus exact-alarm di Android 14 - Android 16.
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required int dailyGoalMinutes,
  }) async {
    try {
      await init();
      await requestPermissionIfNeeded();

      final nowLocal = DateTime.now();
      var targetLocal = DateTime(
        nowLocal.year,
        nowLocal.month,
        nowLocal.day,
        hour,
        minute,
      );
      if (!targetLocal.isAfter(nowLocal)) {
        targetLocal = targetLocal.add(const Duration(days: 1));
      }

      // Konversi waktu lokal HP ke TZDateTime berbasis UTC agar akurat di zona waktu mana pun
      final scheduledUtc = tz.TZDateTime.from(targetLocal.toUtc(), tz.UTC);

      await _plugin.zonedSchedule(
        dailyReminderId,
        'Waktunya Fokus $dailyGoalMinutes Menit',
        'Ulangi beberapa kosakata santai hari ini agar ingatan makin menempel.',
        scheduledUtc,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription:
                'Pengingat rutin harian untuk sesi belajar bahasa Inggris',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {
      // Aman jika dijalankan pada simulator/test tanpa layanan sistem Android
    }
  }

  /// Membatalkan pengingat harian.
  Future<void> cancelDailyReminder() async {
    try {
      await init();
      await _plugin.cancel(dailyReminderId);
    } catch (_) {
      // Abaikan pada lingkungan test
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
