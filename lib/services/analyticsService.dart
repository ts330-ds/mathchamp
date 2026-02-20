import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Centralized Firebase Analytics service.
/// All calls are fire-and-forget with error swallowing so analytics
/// failures never crash the app on Android or iOS.
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // ─── Internal safe wrapper ───────────────────────────────────────────────
  Future<void> _safe(Future<void> Function() fn) async {
    try {
      await fn();
    } catch (e, st) {
      // Never let analytics crash the app
      debugPrint('[Analytics] error: $e\n$st');
    }
  }

  // ── Screen tracking ──────────────────────────────────────────────────────

  Future<void> logScreen(String screenName) =>
      _safe(() => _analytics.logScreenView(screenName: screenName));

  // ── Splash ───────────────────────────────────────────────────────────────

  Future<void> logAppOpen() =>
      _safe(() => _analytics.logAppOpen());

  // ── Home ─────────────────────────────────────────────────────────────────

  /// User selected a quiz type from the home dropdown (e.g. Addition, Division)
  Future<void> logQuizTypeSelected(String quizType) =>
      _safe(() => _analytics.logEvent(
            name: 'quiz_type_selected',
            parameters: {'quiz_type': quizType},
          ));

  // ── CommonStartGameScreen ────────────────────────────────────────────────

  /// User pressed "Let's Go!" to start a single-player game
  Future<void> logQuizStarted({
    required String gameType,
    required int numberOfQuestions,
    required String difficulty,
  }) =>
      _safe(() => _analytics.logEvent(
            name: 'quiz_started',
            parameters: {
              'game_type': gameType,
              'num_questions': numberOfQuestions,
              'difficulty': difficulty,
            },
          ));

  /// User opened the 2-Player mode dialog
  Future<void> logTwoPlayerModeOpened(String gameType) =>
      _safe(() => _analytics.logEvent(
            name: 'two_player_mode_opened',
            parameters: {'game_type': gameType},
          ));

  /// User confirmed names and started a 2-Player game
  Future<void> logTwoPlayerGameStarted({
    required String gameType,
    required int numberOfQuestions,
    required String difficulty,
    required String player1Name,
    required String player2Name,
  }) =>
      _safe(() => _analytics.logEvent(
            name: 'two_player_game_started',
            parameters: {
              'game_type': gameType,
              'num_questions': numberOfQuestions,
              'difficulty': difficulty,
              // Do NOT log real player names to respect privacy
              'p1_length': player1Name.length,
              'p2_length': player2Name.length,
            },
          ));

  // ── QuestionScreen ────────────────────────────────────────────────────────

  /// User selected an answer option
  Future<void> logAnswerSelected({
    required bool isCorrect,
    required String gameType,
    required int questionIndex,
  }) =>
      _safe(() => _analytics.logEvent(
            name: 'answer_selected',
            parameters: {
              'is_correct': isCorrect ? 1 : 0,
              'game_type': gameType,
              'question_index': questionIndex,
            },
          ));

  /// Single-player quiz completed
  Future<void> logQuizCompleted({
    required String gameType,
    required int correctCount,
    required int wrongCount,
    required int totalQuestions,
    required int timeTakenSeconds,
  }) =>
      _safe(() => _analytics.logEvent(
            name: 'quiz_completed',
            parameters: {
              'game_type': gameType,
              'correct': correctCount,
              'wrong': wrongCount,
              'total': totalQuestions,
              'time_seconds': timeTakenSeconds,
              'accuracy_pct': totalQuestions > 0
                  ? (correctCount * 100 ~/ totalQuestions)
                  : 0,
            },
          ));

  /// User quit a quiz early
  Future<void> logQuizQuit({
    required String gameType,
    required int questionIndex,
    required int totalQuestions,
  }) =>
      _safe(() => _analytics.logEvent(
            name: 'quiz_quit',
            parameters: {
              'game_type': gameType,
              'quit_at_question': questionIndex,
              'total_questions': totalQuestions,
            },
          ));

  // ── Player 2 Screen ───────────────────────────────────────────────────────

  /// Two-player game completed
  Future<void> logTwoPlayerGameCompleted({
    required String player1Name,
    required String player2Name,
    required int p1Correct,
    required int p2Correct,
    required int totalQuestions,
    required int timeTakenSeconds,
    required String winner, // 'player1' / 'player2' / 'tie'
  }) =>
      _safe(() => _analytics.logEvent(
            name: 'two_player_game_completed',
            parameters: {
              'p1_correct': p1Correct,
              'p2_correct': p2Correct,
              'total': totalQuestions,
              'time_seconds': timeTakenSeconds,
              // 'winner' is either 'tie' or the name — log anonymised result
              'result': winner == 'tie'
                  ? 'tie'
                  : (winner == player1Name ? 'player1_wins' : 'player2_wins'),
            },
          ));

  /// User shared 2-player result
  Future<void> logTwoPlayerResultShared() =>
      _safe(() => _analytics.logShare(
            contentType: 'two_player_result',
            itemId: 'mathchamp_2player',
            method: 'share_plus',
          ));

  // ── Settings ──────────────────────────────────────────────────────────────

  /// Music toggle changed by user (not called on startup)
  Future<void> logMusicToggled(bool enabled) =>
      _safe(() => _analytics.logEvent(
            name: 'music_toggled',
            parameters: {'enabled': enabled ? 1 : 0},
          ));

  /// Default questions count changed in settings
  Future<void> logDefaultQuestionsChanged(int count) =>
      _safe(() => _analytics.logEvent(
            name: 'default_questions_changed',
            parameters: {'count': count},
          ));

  // ── Child Profiles ────────────────────────────────────────────────────────

  Future<void> logProfileCreated() =>
      _safe(() => _analytics.logEvent(name: 'profile_created'));

  Future<void> logProfileUpdated() =>
      _safe(() => _analytics.logEvent(name: 'profile_updated'));

  Future<void> logProfileDeleted() =>
      _safe(() => _analytics.logEvent(name: 'profile_deleted'));

  /// User switched active player profile on home screen dropdown
  Future<void> logProfileSwitched(String userName) =>
      _safe(() => _analytics.logEvent(
            name: 'profile_switched',
            // Log only name length — avoid storing PII
            parameters: {'name_length': userName.length},
          ));

}
