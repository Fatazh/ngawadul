import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/grammar_repository.dart';
import 'presentation/grammar_lesson_screen.dart';
import 'presentation/grammar_providers.dart';

class GrammarScreen extends ConsumerWidget {
  const GrammarScreen({super.key});

  static const List<(String, String)> _levels = [
    ('ALL', 'Semua'),
    ('A1', 'A1 Dasar'),
    ('A2', 'A2 Praktis'),
    ('B1', 'B1 Menengah'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLevel = ref.watch(grammarLevelFilterProvider);
    final lessonsAsync = ref.watch(filteredGrammarLessonsProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pola Kalimat Praktis'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                for (final (code, label) in _levels) ...[
                  ChoiceChip(
                    label: Text(label),
                    selected: selectedLevel == code,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(grammarLevelFilterProvider.notifier).state =
                            code;
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          Expanded(
            child: lessonsAsync.when(
              data: (lessons) {
                if (lessons.isEmpty) {
                  return Center(
                    child: Text(
                      'Belum ada materi untuk filter ini.',
                      style: textTheme.bodyMedium,
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: lessons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final parsed = lessons[index];
                    return _GrammarLessonCard(
                      parsed: parsed,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                GrammarLessonScreen(parsedLesson: parsed),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Gagal memuat materi pola kalimat: $err',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GrammarLessonCard extends StatelessWidget {
  const _GrammarLessonCard({
    required this.parsed,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
  });

  final ParsedGrammarLesson parsed;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final row = parsed.lesson;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      row.level,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${parsed.quizzes.length} Soal Susun Kata',
                    style: textTheme.bodyMedium?.copyWith(fontSize: 13),
                  ),
                  const Spacer(),
                  if (row.isCompleted)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Selesai',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.secondary,
                          ),
                        ),
                      ],
                    )
                  else
                    Icon(
                      Icons.chevron_right_rounded,
                      color: textTheme.bodyMedium?.color,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(row.title, style: textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(
                row.formula,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
