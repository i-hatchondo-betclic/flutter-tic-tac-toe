import 'package:tic_tac_toe_domain/src/entities/board_status.dart';
import 'package:tic_tac_toe_domain/src/entities/game_board.br.dart';
import 'package:tic_tac_toe_domain/src/entities/player.dart';
import 'package:tic_tac_toe_domain/src/entities/position.br.dart';

/// How the game stands after [player] played [pos]. `null` means still running.
///
/// The line sums make this O(1): a full line is `abs() == size`.
BoardStatus? evaluateBoard(GameBoard board, Position pos, Player player) {
  if (board.diag.abs() == board.size ||
      board.antiDiag.abs() == board.size ||
      board.cols[pos.col].abs() == board.size ||
      board.rows[pos.row].abs() == board.size) {
    return switch (player) {
      Player.player1 => BoardStatus.player1Win,
      Player.player2 => BoardStatus.player2Win,
    };
  } else if (board.moveCount >= board.size * board.size) {
    return BoardStatus.draw;
  } else {
    return null;
  }
}
