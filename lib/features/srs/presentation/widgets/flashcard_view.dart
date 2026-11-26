import 'package:material_ui/material_ui.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/services/tts_service.dart';

/// Kartu kosakata interaktif dengan tampilan konteks kalimat, audio 1.0x / 0.75x,
/// dan kotak Jembatan Keledai (Memory Hook) yang bisa diedit pengguna.
class FlashcardView extends StatelessWidget {
  const FlashcardView({
    super.key,
    required this.card,
    required this.isAnswerRevealed,
    required this.onSpeak,
    required this.onRevealTap,
    required this.onEditMnemonic,
  });

  final VocabWithProgress card;
  final bool isAnswerRevealed;
  final void Function(String text, SpeechSpeed speed) onSpeak;
  final VoidCallback onRevealTap;
  final VoidCallback onEditMnemonic;

  static String _categoryLabel(String raw) {
    switch (raw) {
      case 'work':
        return 'Kerja';
      case 'daily':
        return 'Harian';
      case 'travel':
        return 'Perjalanan';
      case 'social':
        return 'Sosial';
      case 'tech':
        return 'Teknologi';
      default:
        return raw;
    }
  }

  static String _statusLabel(String status) {
    switch (status) {
      case 'mastered':
        return 'Dikuasai';
      case 'learning':
        return 'Dipelajari';
      default:
        return 'Kata Baru';
    }
  }

  @override
  Widget build(BuildContext context) {
    final vocab = card.vocab;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isAnswerRevealed ? null : onRevealTap,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Baris Badge Level, Kategori, dan Status
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _BadgePill(
                        label: vocab.level,
                        backgroundColor:
                            colorScheme.primary.withValues(alpha: 0.14),
                        textColor: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      _BadgePill(
                        label: _categoryLabel(vocab.category),
                        backgroundColor:
                            colorScheme.secondary.withValues(alpha: 0.14),
                        textColor: colorScheme.secondary,
                      ),
                    ],
                  ),
                  _BadgePill(
                    label: _statusLabel(card.effectiveStatus),
                    backgroundColor:
                        colorScheme.tertiary.withValues(alpha: 0.14),
                    textColor: colorScheme.tertiary,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Kata Utama + Kelas Kata + Fonetik
              Text(
                vocab.word,
                style: textTheme.headlineMedium?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                '${vocab.partOfSpeech}  •  ${vocab.phonetic}',
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Tombol Audio 1.0x Normal & 0.75x Lambat
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => onSpeak(vocab.word, SpeechSpeed.normal),
                    icon: const Icon(Icons.volume_up_rounded, size: 18),
                    label: const Text('1.0x Normal'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => onSpeak(vocab.word, SpeechSpeed.slow),
                    icon: const Icon(Icons.speed_rounded, size: 18),
                    label: const Text('0.75x Lambat'),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Kotak Konteks Kalimat Bahasa Inggris (Selalu tampil agar menebak dari konteks)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Contoh Konteks Nyata',
                            style: textTheme.labelLarge?.copyWith(
                              fontSize: 12,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Dengar kalimat (Normal)',
                          icon: Icon(
                            Icons.play_circle_outline_rounded,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                          onPressed: () =>
                              onSpeak(vocab.exampleEn, SpeechSpeed.normal),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Dengar kalimat (Lambat 0.75x)',
                          icon: Icon(
                            Icons.slow_motion_video_rounded,
                            size: 20,
                            color: colorScheme.secondary,
                          ),
                          onPressed: () =>
                              onSpeak(vocab.exampleEn, SpeechSpeed.slow),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"${vocab.exampleEn}"',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isAnswerRevealed) ...[
                      const SizedBox(height: 8),
                      Text(
                        vocab.exampleId,
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),

              // Bagian Jawaban (Arti Bahasa Indonesia + Jembatan Keledai)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: isAnswerRevealed
                    ? Padding(
                        key: const ValueKey('revealed'),
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Divider(height: 1),
                            const SizedBox(height: 18),
                            Text(
                              'Arti Bahasa Indonesia',
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              vocab.meaningId,
                              style: textTheme.titleLarge?.copyWith(
                                fontSize: 22,
                                color: colorScheme.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 18),

                            // Kotak Jembatan Keledai (Memory Hook)
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: colorScheme.tertiary
                                    .withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colorScheme.tertiary
                                      .withValues(alpha: 0.30),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.lightbulb_outline_rounded,
                                        size: 18,
                                        color: colorScheme.tertiary,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'Jembatan Keledai (Asosiasi Ingatan)',
                                          style: textTheme.labelLarge?.copyWith(
                                            fontSize: 13,
                                            color: colorScheme.tertiary,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: onEditMnemonic,
                                        style: TextButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                        ),
                                        child: const Text('Ubah'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    vocab.mnemonicNote ??
                                        'Ketuk "Ubah" untuk menulis asosiasi unik versimu sendiri agar kata ini mudah menempel.',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        key: const ValueKey('hidden'),
                        padding: const EdgeInsets.only(top: 24, bottom: 4),
                        child: Text(
                          'Tebak artinya dari kalimat di atas, lalu ketuk kartu atau tombol di bawah.',
                          style: textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgePill extends StatelessWidget {
  const _BadgePill({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
