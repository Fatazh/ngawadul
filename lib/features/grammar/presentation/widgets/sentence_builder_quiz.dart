import 'package:material_ui/material_ui.dart';

import '../../../../core/services/tts_service.dart';
import '../../data/grammar_repository.dart';

/// Widget latihan interaktif menyusun keping kata bahasa Inggris (Sentence Builder).
class SentenceBuilderQuiz extends StatefulWidget {
  const SentenceBuilderQuiz({
    super.key,
    required this.quizzes,
    required this.isLessonCompleted,
    required this.onSpeak,
    required this.onAllQuizzesCompleted,
  });

  final List<SentenceQuizItem> quizzes;
  final bool isLessonCompleted;
  final void Function(String text, SpeechSpeed speed) onSpeak;
  final Future<void> Function() onAllQuizzesCompleted;

  @override
  State<SentenceBuilderQuiz> createState() => _SentenceBuilderQuizState();
}

enum _CheckStatus { idle, correct, incorrect }

class _SentenceBuilderQuizState extends State<SentenceBuilderQuiz> {
  int _quizIndex = 0;
  late List<IndexedWordChip> _bankChips;
  final List<IndexedWordChip> _selectedChips = [];
  _CheckStatus _status = _CheckStatus.idle;
  bool _showHint = false;
  bool _allFinished = false;

  SentenceQuizItem get _currentQuiz => widget.quizzes[_quizIndex];

  @override
  void initState() {
    super.initState();
    _prepareCurrentQuestion();
  }

  void _prepareCurrentQuestion() {
    _bankChips = _currentQuiz.buildShuffledBank();
    _selectedChips.clear();
    _status = _CheckStatus.idle;
    _showHint = false;
  }

  void _selectChip(IndexedWordChip chip) {
    if (_status == _CheckStatus.correct) return;
    setState(() {
      _selectedChips.add(chip);
      if (_status == _CheckStatus.incorrect) {
        _status = _CheckStatus.idle;
      }
    });
  }

  void _removeChip(IndexedWordChip chip) {
    if (_status == _CheckStatus.correct) return;
    setState(() {
      _selectedChips.removeWhere((c) => c.id == chip.id);
      if (_status == _CheckStatus.incorrect) {
        _status = _CheckStatus.idle;
      }
    });
  }

  void _resetSelection() {
    if (_status == _CheckStatus.correct) return;
    setState(() {
      _selectedChips.clear();
      _status = _CheckStatus.idle;
    });
  }

  void _checkAnswer() {
    final chosenWords = _selectedChips.map((c) => c.text).toList();
    final isRight = _currentQuiz.isCorrectOrder(chosenWords);

    setState(() {
      _status = isRight ? _CheckStatus.correct : _CheckStatus.incorrect;
      if (!isRight) {
        _showHint = true;
      }
    });

    if (isRight) {
      widget.onSpeak(_currentQuiz.targetSentence, SpeechSpeed.normal);
    }
  }

  Future<void> _nextOrFinish() async {
    if (_quizIndex + 1 < widget.quizzes.length) {
      setState(() {
        _quizIndex += 1;
        _prepareCurrentQuestion();
      });
    } else {
      await widget.onAllQuizzesCompleted();
      if (mounted) {
        setState(() => _allFinished = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quizzes.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_allFinished) {
      return Card(
        color: colorScheme.secondary.withValues(alpha: 0.10),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Icon(
                Icons.celebration_rounded,
                size: 38,
                color: colorScheme.secondary,
              ),
              const SizedBox(height: 12),
              Text(
                'Semua Latihan Pola Ini Beres!',
                style: textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Otak Anda baru saja berlatih menyusun kalimat secara aktif, bukan sekadar menghafal rumus.',
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _quizIndex = 0;
                    _allFinished = false;
                    _prepareCurrentQuestion();
                  });
                },
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Ulangi Latihan dari Soal 1'),
              ),
            ],
          ),
        ),
      );
    }

    final selectedIds = _selectedChips.map((c) => c.id).toSet();
    final isLastQuestion = _quizIndex + 1 == widget.quizzes.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Nomor Soal & Tombol Petunjuk
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Latihan Susun Kata ${_quizIndex + 1} / ${widget.quizzes.length}',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _showHint = !_showHint),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 16,
                    color: colorScheme.tertiary,
                  ),
                  label: Text(
                    'Petunjuk',
                    style: TextStyle(color: colorScheme.tertiary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_quizIndex + 1) / widget.quizzes.length,
                minHeight: 5,
              ),
            ),
            const SizedBox(height: 18),

            // Kalimat Bahasa Indonesia yang Harus Diterjemahkan
            Text(
              'Susun dalam bahasa Inggris:',
              style: textTheme.bodyMedium?.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              '"${_currentQuiz.promptId}"',
              style: textTheme.titleMedium?.copyWith(fontSize: 17),
            ),
            const SizedBox(height: 16),

            // Area Kotak Susunan Jawaban Pengguna
            Container(
              constraints: const BoxConstraints(minHeight: 74),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _status == _CheckStatus.correct
                      ? colorScheme.secondary
                      : _status == _CheckStatus.incorrect
                          ? const Color(0xFFC04A3E)
                          : colorScheme.primary.withValues(alpha: 0.25),
                  width: 1.4,
                ),
              ),
              child: _selectedChips.isEmpty
                  ? Center(
                      child: Text(
                        'Ketuk keping kata di bawah secara berurutan...',
                        style: textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final chip in _selectedChips)
                          InputChip(
                            label: Text(
                              chip.text,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () => _removeChip(chip),
                            onDeleted: _status == _CheckStatus.correct
                                ? null
                                : () => _removeChip(chip),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
            ),

            if (_selectedChips.isNotEmpty && _status != _CheckStatus.correct)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _resetSelection,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(Icons.restart_alt_rounded, size: 16),
                  label: const Text('Kosongkan'),
                ),
              )
            else
              const SizedBox(height: 14),

            // Bank Keping Kata Acak (Posisi tetap stabil saat dipilih)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final chip in _bankChips)
                  ActionChip(
                    label: Text(chip.text),
                    onPressed: selectedIds.contains(chip.id)
                        ? null
                        : () => _selectChip(chip),
                  ),
              ],
            ),

            // Kotak Petunjuk (Hint)
            if (_showHint) ...[
              const SizedBox(height: 16),
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
                      Icons.info_outline_rounded,
                      size: 18,
                      color: colorScheme.tertiary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _currentQuiz.hint,
                        style: textTheme.bodyMedium?.copyWith(
                          color: textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Feedback Benar / Belum Tepat
            if (_status == _CheckStatus.incorrect) ...[
              const SizedBox(height: 12),
              const Text(
                'Susunan belum tepat. Ketuk kata di kotak atas untuk memperbaiki urutan, lalu periksa lagi.',
                style: TextStyle(
                  color: Color(0xFFC04A3E),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            if (_status == _CheckStatus.correct) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: colorScheme.secondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tepat sekali! "${_currentQuiz.targetSentence}"',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Dengar lambat (0.75x)',
                      onPressed: () => widget.onSpeak(
                        _currentQuiz.targetSentence,
                        SpeechSpeed.slow,
                      ),
                      icon: Icon(
                        Icons.speed_rounded,
                        size: 20,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 18),

            // Tombol Aksi Utama
            if (_status == _CheckStatus.correct)
              FilledButton.icon(
                onPressed: _nextOrFinish,
                icon: Icon(
                  isLastQuestion
                      ? Icons.task_alt_rounded
                      : Icons.arrow_forward_rounded,
                ),
                label: Text(
                  isLastQuestion
                      ? (widget.isLessonCompleted
                          ? 'Selesai Latihan'
                          : 'Selesaikan Materi (+2 Menit)')
                      : 'Lanjut Soal Berikutnya',
                ),
              )
            else
              FilledButton(
                onPressed: _selectedChips.isEmpty ? null : _checkAnswer,
                child: const Text('Periksa Susunan'),
              ),
          ],
        ),
      ),
    );
  }
}
