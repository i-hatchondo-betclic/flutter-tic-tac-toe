import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tic_tac_toe_domain/tic_tac_toe_domain.dart';

part 'tic_tac_toe_theme.br.freezed.dart';

/// Colours and type for the board.
///
/// Layout — cell size, spacing, stroke width — belongs to the widgets; this
/// carries only what a brand would want to change.
@freezed
abstract class TicTacToeTheme with _$TicTacToeTheme {
  const factory TicTacToeTheme({
    required Color background,
    required Color cell,
    required Color player1Mark,
    required Color player2Mark,
    required Color winningLine,
    required TextStyle statusStyle,
  }) = _TicTacToeTheme;

  /// Freezed only generates `extends` — and so inherits [markColor] — when the
  /// class declares a private constructor.
  const TicTacToeTheme._();

  /// The colour a given side's mark is drawn in.
  Color markColor(Player player) => switch (player) {
    Player.player1 => player1Mark,
    Player.player2 => player2Mark,
  };
}
