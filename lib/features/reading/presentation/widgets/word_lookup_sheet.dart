import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_providers.dart';
import '../../../../core/services/tts_service.dart';
import '../../../srs/presentation/srs_controller.dart';
import '../../data/reading_repository.dart';
import '../reading_providers.dart';

/// BottomSheet yang muncul saat pengguna mengetuk sebuah kata di dalam bacaan.
class WordLookupSheet extends ConsumerStatefulWidget {
  const WordLookupSheet({
    super.key,
    required this.initialResult,
    required this.contextSentenceEn,
  });

  final WordLookupResult initialResult;
  final String contextSentenceEn;

  @override
  ConsumerState<WordLookupSheet> createState() => _WordLookupSheetState();
}

class _WordLookupSheetState extends ConsumerState<WordLookupSheet> {
  late bool _isSavedToSrs;
  late final TextEditingController _customMeaningController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _isSavedToSrs = widget.initialResult.isInSrsQueue;
    _customMeaningController = TextEditingController(
      text: widget.initialResult.quickGlossId ?? '',
    );
  }

  @override
  void dispose() {
    _customMeaningController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveExistingVocab(int vocabId) async {
    setState(() => _isSaving = true);
    final repo = ref.read(readingRepositoryProvider);
    await repo.addVocabToSrsQueue(vocabId);

    ref.invalidate(srsSessionProvider);
    ref.invalidate(learningSummaryProvider);

    if (mounted) {
      setState(() {
        _isSavedToSrs = true;
        _isSaving = false;
      });
    }
  }

  Future<void> _handleSaveCustomWord() async {
    final meaning = _customMeaningController.text.trim();
    if (meaning.isEmpty) return;

    setState(() => _isSaving = true);
    final repo = ref.read(readingRepositoryProvider);
    await repo.saveCustomWordAndEnqueue(
      word: widget.initialResult.tappedWord,
      meaningId: meaning,
      contextSentenceEn: widget.contextSentenceEn,
    );

    ref.invalidate(srsSessionProvider);
    ref.invalidate(learningSummaryProvider);

    if (mounted) {
      setState(() {
        _isSavedToSrs = true;
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tts = ref.read(ttsServiceProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final vocab = widget.initialResult.vocabItem;
    final spokenWord = vocab?.word ?? widget.initialResult.tappedWord;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(22, 8, 22, bottomInset + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Kata & Badge Level
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.initialResult.tappedWord,
                      style: textTheme.headlineMedium,
                    ),
                    if (vocab != null)
                      Text(
                        '${vocab.word != widget.initialResult.tappedWord.toLowerCase() ? 'Bentuk dasar: ${vocab.word}  •  ' : ''}${vocab.partOfSpeech}  •  ${vocab.phonetic}',
                        style: textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
              if (vocab != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    vocab.level,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Tombol Suara 1.0x & 0.75x
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => tts.speak(spokenWord, speed: SpeechSpeed.normal),
                icon: const Icon(Icons.volume_up_rounded, size: 18),
                label: const Text('1.0x Normal'),
              ),
              OutlinedButton.icon(
                onPressed: () => tts.speak(spokenWord, speed: SpeechSpeed.slow),
                icon: const Icon(Icons.speed_rounded, size: 18),
                label: const Text('0.75x Lambat'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Konten Arti Kata
          if (vocab != null) ...[
            Text(
              vocab.meaningId,
              style: textTheme.titleLarge?.copyWith(color: colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Text(
              '"${vocab.exampleEn}"',
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(vocab.exampleId, style: textTheme.bodyMedium),
            if (vocab.mnemonicNote != null &&
                vocab.mnemonicNote!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.tertiary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 18,
                      color: colorScheme.tertiary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        vocab.mnemonicNote!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: (_isSavedToSrs || _isSaving)
                  ? null
                  : () => _handleSaveExistingVocab(vocab.id),
              icon: Icon(
                _isSavedToSrs
                    ? Icons.check_circle_outline_rounded
                    : Icons.bookmark_add_outlined,
              ),
              label: Text(
                _isSavedToSrs
                    ? 'Sudah di Antrean Hafalan (SRS)'
                    : 'Simpan ke Hafalan (SRS)',
              ),
            ),
          ] else ...[
            if (widget.initialResult.quickGlossId != null) ...[
              Text('Arti Kontekstual', style: textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(
                widget.initialResult.quickGlossId!,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 14),
            ],
            if (!_isSavedToSrs) ...[
              TextField(
                controller: _customMeaningController,
                decoration: InputDecoration(
                  labelText: 'Arti Bahasa Indonesia (untuk kartu hafalan)',
                  hintText: 'Tulis arti kata ini...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
            FilledButton.icon(
              onPressed:
                  (_isSavedToSrs || _isSaving) ? null : _handleSaveCustomWord,
              icon: Icon(
                _isSavedToSrs
                    ? Icons.check_circle_outline_rounded
                    : Icons.add_task_rounded,
              ),
              label: Text(
                _isSavedToSrs
                    ? 'Tersimpan di Hafalan (SRS)'
                    : 'Tambahkan & Simpan ke Hafalan',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
