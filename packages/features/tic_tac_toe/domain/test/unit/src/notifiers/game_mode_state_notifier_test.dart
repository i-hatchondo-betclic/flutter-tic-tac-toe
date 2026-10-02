import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:tic_tac_toe_domain/src/entities/difficulty.dart';
import 'package:tic_tac_toe_domain/src/entities/game_mode.br.dart';
import 'package:tic_tac_toe_domain/src/entities/player.dart';
import 'package:tic_tac_toe_domain/src/notifiers/game_mode_state_notifier.br.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  group('choosing an opponent', () {
    test('a fresh app assumes two humans', () {
      expect(container.read(gameModeStateProvider), const GameMode.twoPlayers());
    });

    test('the choice sticks', () {
      const versusAi = GameMode.versusAi(aiPlayer: Player.player2, difficulty: Difficulty.standard);

      container.read(gameModeStateProvider.notifier).select(versusAi);

      expect(container.read(gameModeStateProvider), versusAi);
    });

    test('the machine plays its hardest unless told otherwise', () {
      container.read(gameModeStateProvider.notifier).select(
        const GameMode.versusAi(aiPlayer: Player.player2),
      );

      expect(
        container.read(gameModeStateProvider),
        // Spelling the default out is the point of the test.
        // ignore: avoid_redundant_argument_values
        const GameMode.versusAi(aiPlayer: Player.player2, difficulty: Difficulty.advanced),
      );
    });
  });
}
