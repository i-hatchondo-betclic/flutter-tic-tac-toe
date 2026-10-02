import 'package:tic_tac_toe_domain/src/entities/game_board.br.dart';
import 'package:tic_tac_toe_domain/src/entities/position.br.dart';

/// Every cell still free, in row-major order.
List<Position> listOpenCells(GameBoard board) {
  final cells = <Position>[];
  for (var col = 0; col < board.size; col++) {
    for (var row = 0; row < board.size; row++) {
      if (board.cells[col][row] == 0) {
        cells.add(Position(col: col, row: row));
      }
    }
  }

  return cells;
}
