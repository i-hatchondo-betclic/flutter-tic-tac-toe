import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_board.br.freezed.dart';

/// An immutable board position.
///
/// [cols], [rows], [diag] and [antiDiag] are running sums of the player values
/// (+1 / -1) placed on each line, so a win is `abs() == size` without rescanning
/// the grid. They are derived from [cells] and must be kept in step with it by
/// whichever behavior writes a move.
@freezed
abstract class GameBoard with _$GameBoard {
  const factory GameBoard({
    required int size,
    required IList<IList<int>> cells,
    required IList<int> cols,
    required IList<int> rows,
    required int diag,
    required int antiDiag,
    required int moveCount,
  }) = _GameBoard;

  factory GameBoard.create(int size) => GameBoard(
    size: size,
    cells: List.generate(size, (_) => List.filled(size, 0).lock).lock,
    cols: List.filled(size, 0).lock,
    rows: List.filled(size, 0).lock,
    diag: 0,
    antiDiag: 0,
    moveCount: 0,
  );
}
