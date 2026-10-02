import 'package:test/test.dart';
import 'package:tic_tac_toe_domain/src/behaviors/apply_move.dart';
import 'package:tic_tac_toe_domain/src/entities/game_board.br.dart';
import 'package:tic_tac_toe_domain/src/entities/player.dart';
import 'package:tic_tac_toe_domain/src/entities/position.br.dart';

void main() {
  group('placing a mark', () {
    test("the cell carries the mover's mark", () {
      const pos = Position(col: 1, row: 2);

      final board = applyMove(board: GameBoard.create(3), pos: pos, player: Player.player1);

      expect(board.cells[1][2], 1);
    });

    test('player two is recorded as the opposite of player one', () {
      const pos = Position(col: 1, row: 2);

      final board = applyMove(board: GameBoard.create(3), pos: pos, player: Player.player2);

      expect(board.cells[1][2], -1);
    });

    test('the board that was played on is left untouched', () {
      final before = GameBoard.create(3);

      applyMove(board: before, pos: const Position(col: 0, row: 0), player: Player.player1);

      expect(before.cells[0][0], 0);
      expect(before.moveCount, 0);
      expect(before.cols[0], 0);
    });

    test('each move is counted', () {
      var board = GameBoard.create(3);

      board = applyMove(board: board, pos: const Position(col: 0, row: 0), player: Player.player1);
      board = applyMove(board: board, pos: const Position(col: 1, row: 0), player: Player.player2);

      expect(board.moveCount, 2);
    });
  });

  group('keeping the line sums in step', () {
    test('a move off both diagonals only moves its own column and row', () {
      const pos = Position(col: 0, row: 1); // col != row, col + row != 2

      final board = applyMove(board: GameBoard.create(3), pos: pos, player: Player.player1);

      expect(board.cols[0], 1);
      expect(board.rows[1], 1);
      expect(board.diag, 0);
      expect(board.antiDiag, 0);
    });

    test('a move on the diagonal moves the diagonal too', () {
      final board = applyMove(
        board: GameBoard.create(3),
        pos: const Position(col: 1, row: 1),
        player: Player.player1,
      );

      expect(board.diag, 1);
    });

    test('a move on the anti-diagonal moves the anti-diagonal too', () {
      final board = applyMove(
        board: GameBoard.create(3),
        pos: const Position(col: 0, row: 2),
        player: Player.player1,
      );

      expect(board.antiDiag, 1);
      expect(board.diag, 0);
    });

    test('the centre sits on both diagonals at once', () {
      final board = applyMove(
        board: GameBoard.create(3),
        pos: const Position(col: 1, row: 1),
        player: Player.player2,
      );

      expect(board.diag, -1);
      expect(board.antiDiag, -1);
    });
  });

  group('refusing an illegal move', () {
    test('a cell outside the board is rejected', () {
      expect(
        () => applyMove(board: GameBoard.create(3), pos: const Position(col: 3, row: 0), player: Player.player1),
        throwsA(isA<RangeError>()),
      );
    });

    test('a negative coordinate is rejected', () {
      expect(
        () => applyMove(board: GameBoard.create(3), pos: const Position(col: 0, row: -1), player: Player.player1),
        throwsA(isA<RangeError>()),
      );
    });

    test('an occupied cell is rejected', () {
      const pos = Position(col: 1, row: 1);
      final board = applyMove(board: GameBoard.create(3), pos: pos, player: Player.player1);

      expect(
        () => applyMove(board: board, pos: pos, player: Player.player2),
        throwsA(isA<Exception>()),
      );
    });
  });
}
