import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tic_tac_toe_domain/src/behaviors/apply_move.dart';
import 'package:tic_tac_toe_domain/src/behaviors/evaluate_board.dart';
import 'package:tic_tac_toe_domain/src/behaviors/select_ai_move.dart';
import 'package:tic_tac_toe_domain/src/behaviors/switch_player.dart';
import 'package:tic_tac_toe_domain/src/entities/difficulty.dart';
import 'package:tic_tac_toe_domain/src/entities/game_board.br.dart';
import 'package:tic_tac_toe_domain/src/entities/game_mode.br.dart';
import 'package:tic_tac_toe_domain/src/entities/game_session.br.dart';
import 'package:tic_tac_toe_domain/src/entities/player.dart';
import 'package:tic_tac_toe_domain/src/entities/position.br.dart';
import 'package:tic_tac_toe_domain/src/notifiers/game_mode_state_notifier.br.dart';
import 'package:tic_tac_toe_domain/src/providers_di.br.dart';

part 'tic_tac_toe_state_notifier.br.g.dart';

@riverpod
final class TicTacToeStateNotifier extends _$TicTacToeStateNotifier {
  @override
  GameSession build() {
    final session = GameSession(
      board: GameBoard.create(3),
      mode: ref.watch(gameModeStateProvider),
      currentPlayer: Player.player1,
    );

    if (session.mode case VersusAi(:final difficulty) when session.isAiMove) {
      final aiPos = _machineMove(session, difficulty);
      if (aiPos != null) return _moveInternal(session, aiPos);
    }

    return session;
  }

  void play(Position pos) {
    if (state.status == null && state.isAiMove) {
      throw Exception('This is AI turn');
    }

    _applyMoveInternal(pos);

    if (state.mode case VersusAi(:final difficulty) when state.isAiMove && state.status == null) {
      final aiPos = _machineMove(state, difficulty);
      if (aiPos != null) _applyMoveInternal(aiPos);
    }
  }

  /// Abandons the current game and deals a fresh board.
  // `invalidateSelf` rather than `state = build()`: build() calls ref.watch,
  // which only belongs in the build phase. Letting the framework rebuild
  // re-establishes the dependency on the mode instead of re-registering it.
  void reset() => ref.invalidateSelf();

  void _applyMoveInternal(Position pos) {
    state = _moveInternal(state, pos);
  }

  GameSession _moveInternal(GameSession session, Position pos) {
    if (session.status != null) {
      return session; // Game over
    }

    final board = applyMove(board: session.board, pos: pos, player: session.currentPlayer);
    return session.copyWith(
      board: board,
      currentPlayer: switchPlayer(session.currentPlayer),
      status: evaluateBoard(board, pos, session.currentPlayer),
    );
  }

  Position? _machineMove(GameSession session, Difficulty difficulty) => selectAiMove(
    board: session.board,
    player: session.currentPlayer,
    difficulty: difficulty,
    random: ref.read(randomProvider),
  );
}
