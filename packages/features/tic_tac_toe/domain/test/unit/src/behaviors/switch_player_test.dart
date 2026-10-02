import 'package:test/test.dart';
import 'package:tic_tac_toe_domain/src/behaviors/switch_player.dart';
import 'package:tic_tac_toe_domain/src/entities/player.dart';

void main() {
  group('taking turns', () {
    test('player one is followed by player two', () {
      expect(switchPlayer(Player.player1), Player.player2);
    });

    test('player two is followed by player one', () {
      expect(switchPlayer(Player.player2), Player.player1);
    });

    test('switching twice returns to the same player', () {
      expect(switchPlayer(switchPlayer(Player.player1)), Player.player1);
    });
  });
}
