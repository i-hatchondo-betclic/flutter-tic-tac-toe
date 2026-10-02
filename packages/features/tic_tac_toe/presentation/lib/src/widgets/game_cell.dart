import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe_presentation/src/providers_di.br.dart';
import 'package:tic_tac_toe_presentation/src/state/game_ui_state.br.dart';
import 'package:tic_tac_toe_presentation/src/widgets/player_mark.dart';

/// Corner rounding. A layout choice, so it sits with the widget rather than in
/// the theme — move it there if a brand should be able to square the tiles off.
const _cornerRadius = 12.0;

/// One square of the board.
///
/// A null [onTap] means the square cannot be played — an empty cell once the
/// game is over, or any cell on the machine's turn. The board decides that;
/// this widget only reflects it.
class GameCell extends ConsumerWidget {
  const GameCell({required this.cell, this.onTap, super.key});

  final CellUiState cell;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(ticTacToeThemeProvider);
    final mark = cell.mark;

    return Material(
      color: theme.cell,
      borderRadius: BorderRadius.circular(_cornerRadius),
      // Clip the ink splash to the rounded shape too, or it spills square.
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        // The mark carries its own label; an empty square has nothing to read
        // out, so name it by where it is.
        child: mark == null
            ? Semantics(
                label: 'Empty, row ${cell.position.row + 1}, column ${cell.position.col + 1}',
                child: const SizedBox.expand(),
              )
            : PlayerMark(player: mark, color: theme.markColor(mark)),
      ),
    );
  }
}
