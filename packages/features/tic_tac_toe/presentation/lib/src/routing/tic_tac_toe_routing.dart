import 'package:flutter/widgets.dart';

/// Where the feature can send the player.
///
/// A port: the feature says what happened, composition decides what that means
/// in terms of routes. Methods are named for the event, never for the
/// navigation (§12).
abstract interface class TicTacToeRouting {
  /// The player has chosen an opponent and wants to start.
  void onGameRequested({required BuildContext context});
}
