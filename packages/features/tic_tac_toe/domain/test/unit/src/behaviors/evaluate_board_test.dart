import 'package:test/test.dart';
import 'package:tic_tac_toe_domain/src/behaviors/apply_move.dart';
import 'package:tic_tac_toe_domain/src/behaviors/evaluate_board.dart';
import 'package:tic_tac_toe_domain/src/entities/board_status.dart';
import 'package:tic_tac_toe_domain/src/entities/game_board.br.dart';
import 'package:tic_tac_toe_domain/src/entities/player.dart';
import 'package:tic_tac_toe_domain/src/entities/position.br.dart';

/// Replays [moves] onto a fresh board so every fixture is a position the game
/// could actually reach, rather than a hand-assembled set of counters.
GameBoard _boardFrom(List<(Position, Player)> moves) =>
    moves.fold(GameBoard.create(3), (board, move) => applyMove(board: board, pos: move.$1, player: move.$2));

/// The three cells of column [col].
List<Position> _column(int col) => [for (var row = 0; row < 3; row++) Position(col: col, row: row)];

/// The three cells of row [row].
List<Position> _row(int row) => [for (var col = 0; col < 3; col++) Position(col: col, row: row)];

BoardStatus? _outcomeOf(List<Position> line, Player player) {
  final board = _boardFrom([for (final pos in line) (pos, player)]);
  return evaluateBoard(board, line.last, player);
}

void main() {
  group('winning', () {
    for (var col = 0; col < 3; col++) {
      test('filling column $col wins it', () {
        expect(_outcomeOf(_column(col), Player.player1), BoardStatus.player1Win);
      });
    }

    for (var row = 0; row < 3; row++) {
      test('filling row $row wins it', () {
        expect(_outcomeOf(_row(row), Player.player1), BoardStatus.player1Win);
      });
    }

    test('filling the diagonal wins it', () {
      const diagonal = [Position(col: 0, row: 0), Position(col: 1, row: 1), Position(col: 2, row: 2)];
      expect(_outcomeOf(diagonal, Player.player1), BoardStatus.player1Win);
    });

    test('filling the anti-diagonal wins it', () {
      const antiDiagonal = [Position(col: 0, row: 2), Position(col: 1, row: 1), Position(col: 2, row: 0)];
      expect(_outcomeOf(antiDiagonal, Player.player1), BoardStatus.player1Win);
    });

    test('player two wins the same way player one does', () {
      expect(_outcomeOf(_row(0), Player.player2), BoardStatus.player2Win);
    });
  });

  group('not yet decided', () {
    test('two in a line is not a win', () {
      const opening = [Position(col: 0, row: 0), Position(col: 0, row: 1)];
      final board = _boardFrom([for (final pos in opening) (pos, Player.player1)]);

      expect(evaluateBoard(board, opening.last, Player.player1), isNull);
    });

    test('an empty board is still running', () {
      final board = GameBoard.create(3);

      expect(evaluateBoard(board, const Position(col: 0, row: 0), Player.player1), isNull);
    });
  });

  group('drawing', () {
    test('a full board with no line is a draw', () {
      // X O X
      // X O O
      // O X X   — the last mark played is X at (2, 2)
      final board = _boardFrom([
        (const Position(col: 1, row: 0), Player.player2),
        (const Position(col: 1, row: 1), Player.player2),
        (const Position(col: 2, row: 1), Player.player2),
        (const Position(col: 0, row: 2), Player.player2),
        (const Position(col: 0, row: 0), Player.player1),
        (const Position(col: 2, row: 0), Player.player1),
        (const Position(col: 0, row: 1), Player.player1),
        (const Position(col: 1, row: 2), Player.player1),
        (const Position(col: 2, row: 2), Player.player1),
      ]);

      expect(evaluateBoard(board, const Position(col: 2, row: 2), Player.player1), BoardStatus.draw);
    });
  });
}
