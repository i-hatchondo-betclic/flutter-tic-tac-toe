import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_domain/tic_tac_toe_domain.dart';
import 'package:tic_tac_toe_presentation/src/state/game_ui_state.br.dart';

/// A board with [marks] written straight onto it.
///
/// `toUiState` reads only the squares and the move count, never the line sums,
/// so there is nothing to keep in step here — and `applyMove` is domain-internal
/// anyway, which is the boundary working as intended.
GameBoard _board(List<(Position, Player)> marks) {
  var cells = GameBoard.create(3).cells;
  for (final (pos, player) in marks) {
    final value = player == Player.player1 ? 1 : -1;
    cells = cells.replace(pos.col, cells[pos.col].replace(pos.row, value));
  }

  return GameBoard.create(3).copyWith(cells: cells, moveCount: marks.length);
}

GameSession _session({
  List<(Position, Player)> moves = const [],
  Player currentPlayer = Player.player1,
  GameMode mode = const GameMode.twoPlayers(),
  BoardStatus? status,
}) => GameSession(
  board: _board(moves),
  currentPlayer: currentPlayer,
  mode: mode,
  status: status,
);

void main() {
  group('laying the board out for a grid', () {
    test('it is three rows of three', () {
      final ui = _session().toUiState();

      expect(ui.cells, hasLength(3));
      expect(ui.cells.every((row) => row.length == 3), isTrue);
    });

    test('a mark in the first column, third row lands in the third row, first column', () {
      // The board stores [col][row]; a grid renders [row][col]. If that flip is
      // ever dropped the screen still looks like a plausible game, so this is
      // the assertion that catches it.
      final ui = _session(moves: [(const Position(col: 0, row: 2), Player.player1)]).toUiState();

      expect(ui.cells[2][0].mark, Player.player1);
      expect(ui.cells[0][2].mark, isNull);
    });

    test('each square still knows where it came from', () {
      final ui = _session().toUiState();

      expect(ui.cells[2][0].position, const Position(col: 0, row: 2));
      expect(ui.cells[0][2].position, const Position(col: 2, row: 0));
    });

    test('both sides are read off the board, and empty squares stay empty', () {
      final ui = _session(
        moves: [
          (const Position(col: 0, row: 0), Player.player1),
          (const Position(col: 1, row: 0), Player.player2),
        ],
      ).toUiState();

      expect(ui.cells[0][0].mark, Player.player1);
      expect(ui.cells[0][1].mark, Player.player2);
      expect(ui.cells[2][2].isEmpty, isTrue);
    });
  });

  group('telling the player where things stand', () {
    test('sides are written X and O', () {
      expect(Player.player1.glyph, 'X');
      expect(Player.player2.glyph, 'O');
    });

    test('a running game names whose turn it is', () {
      expect(_session(currentPlayer: Player.player2).toUiState().statusLabel, 'O to play');
    });

    test('a won game names the winner', () {
      expect(_session(status: BoardStatus.player1Win).toUiState().statusLabel, 'X wins');
      expect(_session(status: BoardStatus.player2Win).toUiState().statusLabel, 'O wins');
    });

    test('a drawn game says so', () {
      expect(_session(status: BoardStatus.draw).toUiState().statusLabel, 'Draw');
    });
  });

  group('deciding what can be tapped', () {
    test('an empty square of a running game is playable', () {
      final ui = _session().toUiState();

      expect(ui.isInteractive, isTrue);
      expect(ui.canPlay(ui.cells[1][1]), isTrue);
    });

    test('an occupied square is not', () {
      final ui = _session(moves: [(const Position(col: 1, row: 1), Player.player1)]).toUiState();

      expect(ui.canPlay(ui.cells[1][1]), isFalse);
    });

    test('a finished game takes no more moves, even on empty squares', () {
      final ui = _session(status: BoardStatus.draw).toUiState();

      expect(ui.isInteractive, isFalse);
      expect(ui.canPlay(ui.cells[0][0]), isFalse);
    });

    test('the board is closed while it is the machine turn', () {
      final ui = _session(
        mode: const GameMode.versusAi(aiPlayer: Player.player2),
        currentPlayer: Player.player2,
      ).toUiState();

      expect(ui.isInteractive, isFalse);
    });
  });

  group('offering a new game', () {
    test('there is nothing to start over on an untouched board', () {
      expect(_session().toUiState().canReset, isFalse);
    });

    test('once a mark is down there is', () {
      expect(
        _session(moves: [(const Position(col: 0, row: 0), Player.player1)]).toUiState().canReset,
        isTrue,
      );
    });
  });
}
