import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.br.freezed.dart';

/// A cell coordinate on the board. Bounds are validated by the behaviors that
/// consume it, not here — a Position is just a pair.
@freezed
abstract class Position with _$Position {
  const factory Position({required int col, required int row}) = _Position;
}
