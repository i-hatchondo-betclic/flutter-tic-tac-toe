import 'package:test/test.dart';
import 'package:tic_tac_toe_domain/src/behaviors/apply_move.dart';
import 'package:tic_tac_toe_domain/src/behaviors/list_open_cells.dart';
import 'package:tic_tac_toe_domain/src/entities/game_board.br.dart';
import 'package:tic_tac_toe_domain/src/entities/player.dart';
import 'package:tic_tac_toe_domain/src/entities/position.br.dart';

void main() {
  group('choosing where to play', () {
    test('every cell of a fresh board is available', () {
      expect(listOpenCells(GameBoard.create(3)), hasLength(9));
    });

    test('a played cell is no longer offered', () {
      const played = Position(col: 1, row: 2);
      final board = applyMove(board: GameBoard.create(3), pos: played, player: Player.player1);

      final open = listOpenCells(board);

      expect(open, hasLength(8));
      expect(open, isNot(contains(played)));
    });

    test('a full board offers nothing', () {
      var board = GameBoard.create(3);
      for (final pos in listOpenCells(board)) {
        board = applyMove(board: board, pos: pos, player: Player.player1);
      }

      expect(listOpenCells(board), isEmpty);
    });
  });
}
