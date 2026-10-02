import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tic_tac_toe_domain/tic_tac_toe_domain.dart';

part 'game_ui_state.br.freezed.dart';

/// How a side is written on screen. A string, not a shape: it also labels the
/// status line and is what a screen reader announces for a drawn mark.
extension PlayerGlyph on Player {
  String get glyph => switch (this) {
    Player.player1 => 'X',
    Player.player2 => 'O',
  };
}

/// One square, ready to render.
@freezed
abstract class CellUiState with _$CellUiState {
  const factory CellUiState({
    required Position position,
    Player? mark,
  }) = _CellUiState;

  const CellUiState._();

  bool get isEmpty => mark == null;
}

/// The screen's whole state.
///
/// [cells] is indexed `[row][col]`, the order a `Column` of `Row`s renders in.
/// The board stores `cells[col][row]`, so the transposition happens here, once,
/// rather than in every widget.
@freezed
abstract class GameUiState with _$GameUiState {
  const factory GameUiState({
    required String statusLabel,
    required IList<IList<CellUiState>> cells,
    required bool isInteractive,
    required bool canReset,
  }) = _GameUiState;

  const GameUiState._();

  /// Whether tapping [cell] would do anything.
  ///
  /// Named for the question the widget asks, not for how it is answered: today
  /// [isInteractive] is only ever false once the game has ended, but it also
  /// covers the machine's turn the day its reply stops being instantaneous.
  bool canPlay(CellUiState cell) => isInteractive && cell.isEmpty;
}

/// Maps the game onto the screen. Pure — no providers, no widgets.
extension GameSessionUiState on GameSession {
  GameUiState toUiState() => GameUiState(
    statusLabel: _statusLabel,
    isInteractive: status == null && !isAiMove,
    canReset: board.moveCount > 0,
    cells: IList([
      for (var row = 0; row < board.size; row++) IList([for (var col = 0; col < board.size; col++) _cellAt(col, row)]),
    ]),
  );

  String get _statusLabel => switch (status) {
    null => '${currentPlayer.glyph} to play',
    BoardStatus.player1Win => '${Player.player1.glyph} wins',
    BoardStatus.player2Win => '${Player.player2.glyph} wins',
    BoardStatus.draw => 'Draw',
  };

  CellUiState _cellAt(int col, int row) => CellUiState(
    position: Position(col: col, row: row),
    mark: switch (board.cells[col][row]) {
      1 => Player.player1,
      -1 => Player.player2,
      _ => null,
    },
  );
}
