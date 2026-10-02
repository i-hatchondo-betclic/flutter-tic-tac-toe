import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_tac_toe_domain/tic_tac_toe_domain.dart';
import 'package:tic_tac_toe_presentation/src/providers_di.br.dart';

/// Choose an opponent, then start.
///
/// The choice is stored straight away through `selectMode`, so this screen
/// holds no state of its own — the game notifier is already watching it.
class GameSetupScreen extends ConsumerWidget {
  const GameSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(ticTacToeThemeProvider);
    final mode = ref.watch(gameModeProvider);

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        // Centred when there is room, scrollable when there is not: the minimum
        // height makes the Center fill the viewport, and the scroll view takes
        // over once the controls outgrow it — as they do on a landscape phone.
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 28,
                    children: [
                      Text('Tic Tac Toe', style: theme.statusStyle),
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(value: false, label: Text('2 players')),
                          ButtonSegment(value: true, label: Text('vs machine')),
                        ],
                        selected: {mode is VersusAi},
                        onSelectionChanged: (selection) => ref.read(selectModeProvider)(
                          selection.first
                              ? const GameMode.versusAi(aiPlayer: Player.player2)
                              : const GameMode.twoPlayers(),
                        ),
                      ),
                      // Difficulty only exists when there is a machine to apply
                      // it to, which is why it lives on the mode rather than
                      // beside it.
                      if (mode case VersusAi(:final aiPlayer, :final difficulty))
                        SegmentedButton<Difficulty>(
                          segments: const [
                            ButtonSegment(value: Difficulty.standard, label: Text('standard')),
                            ButtonSegment(value: Difficulty.advanced, label: Text('advanced')),
                          ],
                          selected: {difficulty},
                          onSelectionChanged: (selection) => ref.read(selectModeProvider)(
                            GameMode.versusAi(aiPlayer: aiPlayer, difficulty: selection.first),
                          ),
                        ),
                      FilledButton(
                        onPressed: () => ref.read(ticTacToeRoutingProvider).onGameRequested(context: context),
                        child: const Text('Start'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
