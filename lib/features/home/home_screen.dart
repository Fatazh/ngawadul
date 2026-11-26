import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../progress/presentation/progress_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final dashboardAsync = ref.watch(progressDashboardProvider);
    final settings = ref.watch(studySettingsProvider);

    final streakDays = dashboardAsync.valueOrNull?.streak.streakDays ?? 0;
    final freezeUsed =
        dashboardAsync.valueOrNull?.streak.usedStreakFreeze ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rencana Hari Ini'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(
              avatar: Icon(
                freezeUsed
                    ? Icons.ac_unit_rounded
                    : Icons.local_fire_department_rounded,
                size: 18,
                color: freezeUsed ? colorScheme.primary : colorScheme.tertiary,
              ),
              label: Text('$streakDays Hari'),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Fokus ${settings.dailyGoalMinutes} menit saja hari ini.',
            style: textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Konsisten sedikit demi sedikit jauh lebih kuat daripada menghafal banyak sekaligus.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),

          // Kartu Progres Target Harian & Ringkasan Database
          dashboardAsync.when(
            data: (data) {
              final goal = settings.dailyGoalMinutes;
              final fraction =
                  goal > 0 ? (data.todayEffectiveMinutes / goal).clamp(0.0, 1.0) : 1.0;
              final goalReached = data.todayEffectiveMinutes >= goal;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            goalReached
                                ? 'Target Harian Tercapai!'
                                : 'Progres Hari Ini',
                            style: textTheme.titleMedium?.copyWith(
                              color: goalReached ? colorScheme.secondary : null,
                            ),
                          ),
                          Text(
                            '${data.todayEffectiveMinutes} / $goal mnt',
                            style: textTheme.labelLarge?.copyWith(
                              color: goalReached
                                  ? colorScheme.secondary
                                  : colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: fraction,
                          minHeight: 8,
                          color: goalReached
                              ? colorScheme.secondary
                              : colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _MiniStat(
                            label: 'Siap Diulang',
                            value: '${data.summary.dueTodayCount}',
                            color: colorScheme.tertiary,
                          ),
                          _MiniStat(
                            label: 'Bank Kata',
                            value:
                                '${data.summary.masteredCount}/${data.summary.totalVocab}',
                            color: colorScheme.primary,
                          ),
                          _MiniStat(
                            label: 'Bacaan',
                            value:
                                '${data.summary.readPassagesCount}/${data.summary.totalPassagesCount}',
                            color: colorScheme.secondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: LinearProgressIndicator()),
              ),
            ),
            error: (_, __) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Menyiapkan ringkasan belajar lokal...',
                  style: textTheme.bodyMedium,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 3 Langkah Belajar Harian
          _DailyStepCard(
            stepNumber: '1',
            title: 'Ulangi & Tambah Kosakata (SRS)',
            subtitle: dashboardAsync.valueOrNull != null &&
                    dashboardAsync.valueOrNull!.summary.dueTodayCount > 0
                ? '${dashboardAsync.valueOrNull!.summary.dueTodayCount} kata jatuh tempo hari ini • Ketuk untuk mulai mengulang.'
                : 'Pelajari kata baru level A1–B1 dengan contoh kalimat & jembatan keledai.',
            durationLabel: '5 mnt',
            icon: Icons.style_rounded,
            onTap: () => ref.read(navigationIndexProvider.notifier).state = 1,
          ),
          const SizedBox(height: 12),
          _DailyStepCard(
            stepNumber: '2',
            title: 'Baca Cerita / Dialog Pendek',
            subtitle: dashboardAsync.valueOrNull != null
                ? '${dashboardAsync.valueOrNull!.summary.readPassagesCount} dari ${dashboardAsync.valueOrNull!.summary.totalPassagesCount} bacaan selesai • Ketuk kata sulit untuk terjemahan.'
                : 'Ketuk kata yang belum dimengerti untuk melihat arti & mendengar suara.',
            durationLabel: '3 mnt',
            icon: Icons.menu_book_rounded,
            onTap: () => ref.read(navigationIndexProvider.notifier).state = 2,
          ),
          const SizedBox(height: 12),
          _DailyStepCard(
            stepNumber: '3',
            title: 'Latihan Pola Kalimat Praktis',
            subtitle: dashboardAsync.valueOrNull != null
                ? '${dashboardAsync.valueOrNull!.summary.completedGrammarCount} dari ${dashboardAsync.valueOrNull!.summary.totalGrammarCount} pola dikuasai • Pahami logika & susun kata.'
                : 'Pahami struktur kalimat tanpa istilah rumit lalu susun kata.',
            durationLabel: '2 mnt',
            icon: Icons.extension_rounded,
            onTap: () => ref.read(navigationIndexProvider.notifier).state = 3,
          ),
        ],
      ),
    );
  }
}

class _DailyStepCard extends StatelessWidget {
  const _DailyStepCard({
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    required this.durationLabel,
    required this.icon,
    required this.onTap,
  });

  final String stepNumber;
  final String title;
  final String subtitle;
  final String durationLabel;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                foregroundColor: colorScheme.primary,
                child: Icon(icon, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(title, style: textTheme.titleMedium),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color:
                                colorScheme.secondary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            durationLabel,
                            style: textTheme.labelLarge?.copyWith(
                              fontSize: 12,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(color: color),
        ),
        const SizedBox(height: 2),
        Text(label, style: textTheme.bodyMedium?.copyWith(fontSize: 12)),
      ],
    );
  }
}
