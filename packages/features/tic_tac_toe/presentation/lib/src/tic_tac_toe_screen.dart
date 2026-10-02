import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe_domain/tic_tac_toe_domain.dart';
import 'package:tic_tac_toe_presentation/src/providers_di.br.dart';
import 'package:tic_tac_toe_presentation/src/providers_internal.br.dart';
import 'package:tic_tac_toe_presentation/src/widgets/game_board_view.dart';

/// The board, who is to play, and a way to start over. The opponent is chosen
/// on the way in, so there is nothing to pick here.
class TicTacToeScreen extends ConsumerWidget {
  const TicTacToeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(ticTacToeThemeProvider);
    final uiState = ref.watch(gameUiStateProvider);

    final status = Text(uiState.statusLabel, style: theme.statusStyle);
    final startOver = TextButton(
      // Nothing to start over on an untouched board.
      onPressed: uiState.canReset ? () => ref.read(resetProvider)() : null,
      child: const Text('New game'),
    );

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(backgroundColor: theme.background, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          // Measured rather than asked of the device: what matters is whether
          // the space is wider than it is tall, which is also true of a split
          // screen or a resized window.
          child: LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth > constraints.maxHeight
                ? _WideLayout(status: status, startOver: startOver)
                : _TallLayout(status: status, startOver: startOver),
          ),
        ),
      ),
    );
  }
}

/// Portrait: label above the board, button below.
class _TallLayout extends StatelessWidget {
  const _TallLayout({required this.status, required this.startOver});

  final Widget status;
  final Widget startOver;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 28,
      children: [
        status,
        // The board is square and sizes itself from whichever side is shorter,
        // so handing it the leftover height keeps it on screen.
        const Expanded(child: Center(child: GameBoardView())),
        startOver,
      ],
    );
  }
}

/// How far the label and button sit from the top and bottom edges.
const _edgeInset = 20.0;

/// Landscape: the board beside its label and button, since height is the scarce
/// dimension and stacking would squeeze the board to nothing.
class _WideLayout extends StatelessWidget {
  const _WideLayout({required this.status, required this.startOver});

  final Widget status;
  final Widget startOver;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 28,
      children: [
        Expanded(
          // Centred within its half rather than pinned left, so the text block
          // and the board read as a pair near the middle instead of one pushed
          // into each corner. The inset keeps the label and the button off the
          // top and bottom edges that `spaceBetween` would otherwise flush them
          // against.
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: _edgeInset),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [status, startOver],
            ),
          ),
        ),
        const Expanded(child: Center(child: GameBoardView())),
      ],
    );
  }
}
