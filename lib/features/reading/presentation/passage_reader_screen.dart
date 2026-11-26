import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/services/tts_service.dart';
import '../data/reading_repository.dart';
import 'reading_providers.dart';
import 'widgets/word_lookup_sheet.dart';

/// Kelompok kata interaktif beserta tanda baca tempelan di belakangnya (misal 'morning,').
class _WordDisplayChunk {
  const _WordDisplayChunk({
    required this.word,
    required this.cleanWord,
    required this.trailingPunctuation,
  });

  final String word;
  final String cleanWord;
  final String trailingPunctuation;
}

class PassageReaderScreen extends ConsumerStatefulWidget {
  const PassageReaderScreen({
    super.key,
    required this.passage,
  });

  final ReadingPassage passage;

  @override
  ConsumerState<PassageReaderScreen> createState() =>
      _PassageReaderScreenState();
}

class _PassageReaderScreenState extends ConsumerState<PassageReaderScreen> {
  bool _showTranslation = false;
  late bool _isMarkedRead;
  late final List<_WordDisplayChunk> _chunks;

  @override
  void initState() {
    super.initState();
    _isMarkedRead = widget.passage.isRead;
    _chunks = _buildDisplayChunks(widget.passage.contentEn);
  }

  @override
  void deactivate() {
    ref.read(ttsServiceProvider).stop();
    super.deactivate();
  }

  static List<_WordDisplayChunk> _buildDisplayChunks(String paragraph) {
    final tokens = ReadingRepository.tokenizeParagraph(paragraph);
    final result = <_WordDisplayChunk>[];

    var i = 0;
    while (i < tokens.length) {
      final token = tokens[i];
      if (token.isInteractiveWord) {
        var trailing = '';
        if (i + 1 < tokens.length && !tokens[i + 1].isInteractiveWord) {
          trailing = tokens[i + 1].raw.trimRight();
          i += 1;
        }
        result.add(
          _WordDisplayChunk(
            word: token.raw,
            cleanWord: token.cleanWord,
            trailingPunctuation: trailing,
          ),
        );
      }
      i += 1;
    }
    return result;
  }

  String _extractContainingSentence(String targetWord) {
    final sentences = widget.passage.contentEn.split(RegExp(r'(?<=[.!?])\s+'));
    final lower = targetWord.toLowerCase();
    for (final s in sentences) {
      if (s.toLowerCase().contains(lower)) {
        return s.trim();
      }
    }
    return widget.passage.contentEn;
  }

  Future<void> _onWordTap(String rawWord) async {
    final repo = ref.read(readingRepositoryProvider);
    final lookup = await repo.lookupWord(rawWord);
    if (!mounted) return;

    final sentence = _extractContainingSentence(rawWord);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => WordLookupSheet(
        initialResult: lookup,
        contextSentenceEn: sentence,
      ),
    );
  }

  Future<void> _handleMarkRead() async {
    final repo = ref.read(readingRepositoryProvider);
    await repo.completePassageReading(widget.passage);
    ref.invalidate(learningSummaryProvider);

    if (mounted) {
      setState(() => _isMarkedRead = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bacaan selesai! +3 menit tercatat di progres harian.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tts = ref.read(ttsServiceProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.passage.level}'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          Text(
            widget.passage.title,
            style: textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),

          // Bar Kontrol Pemutar Suara Bacaan (1.0x, 0.75x, Stop)
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: ValueListenableBuilder<bool>(
                valueListenable: tts.isSpeaking,
                builder: (context, speaking, _) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: () => tts.speak(
                          widget.passage.contentEn,
                          speed: SpeechSpeed.normal,
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 20),
                        label: const Text('1.0x Normal'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => tts.speak(
                          widget.passage.contentEn,
                          speed: SpeechSpeed.slow,
                        ),
                        icon: const Icon(Icons.speed_rounded, size: 18),
                        label: const Text('0.75x Lambat'),
                      ),
                      if (speaking)
                        IconButton.filledTonal(
                          tooltip: 'Hentikan suara',
                          onPressed: tts.stop,
                          icon: const Icon(Icons.stop_rounded),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Petunjuk Ketuk Kata
          Row(
            children: [
              Icon(
                Icons.touch_app_outlined,
                size: 16,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Ketuk kata mana pun di bawah untuk melihat arti & simpan ke hafalan.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Kotak Paragraf Bahasa Inggris Interaktif
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 6,
                runSpacing: 10,
                children: [
                  for (final chunk in _chunks)
                    InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => _onWordTap(chunk.word),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 1,
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: chunk.word,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontSize: 18,
                                  height: 1.4,
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.dotted,
                                  decorationColor: colorScheme.primary
                                      .withValues(alpha: 0.45),
                                ),
                              ),
                              if (chunk.trailingPunctuation.isNotEmpty)
                                TextSpan(
                                  text: chunk.trailingPunctuation,
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontSize: 18,
                                    height: 1.4,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Toggle Terjemahan Bahasa Indonesia
          OutlinedButton.icon(
            onPressed: () =>
                setState(() => _showTranslation = !_showTranslation),
            icon: Icon(
              _showTranslation
                  ? Icons.visibility_off_outlined
                  : Icons.translate_rounded,
            ),
            label: Text(
              _showTranslation
                  ? 'Sembunyikan Terjemahan Indonesia'
                  : 'Tampilkan Terjemahan Indonesia',
            ),
          ),

          if (_showTranslation) ...[
            const SizedBox(height: 12),
            Card(
              color: colorScheme.secondary.withValues(alpha: 0.08),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terjemahan Kontekstual',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.passage.contentId,
                      style: textTheme.bodyLarge?.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Tombol Tandai Selesai Dibaca
          FilledButton.icon(
            onPressed: _isMarkedRead ? null : _handleMarkRead,
            icon: Icon(
              _isMarkedRead
                  ? Icons.check_circle_rounded
                  : Icons.task_alt_rounded,
            ),
            label: Text(
              _isMarkedRead
                  ? 'Sudah Selesai Dibaca'
                  : 'Tandai Selesai Dibaca (+3 Menit)',
            ),
          ),
        ],
      ),
    );
  }
}
