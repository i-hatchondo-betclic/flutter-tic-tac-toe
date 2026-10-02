import 'package:test/test.dart';
import 'package:tic_tac_toe_domain/src/behaviors/apply_move.dart';
import 'package:tic_tac_toe_domain/src/behaviors/evaluate_board.dart';
import 'package:tic_tac_toe_domain/src/behaviors/list_open_cells.dart';
import 'package:tic_tac_toe_domain/src/behaviors/select_best_move.dart';
import 'package:tic_tac_toe_domain/src/behaviors/switch_player.dart';
import 'package:tic_tac_toe_domain/src/entities/board_status.dart';
import 'package:tic_tac_toe_domain/src/entities/game_board.br.dart';
import 'package:tic_tac_toe_domain/src/entities/player.dart';
import 'package:tic_tac_toe_domain/src/entities/position.br.dart';

/// Replays [moves] onto a fresh board, so every fixture is a position the game
/// could actually reach.
GameBoard _boardFrom(List<(Position, Player)> moves) =>
    moves.fold(GameBoard.create(3), (board, move) => applyMove(board: board, pos: move.$1, player: move.$2));

/// Walks **every** game the opponent could produce against the machine, calling
/// [onGameOver] at each leaf.
///
/// Exhaustive rather than sampled: the machine's reply is deterministic, so the
/// only branching is the opponent's, and the whole tree is a few hundred games.
void _playEveryLine({
  required GameBoard board,
  required Player toMove,
  required Player machine,
  required void Function(BoardStatus outcome) onGameOver,
}) {
  final moves = toMove == machine
      ? [selectBestMove(board: board, player: machine)].nonNulls
      : listOpenCells(board);

  for (final move in moves) {
    final next = applyMove(board: board, pos: move, player: toMove);
    final status = evaluateBoard(next, move, toMove);

    if (status != null) {
      onGameOver(status);
      continue;
    }

    _playEveryLine(board: next, toMove: switchPlayer(toMove), machine: machine, onGameOver: onGameOver);
  }
}

List<BoardStatus> _everyOutcomeAgainst(Player machine) {
  final outcomes = <BoardStatus>[];
  _playEveryLine(
    board: GameBoard.create(3),
    toMove: Player.player1,
    machine: machine,
    onGameOver: outcomes.add,
  );
  return outcomes;
}

BoardStatus _lossFor(Player machine) =>
    machine == Player.player1 ? BoardStatus.player2Win : BoardStatus.player1Win;

void main() {
  group('an unbeatable opponent', () {
    test('never loses when it moves second, whatever is played against it', () {
      final outcomes = _everyOutcomeAgainst(Player.player2);

      expect(outcomes, isNotEmpty);
      expect(outcomes, everyElement(isNot(_lossFor(Player.player2))));
    });

    test('never loses when it moves first, whatever is played against it', () {
      final outcomes = _everyOutcomeAgainst(Player.player1);

      expect(outcomes, isNotEmpty);
      expect(outcomes, everyElement(isNot(_lossFor(Player.player1))));
    });

    test('does win sometimes — it is not just drawing everything', () {
      final outcomes = _everyOutcomeAgainst(Player.player1);

      expect(outcomes, contains(BoardStatus.player1Win));
    });
  });

  group('seeing one move ahead', () {
    test('completes its own line rather than blocking', () {
      // O holds the first column bar one square; X threatens the second. Taking
      // the win ends the game, so the block never matters.
      final board = _boardFrom([
        (const Position(col: 0, row: 0), Player.player2),
        (const Position(col: 1, row: 0), Player.player1),
        (const Position(col: 0, row: 1), Player.player2),
        (const Position(col: 1, row: 1), Player.player1),
      ]);

      expect(selectBestMove(board: board, player: Player.player2), const Position(col: 0, row: 2));
    });

    test('blocks a line it cannot answer with a win of its own', () {
      // X holds two of the first column; O has a lone centre and nothing to win.
      final board = _boardFrom([
        (const Position(col: 0, row: 0), Player.player1),
        (const Position(col: 1, row: 1), Player.player2),
        (const Position(col: 0, row: 1), Player.player1),
      ]);

      expect(selectBestMove(board: board, player: Player.player2), const Position(col: 0, row: 2));
    });
  });
}
