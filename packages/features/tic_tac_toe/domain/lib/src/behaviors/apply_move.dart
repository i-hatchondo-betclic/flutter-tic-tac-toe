import 'package:tic_tac_toe_domain/src/entities/game_board.br.dart';
import 'package:tic_tac_toe_domain/src/entities/player.dart';
import 'package:tic_tac_toe_domain/src/entities/position.br.dart';

/// Returns a new board with [player]'s mark at [pos].
///
/// Throws a [RangeError] if [pos] is off the board, and an [Exception] if the
/// cell is taken — callers pick from `listOpenCells` rather than guessing.
GameBoard applyMove({
  required GameBoard board,
  required Position pos,
  required Player player,
}) {
  _checkBounds(board, pos);

  if (!_isPositionEmpty(board, pos)) {
    throw Exception('invalid position $pos is already occupied');
  }

  final playerValue = _playerValue(player);
  final onDiag = pos.col == pos.row;
  final onAntiDiag = pos.col + pos.row == board.size - 1;

  return board.copyWith(
    cells: board.cells.replace(pos.col, board.cells[pos.col].replace(pos.row, playerValue)),
    cols: board.cols.replace(pos.col, board.cols[pos.col] + playerValue),
    rows: board.rows.replace(pos.row, board.rows[pos.row] + playerValue),
    diag: onDiag ? board.diag + playerValue : board.diag,
    antiDiag: onAntiDiag ? board.antiDiag + playerValue : board.antiDiag,
    moveCount: board.moveCount + 1,
  );
}

void _checkBounds(GameBoard board, Position pos) {
  RangeError.checkValueInInterval(pos.col, 0, board.size - 1, 'col');
  RangeError.checkValueInInterval(pos.row, 0, board.size - 1, 'row');
}

bool _isPositionEmpty(GameBoard board, Position pos) {
  return board.cells[pos.col][pos.row] == 0;
}

int _playerValue(Player player) {
  return switch (player) {
    Player.player1 => 1,
    Player.player2 => -1,
  };
}
