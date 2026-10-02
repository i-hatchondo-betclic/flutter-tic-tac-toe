import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tic_tac_toe_domain/src/entities/board_status.dart';
import 'package:tic_tac_toe_domain/src/entities/game_board.br.dart';
import 'package:tic_tac_toe_domain/src/entities/game_mode.br.dart';
import 'package:tic_tac_toe_domain/src/entities/player.dart';

part 'game_session.br.freezed.dart';

@freezed
abstract class GameSession with _$GameSession {
  const factory GameSession({
    required GameBoard board,
    required Player currentPlayer,
    required GameMode mode,
    BoardStatus? status, // null while the game runs
  }) = _GameSession;

  /// Freezed only generates `extends` (and so inherits [isAiMove]) when the
  /// class declares a private constructor.
  const GameSession._();

  bool get isAiMove {
    if (mode case VersusAi(:final aiPlayer) when aiPlayer == currentPlayer) {
      return true;
    } else {
      return false;
    }
  }
}
