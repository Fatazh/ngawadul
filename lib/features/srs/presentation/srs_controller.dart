import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';
import '../data/srs_repository.dart';
import '../domain/srs_calculator.dart';

/// Provider untuk SrsRepository.
final srsRepositoryProvider = Provider<SrsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SrsRepository(db);
});

/// State imutabel untuk sesi belajar Flashcard SRS.
class SrsSessionState {
  const SrsSessionState({
    this.queue = const [],
    this.currentIndex = 0,
    this.isAnswerRevealed = false,
    this.levelFilter = 'ALL',
    this.completedCount = 0,
    this.isLoading = true,
    this.errorMessage,
  });

  final List<VocabWithProgress> queue;
  final int currentIndex;
  final bool isAnswerRevealed;
  final String levelFilter;
  final int completedCount;
  final bool isLoading;
  final String? errorMessage;

  bool get isSessionFinished => !isLoading && currentIndex >= queue.length;

  VocabWithProgress? get currentCard =>
      (currentIndex >= 0 && currentIndex < queue.length)
          ? queue[currentIndex]
          : null;

  double get progressFraction {
    if (queue.isEmpty) return 1.0;
    return (currentIndex / queue.length).clamp(0.0, 1.0);
  }

  /// Estimasi interval waktu di atas tombol Lupa / Susah / Ingat / Mudah.
  Map<ReviewRating, String> get currentIntervalPreviews {
    final card = currentCard;
    final now = DateTime.now();
    if (card == null) return const {};

    final existing = card.progress;
    final state = existing != null
        ? SrsCardState(
            easeFactor: existing.easeFactor,
            intervalDays: existing.intervalDays,
            repetitions: existing.repetitions,
            status: existing.status,
            nextReviewAtMs: existing.nextReviewAt,
            lastReviewedAtMs: existing.lastReviewedAt,
          )
        : SrsCardState(nextReviewAtMs: now.millisecondsSinceEpoch);

    return SrsCalculator.previewNextIntervals(state, referenceTime: now);
  }

  SrsSessionState copyWith({
    List<VocabWithProgress>? queue,
    int? currentIndex,
    bool? isAnswerRevealed,
    String? levelFilter,
    int? completedCount,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SrsSessionState(
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      isAnswerRevealed: isAnswerRevealed ?? this.isAnswerRevealed,
      levelFilter: levelFilter ?? this.levelFilter,
      completedCount: completedCount ?? this.completedCount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class SrsSessionController extends StateNotifier<SrsSessionState> {
  SrsSessionController(this._ref) : super(const SrsSessionState()) {
    loadSession();
  }

  final Ref _ref;

  Future<void> loadSession({
    String? levelFilter,
    int newWordsLimit = 5,
  }) async {
    final chosenFilter = levelFilter ?? state.levelFilter;
    state = state.copyWith(
      isLoading: true,
      levelFilter: chosenFilter,
      isAnswerRevealed: false,
      errorMessage: null,
    );

    try {
      await _ref.read(databaseSeedFutureProvider.future);
      final repo = _ref.read(srsRepositoryProvider);
      final cards = await repo.buildStudySessionQueue(
        levelFilter: chosenFilter,
        newWordsLimit: newWordsLimit,
      );

      state = state.copyWith(
        queue: cards,
        currentIndex: 0,
        isAnswerRevealed: false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat sesi hafalan: $e',
      );
    }
  }

  /// Membalik kartu untuk melihat arti, contoh terjemahan, dan jembatan keledai.
  void revealAnswer() {
    if (state.currentCard == null || state.isAnswerRevealed) return;
    state = state.copyWith(isAnswerRevealed: true);
  }

  /// Menilai kartu saat ini dan berpindah ke kartu berikutnya.
  /// Jika user menekan 'Lupa' (Again), kartu juga ditaruh kembali di ujung antrean sesi ini
  /// supaya kata tersebut benar-benar dikuasai sebelum sesi berakhir.
  Future<void> rateCurrentCard(ReviewRating rating) async {
    final card = state.currentCard;
    if (card == null) return;

    final repo = _ref.read(srsRepositoryProvider);
    final nextSrs = await repo.submitReview(card: card, rating: rating);

    final updatedQueue = List<VocabWithProgress>.from(state.queue);
    if (rating == ReviewRating.again) {
      final refreshedProgress = SrsProgressEntry(
        id: card.progress?.id ?? 0,
        vocabId: card.vocab.id,
        easeFactor: nextSrs.easeFactor,
        intervalDays: nextSrs.intervalDays,
        repetitions: nextSrs.repetitions,
        status: nextSrs.status,
        nextReviewAt: nextSrs.nextReviewAtMs,
        lastReviewedAt: nextSrs.lastReviewedAtMs,
      );
      updatedQueue.add(
        VocabWithProgress(
          vocab: card.vocab,
          progress: refreshedProgress,
        ),
      );
    }

    state = state.copyWith(
      queue: updatedQueue,
      currentIndex: state.currentIndex + 1,
      isAnswerRevealed: false,
      completedCount: state.completedCount + 1,
    );

    // Segarkan ringkasan statistik di Beranda
    _ref.invalidate(learningSummaryProvider);
  }

  /// Memuat tambahan 5 kata baru ketika sesi harian sudah selesai tapi user masih ingin lanjut.
  Future<void> loadExtraNewWords() async {
    await loadSession(
      levelFilter: state.levelFilter,
      newWordsLimit: 5,
    );
  }

  /// Menyimpan perubahan jembatan keledai (mnemonic) untuk kartu yang sedang dibuka.
  Future<void> updateCurrentCardMnemonic(String? note) async {
    final card = state.currentCard;
    if (card == null) return;

    final repo = _ref.read(srsRepositoryProvider);
    final updatedVocab = await repo.saveMnemonic(
      vocabId: card.vocab.id,
      mnemonicNote: note,
    );
    if (updatedVocab == null) return;

    final updatedQueue = List<VocabWithProgress>.from(state.queue);
    updatedQueue[state.currentIndex] = VocabWithProgress(
      vocab: updatedVocab,
      progress: card.progress,
    );

    state = state.copyWith(queue: updatedQueue);
  }
}

final srsSessionProvider =
    StateNotifierProvider<SrsSessionController, SrsSessionState>((ref) {
  return SrsSessionController(ref);
});
