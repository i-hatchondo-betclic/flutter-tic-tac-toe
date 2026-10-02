import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tic_tac_toe_domain/src/entities/difficulty.dart';
import 'package:tic_tac_toe_domain/src/entities/player.dart';

part 'game_mode.br.freezed.dart';

/// Who is playing.
///
/// [VersusAi] carries both the side the machine takes and how hard it plays, so
/// there is no second field that could disagree with this one — a difficulty
/// cannot exist without an opponent to apply it to.
@freezed
sealed class GameMode with _$GameMode {
  const factory GameMode.twoPlayers() = TwoPlayers;

  const factory GameMode.versusAi({
    required Player aiPlayer,
    @Default(Difficulty.advanced) Difficulty difficulty,
  }) = VersusAi;
}
