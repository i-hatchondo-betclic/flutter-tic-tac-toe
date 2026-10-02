import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe_domain/tic_tac_toe_domain.dart';
import 'package:tic_tac_toe_presentation/src/providers_internal.br.dart';
import 'package:tic_tac_toe_presentation/src/widgets/game_cell.dart';

/// Gap between tiles. A layout choice, so it lives with the widget rather than
/// in the theme.
const _tileGap = 10.0;

/// The board: a square grid of [GameCell]s over `cells[row][col]`.
///
/// Nothing is drawn between the tiles — the gaps simply let the page through,
/// so the separators are the background rather than lines painted on top of it.
class GameBoardView extends ConsumerWidget {
  const GameBoardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(gameUiStateProvider);

    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        spacing: _tileGap,
        children: [
          for (final row in uiState.cells)
            Expanded(
              child: Row(
                spacing: _tileGap,
                children: [
                  for (final cell in row)
                    Expanded(
                      child: GameCell(
                        cell: cell,
                        // `ref.read` inside the callback, so the move is sent
                        // with whatever is current when the square is tapped.
                        onTap: uiState.canPlay(cell) ? () => ref.read(playProvider)(cell.position) : null,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
