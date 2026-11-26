import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/progress_repository.dart';
import 'presentation/progress_providers.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(progressDashboardProvider);
    final settings = ref.watch(studySettingsProvider);
    final settingsNotifier = ref.read(studySettingsProvider.notifier);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Progres & Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          // Bagian Statistik (Penguasaan Kata & Aktivitas 7 Hari)
          dashboardAsync.when(
            data: (data) => Column(
              children: [
                _VocabMasteryCard(
                  data: data,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 14),
                _WeeklyActivityCard(
                  data: data,
                  dailyGoalMinutes: settings.dailyGoalMinutes,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ],
            ),
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (err, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Gagal memuat statistik: $err'),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Kartu Pengaturan Target Harian
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Target Waktu Harian', style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Sesuaikan dengan kesibukan kerja Anda. Lebih baik 5 menit rutin daripada 1 jam tapi berhenti.',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(
                          value: 5,
                          label: Text('5 mnt'),
                          icon: Icon(Icons.coffee_outlined),
                        ),
                        ButtonSegment(
                          value: 10,
                          label: Text('10 mnt'),
                          icon: Icon(Icons.schedule_rounded),
                        ),
                        ButtonSegment(
                          value: 15,
                          label: Text('15 mnt'),
                          icon: Icon(Icons.bolt_rounded),
                        ),
                      ],
                      selected: {settings.dailyGoalMinutes},
                      onSelectionChanged: (sel) {
                        settingsNotifier.setDailyGoalMinutes(sel.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Kartu Pengaturan Pengingat Belajar Lokal
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(
                      'Pengingat Belajar Harian',
                      style: textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      'Notifikasi lokal offline agar tidak lupa mengulang kosakata.',
                      style: textTheme.bodyMedium,
                    ),
                    value: settings.reminderEnabled,
                    onChanged: settingsNotifier.toggleReminder,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Icon(
                      Icons.alarm_rounded,
                      color: colorScheme.primary,
                    ),
                    title: const Text('Jam Pengingat'),
                    subtitle: Text(
                      'Saat ini disetel pukul ${settings.formattedReminderTime}',
                    ),
                    trailing: OutlinedButton(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: settings.reminderHour,
                            minute: settings.reminderMinute,
                          ),
                        );
                        if (picked != null) {
                          await settingsNotifier.setReminderTime(
                            hour: picked.hour,
                            minute: picked.minute,
                          );
                        }
                      },
                      child: Text(settings.formattedReminderTime),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Kartu Pengaturan Tampilan Layar
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tampilan Layar', style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Pilih mode gelap saat belajar malam hari agar mata tetap nyaman.',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text('Otomatis'),
                          icon: Icon(Icons.brightness_auto_outlined),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text('Terang'),
                          icon: Icon(Icons.light_mode_outlined),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text('Gelap'),
                          icon: Icon(Icons.dark_mode_outlined),
                        ),
                      ],
                      selected: {settings.themeMode},
                      onSelectionChanged: (selection) {
                        settingsNotifier.setThemeMode(selection.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VocabMasteryCard extends StatelessWidget {
  const _VocabMasteryCard({
    required this.data,
    required this.colorScheme,
    required this.textTheme,
  });

  final ProgressDashboardData data;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final s = data.summary;
    final total = s.totalVocab > 0 ? s.totalVocab : 1;
    final unlearned =
        (s.totalVocab - s.masteredCount - s.learningCount).clamp(0, s.totalVocab);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Penguasaan Kosakata (A1–B1)', style: textTheme.titleMedium),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: [
                    if (s.masteredCount > 0)
                      Expanded(
                        flex: s.masteredCount,
                        child: Container(color: colorScheme.secondary),
                      ),
                    if (s.learningCount > 0)
                      Expanded(
                        flex: s.learningCount,
                        child: Container(color: colorScheme.primary),
                      ),
                    if (unlearned > 0 || s.totalVocab == 0)
                      Expanded(
                        flex: unlearned > 0 ? unlearned : total,
                        child: Container(
                          color: colorScheme.primary.withValues(alpha: 0.14),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _LegendItem(
                  color: colorScheme.secondary,
                  label: 'Dikuasai',
                  count: s.masteredCount,
                ),
                _LegendItem(
                  color: colorScheme.primary,
                  label: 'Dipelajari',
                  count: s.learningCount,
                ),
                _LegendItem(
                  color: colorScheme.primary.withValues(alpha: 0.30),
                  label: 'Kata Baru',
                  count: unlearned,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.count,
  });

  final Color color;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text('$label: ', style: textTheme.bodyMedium?.copyWith(fontSize: 13)),
        Text(
          '$count',
          style: textTheme.labelLarge?.copyWith(fontSize: 13),
        ),
      ],
    );
  }
}

class _WeeklyActivityCard extends StatelessWidget {
  const _WeeklyActivityCard({
    required this.data,
    required this.dailyGoalMinutes,
    required this.colorScheme,
    required this.textTheme,
  });

  final ProgressDashboardData data;
  final int dailyGoalMinutes;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final maxMinutes = [
      dailyGoalMinutes,
      ...data.last7Days.map((d) => d.effectiveMinutes),
    ].reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Konsistensi 7 Hari Terakhir', style: textTheme.titleMedium),
                Text(
                  '${data.weeklyReviewedTotal} review',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 110,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final point in data.last7Days)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            point.effectiveMinutes > 0
                                ? '${point.effectiveMinutes}m'
                                : '',
                            style: const TextStyle(fontSize: 10),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 20,
                            height: point.effectiveMinutes == 0
                                ? 6
                                : (64 * (point.effectiveMinutes / maxMinutes))
                                    .clamp(10.0, 64.0),
                            decoration: BoxDecoration(
                              color: point.effectiveMinutes >= dailyGoalMinutes
                                  ? colorScheme.secondary
                                  : point.effectiveMinutes > 0
                                      ? colorScheme.primary
                                      : colorScheme.primary
                                          .withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            point.dayShortLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: point.isToday
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: point.isToday
                                  ? colorScheme.primary
                                  : textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.tertiary.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 18,
                    color: colorScheme.tertiary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data.streak.usedStreakFreeze
                          ? 'Streak Freeze aktif! 1 hari sibuk kemarin tidak menghanguskan rentetan ${data.streak.streakDays} hari Anda.'
                          : 'Dilengkapi Streak Freeze otomatis: libur 1 hari karena lembur tidak akan mereset streak ke nol.',
                      style: textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
