import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_providers.dart';
import '../../../core/services/tts_service.dart';
import '../data/grammar_repository.dart';
import 'grammar_providers.dart';
import 'widgets/sentence_builder_quiz.dart';

class GrammarLessonScreen extends ConsumerStatefulWidget {
  const GrammarLessonScreen({
    super.key,
    required this.parsedLesson,
  });

  final ParsedGrammarLesson parsedLesson;

  @override
  ConsumerState<GrammarLessonScreen> createState() =>
      _GrammarLessonScreenState();
}

class _GrammarLessonScreenState extends ConsumerState<GrammarLessonScreen> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.parsedLesson.lesson.isCompleted;
  }

  @override
  void deactivate() {
    ref.read(ttsServiceProvider).stop();
    super.deactivate();
  }

  Future<void> _handleCompleteLesson() async {
    final repo = ref.read(grammarRepositoryProvider);
    await repo.completeLesson(widget.parsedLesson.lesson);
    ref.invalidate(learningSummaryProvider);

    if (mounted) {
      setState(() => _isCompleted = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pola kalimat dikuasai! +2 menit tercatat hari ini.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.parsedLesson.lesson;
    final examples = widget.parsedLesson.examples;
    final quizzes = widget.parsedLesson.quizzes;
    final tts = ref.read(ttsServiceProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pola Level ${lesson.level}'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          Text(lesson.title, style: textTheme.headlineMedium),
          const SizedBox(height: 16),

          // Penjelasan Bahasa Sehari-hari
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.psychology_outlined,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Logika Sederhananya',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    lesson.explanationId,
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Kotak Rumus Pola Cepat
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pola Cepat',
                  style: textTheme.labelLarge?.copyWith(
                    fontSize: 12,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lesson.formula,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Daftar Contoh Kalimat + Audio TTS
          Text('Contoh Kalimat Nyata', style: textTheme.titleMedium),
          const SizedBox(height: 10),
          for (final ex in examples) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ex.en,
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(ex.id, style: textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Dengar 1.0x Normal',
                      onPressed: () => tts.speak(ex.en, speed: SpeechSpeed.normal),
                      icon: Icon(
                        Icons.volume_up_rounded,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Dengar 0.75x Lambat',
                      onPressed: () => tts.speak(ex.en, speed: SpeechSpeed.slow),
                      icon: Icon(
                        Icons.speed_rounded,
                        size: 20,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],

          const SizedBox(height: 14),

          // Komponen Latihan Interaktif Sentence Builder
          SentenceBuilderQuiz(
            quizzes: quizzes,
            isLessonCompleted: _isCompleted,
            onSpeak: (text, speed) => tts.speak(text, speed: speed),
            onAllQuizzesCompleted: _handleCompleteLesson,
          ),
        ],
      ),
    );
  }
}
