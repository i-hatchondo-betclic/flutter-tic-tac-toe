import 'package:tic_tac_toe_domain/src/entities/player.dart';

/// The other player.
Player switchPlayer(Player player) {
  return switch (player) {
    Player.player1 => Player.player2,
    Player.player2 => Player.player1,
  };
}
