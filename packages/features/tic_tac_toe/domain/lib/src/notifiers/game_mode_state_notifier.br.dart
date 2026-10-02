import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tic_tac_toe_domain/src/entities/game_mode.br.dart';

part 'game_mode_state_notifier.br.g.dart';

/// Who is playing — a setting, not game state.
///
/// It outlives any single game, which is why it lives here rather than inside
/// `GameSession`: resetting a game must not reset the choice of opponent.
@Riverpod(keepAlive: true)
final class GameModeStateNotifier extends _$GameModeStateNotifier {
  @override
  GameMode build() => const GameMode.twoPlayers();

  // A verb reads better at the call site, and a setter cannot be torn off
  // for the `selectMode` proxy.
  // ignore: use_setters_to_change_properties
  void select(GameMode mode) => state = mode;
}
