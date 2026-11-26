import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/tts_service.dart';
import 'domain/srs_calculator.dart';
import 'presentation/srs_controller.dart';
import 'presentation/widgets/flashcard_view.dart';

class SrsScreen extends ConsumerWidget {
  const SrsScreen({super.key});

  static const List<(String, String)> _levels = [
    ('ALL', 'Semua'),
    ('A1', 'A1 Dasar'),
    ('A2', 'A2 Praktis'),
    ('B1', 'B1 Menengah'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(srsSessionProvider);
    final controller = ref.read(srsSessionProvider.notifier);
    final tts = ref.read(ttsServiceProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hafalan Kosakata (SRS)'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang sesi',
            onPressed: () => controller.loadSession(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // Baris Filter Level CEFR
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                for (final (code, label) in _levels) ...[
                  ChoiceChip(
                    label: Text(label),
                    selected: session.levelFilter == code,
                    onSelected: (selected) {
                      if (selected) {
                        controller.loadSession(levelFilter: code);
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),

          // Konten Utama
          Expanded(
            child: _buildBody(
              context: context,
              session: session,
              controller: controller,
              tts: tts,
              textTheme: textTheme,
              colorScheme: colorScheme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required SrsSessionState session,
    required SrsSessionController controller,
    required TtsService tts,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
  }) {
    if (session.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (session.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(session.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => controller.loadSession(),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final currentCard = session.currentCard;
    if (session.isSessionFinished || currentCard == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: colorScheme.secondary.withValues(alpha: 0.14),
                foregroundColor: colorScheme.secondary,
                child: const Icon(Icons.check_rounded, size: 36),
              ),
              const SizedBox(height: 20),
              Text(
                'Sesi Hafalan Selesai!',
                style: textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Otak dewasa butuh jeda istirahat agar kosakata pindah ke memori jangka panjang. Masih semangat lanjut sedikit lagi?',
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: controller.loadExtraNewWords,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Pelajari 5 Kata Baru Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final previews = session.currentIntervalPreviews;

    return Column(
      children: [
        // Indikator Progres Antrean Sesi
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kartu ${session.currentIndex + 1} dari ${session.queue.length}',
                    style: textTheme.bodyMedium,
                  ),
                  Text(
                    '${(session.progressFraction * 100).round()}%',
                    style: textTheme.labelLarge,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: session.progressFraction,
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),

        // Kartu Kosakata yang Dapat Di-scroll
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: FlashcardView(
              card: currentCard,
              isAnswerRevealed: session.isAnswerRevealed,
              onSpeak: (text, speed) => tts.speak(text, speed: speed),
              onRevealTap: controller.revealAnswer,
              onEditMnemonic: () => _showMnemonicEditor(
                context: context,
                word: currentCard.vocab.word,
                initialNote: currentCard.vocab.mnemonicNote,
                onSave: controller.updateCurrentCardMnemonic,
              ),
            ),
          ),
        ),

        // Baris Tombol Bawah (Buka Jawaban atau 4 Tombol SM-2)
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: session.isAnswerRevealed
                ? Row(
                    children: [
                      _RatingButton(
                        rating: ReviewRating.again,
                        intervalLabel: previews[ReviewRating.again] ?? '10 mnt',
                        accentColor: const Color(0xFFC04A3E),
                        onTap: () =>
                            controller.rateCurrentCard(ReviewRating.again),
                      ),
                      const SizedBox(width: 8),
                      _RatingButton(
                        rating: ReviewRating.hard,
                        intervalLabel: previews[ReviewRating.hard] ?? '1 hr',
                        accentColor: colorScheme.tertiary,
                        onTap: () =>
                            controller.rateCurrentCard(ReviewRating.hard),
                      ),
                      const SizedBox(width: 8),
                      _RatingButton(
                        rating: ReviewRating.good,
                        intervalLabel: previews[ReviewRating.good] ?? '1 hr',
                        accentColor: colorScheme.primary,
                        onTap: () =>
                            controller.rateCurrentCard(ReviewRating.good),
                      ),
                      const SizedBox(width: 8),
                      _RatingButton(
                        rating: ReviewRating.easy,
                        intervalLabel: previews[ReviewRating.easy] ?? '4 hr',
                        accentColor: colorScheme.secondary,
                        onTap: () =>
                            controller.rateCurrentCard(ReviewRating.easy),
                      ),
                    ],
                  )
                : SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: controller.revealAnswer,
                      icon: const Icon(Icons.visibility_outlined),
                      label: const Text('Lihat Arti & Jembatan Keledai'),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _showMnemonicEditor({
    required BuildContext context,
    required String word,
    required String? initialNote,
    required Future<void> Function(String? note) onSave,
  }) async {
    final textController = TextEditingController(text: initialNote ?? '');
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, bottomInset + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Jembatan Keledai untuk "$word"',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                'Kaitkan bunyi atau bentuk katanya dengan kata bahasa Indonesia, pengalaman kantor, atau hal lucu yang akrab bagimu.',
                style: Theme.of(sheetContext).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                maxLines: 3,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Contoh: Bunyinya mirip kata...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    Navigator.of(sheetContext).pop(textController.text),
                child: const Text('Simpan Jembatan Keledai'),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      await onSave(result);
    }
  }
}

class _RatingButton extends StatelessWidget {
  const _RatingButton({
    required this.rating,
    required this.intervalLabel,
    required this.accentColor,
    required this.onTap,
  });

  final ReviewRating rating;
  final String intervalLabel;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accentColor.withValues(alpha: 0.35)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                intervalLabel,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                rating.labelId,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
