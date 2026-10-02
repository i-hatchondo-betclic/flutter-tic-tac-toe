import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tic_tac_toe_domain/src/entities/game_mode.br.dart';
import 'package:tic_tac_toe_domain/src/entities/game_session.br.dart';
import 'package:tic_tac_toe_domain/src/entities/position.br.dart';
import 'package:tic_tac_toe_domain/src/notifiers/game_mode_state_notifier.br.dart';
import 'package:tic_tac_toe_domain/src/notifiers/tic_tac_toe_state_notifier.br.dart';
import 'package:tic_tac_toe_domain/src/providers_di.br.dart';

part 'providers.br.g.dart';

/// Plays [pos] for whoever's turn it is. Does nothing once the game has ended.
typedef Play = void Function(Position pos);

/// Abandons the current game and deals a fresh board.
typedef Reset = void Function();

/// Chooses the opponent. Starts a fresh game, since switching mid-match is
/// meaningless.
typedef SelectMode = void Function(GameMode mode);

/// The game as it stands: board, whose turn it is, and how it ended (or `null`
/// while it is still running).
@riverpod
GameSession gameSession(Ref ref) => ref.watch(ticTacToeStateProvider);

/// Who is playing — readable without touching the game.
///
/// A screen that only needs the setting must not watch [gameSession]: that
/// would keep the game alive for as long as the screen is mounted, and an
/// auto-disposing notifier would never get the chance to deal a fresh board.
@riverpod
GameMode gameMode(Ref ref) => ref.watch(gameModeStateProvider);

@riverpod
Play play(Ref ref) => ref.read(ticTacToeStateProvider.notifier).play;

@riverpod
Reset reset(Ref ref) => ref.read(ticTacToeStateProvider.notifier).reset;

@riverpod
SelectMode selectMode(Ref ref) => ref.read(gameModeStateProvider.notifier).select;

/// Feeds this layer's own contracts. [random] is optional — omitted, the machine
/// just uses `Random()`.
List<Override> bindProviders({ProviderListenable<Random>? random}) => [
  if (random != null) randomProvider.overrideWith((ref) => ref.watch(random)),
];
