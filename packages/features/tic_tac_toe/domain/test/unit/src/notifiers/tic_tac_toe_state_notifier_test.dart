import 'dart:math';

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';
import 'package:tic_tac_toe_domain/src/entities/board_status.dart';
import 'package:tic_tac_toe_domain/src/entities/difficulty.dart';
import 'package:tic_tac_toe_domain/src/entities/game_mode.br.dart';
import 'package:tic_tac_toe_domain/src/entities/player.dart';
import 'package:tic_tac_toe_domain/src/entities/position.br.dart';
import 'package:tic_tac_toe_domain/src/notifiers/game_mode_state_notifier.br.dart';
import 'package:tic_tac_toe_domain/src/notifiers/tic_tac_toe_state_notifier.br.dart';
import 'package:tic_tac_toe_domain/src/providers.br.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  group('starting a game', () {
    test('a two-player game waits for a human', () {
      expect(container.read(ticTacToeStateProvider).board.moveCount, 0);
    });

    test('the machine opens when it takes the first turn', () {
      container.read(gameModeStateProvider.notifier).select(
        const GameMode.versusAi(aiPlayer: Player.player1),
      );

      expect(container.read(ticTacToeStateProvider).board.moveCount, 1);
    });
  });

  group('taking turns', () {
    test('the machine answers every human move', () {
      container.read(gameModeStateProvider.notifier).select(
        const GameMode.versusAi(aiPlayer: Player.player1),
      );
      // the machine has already opened
      expect(container.read(ticTacToeStateProvider).board.moveCount, 1);

      container.read(ticTacToeStateProvider.notifier).play(const Position(col: 1, row: 1));

      // one human mark plus the machine's reply, and the turn is the human's again
      final session = container.read(ticTacToeStateProvider);
      expect(session.board.moveCount, 3);
      expect(session.isAiMove, isFalse);
    });

    test('a move onto a taken cell is refused', () {
      container.read(ticTacToeStateProvider.notifier).play(const Position(col: 0, row: 0));

      expect(
        () => container.read(ticTacToeStateProvider.notifier).play(const Position(col: 0, row: 0)),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('starting over', () {
    test('reset keeps the chosen opponent', () {
      const versusAi = GameMode.versusAi(aiPlayer: Player.player2);
      container.read(gameModeStateProvider.notifier).select(versusAi);
      container.read(ticTacToeStateProvider.notifier).play(const Position(col: 0, row: 0));

      container.read(ticTacToeStateProvider.notifier).reset();

      final session = container.read(ticTacToeStateProvider);
      expect(session.mode, versusAi);
      expect(session.board.moveCount, 0);
    });
  });

  group('ending', () {
    test('a finished game ignores further moves', () {
      final play = container.read(ticTacToeStateProvider.notifier).play;
      // X takes the first column while O answers in the second.
      const opening = [
        Position(col: 0, row: 0),
        Position(col: 1, row: 0),
        Position(col: 0, row: 1),
        Position(col: 1, row: 1),
        Position(col: 0, row: 2),
      ];
      // `prefer_foreach` wants this shape and `cascade_invocations` objects to
      // it; the two rules disagree and the loop form fares no better.
      // ignore: cascade_invocations
      opening.forEach(play);

      expect(container.read(ticTacToeStateProvider).status, BoardStatus.player1Win);
      final afterWin = container.read(ticTacToeStateProvider);

      play(const Position(col: 2, row: 2));

      expect(container.read(ticTacToeStateProvider), afterWin);
    });
  });

  group('changing opponent', () {
    test('switching mode abandons the game in progress', () {
      container.read(ticTacToeStateProvider.notifier).play(const Position(col: 0, row: 0));
      expect(container.read(ticTacToeStateProvider).board.moveCount, 1);

      container.read(gameModeStateProvider.notifier).select(
        const GameMode.versusAi(aiPlayer: Player.player2),
      );

      // The game notifier watches the mode, so it rebuilt rather than carrying
      // half a match into a different opponent.
      expect(container.read(ticTacToeStateProvider).board.moveCount, 0);
    });

    test('reading the mode does not start a game', () {
      // The regression guard for a screen that only needs the setting: watching
      // the session instead would keep the game alive and stop it ever dealing
      // a fresh board.
      container.read(gameModeProvider);

      expect(container.exists(ticTacToeStateProvider), isFalse);
    });
  });

  group('how hard the machine plays', () {
    test('the advanced machine answers a corner with the centre', () {
      container.read(gameModeStateProvider.notifier).select(
        const GameMode.versusAi(aiPlayer: Player.player2),
      );

      container.read(ticTacToeStateProvider.notifier).play(const Position(col: 0, row: 0));

      expect(container.read(ticTacToeStateProvider).board.cells[1][1], -1);
    });

    test('a seeded machine plays the same game twice', () {
      Position firstReply() {
        final seeded = ProviderContainer(overrides: bindProviders(random: Provider((_) => Random(7))));
        addTearDown(seeded.dispose);

        seeded.read(gameModeStateProvider.notifier).select(
          const GameMode.versusAi(aiPlayer: Player.player2, difficulty: Difficulty.standard),
        );
        seeded.read(ticTacToeStateProvider.notifier).play(const Position(col: 0, row: 0));

        final cells = seeded.read(ticTacToeStateProvider).board.cells;
        for (var col = 0; col < 3; col++) {
          for (var row = 0; row < 3; row++) {
            if (cells[col][row] == -1) return Position(col: col, row: row);
          }
        }
        throw StateError('the machine did not move');
      }

      // Unbound, `Random()` would differ between containers and these would not
      // match — so this also proves the override actually reaches the behavior.
      expect(firstReply(), firstReply());
    });
  });
}
