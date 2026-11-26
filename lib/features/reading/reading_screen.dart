import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import 'presentation/passage_reader_screen.dart';
import 'presentation/reading_providers.dart';

class ReadingScreen extends ConsumerWidget {
  const ReadingScreen({super.key});

  static const List<(String, String)> _levels = [
    ('ALL', 'Semua'),
    ('A1', 'A1 Dasar'),
    ('A2', 'A2 Praktis'),
    ('B1', 'B1 Menengah'),
  ];

  static String _topicLabel(String topic) {
    switch (topic) {
      case 'work':
        return 'Kerja & Kantor';
      case 'daily':
        return 'Keseharian';
      case 'travel':
        return 'Perjalanan';
      case 'social':
        return 'Sosial & Hidup';
      case 'tech':
        return 'Teknologi';
      default:
        return topic;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLevel = ref.watch(readingLevelFilterProvider);
    final passagesAsync = ref.watch(filteredReadingPassagesProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bacaan Kontekstual'),
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
                        ref.read(readingLevelFilterProvider.notifier).state =
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
            child: passagesAsync.when(
              data: (passages) {
                if (passages.isEmpty) {
                  return Center(
                    child: Text(
                      'Belum ada bacaan untuk filter ini.',
                      style: textTheme.bodyMedium,
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: passages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = passages[index];
                    return _PassageCard(
                      passage: item,
                      topicLabel: _topicLabel(item.topic),
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => PassageReaderScreen(passage: item),
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
                    'Gagal memuat daftar bacaan: $err',
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

class _PassageCard extends StatelessWidget {
  const _PassageCard({
    required this.passage,
    required this.topicLabel,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
  });

  final ReadingPassage passage;
  final String topicLabel;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                      passage.level,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    topicLabel,
                    style: textTheme.bodyMedium?.copyWith(fontSize: 13),
                  ),
                  const Spacer(),
                  if (passage.isRead)
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
              Text(passage.title, style: textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(
                passage.contentEn,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
