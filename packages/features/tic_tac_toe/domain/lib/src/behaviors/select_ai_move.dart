import 'dart:math';

import 'package:tic_tac_toe_domain/src/behaviors/select_best_move.dart';
import 'package:tic_tac_toe_domain/src/behaviors/select_random_cell.dart';
import 'package:tic_tac_toe_domain/src/entities/difficulty.dart';
import 'package:tic_tac_toe_domain/src/entities/game_board.br.dart';
import 'package:tic_tac_toe_domain/src/entities/player.dart';
import 'package:tic_tac_toe_domain/src/entities/position.br.dart';

/// The machine's move, by difficulty. `null` when there is nowhere to play.
Position? selectAiMove({
  required GameBoard board,
  required Player player,
  required Difficulty difficulty,
  required Random random,
}) => switch (difficulty) {
  Difficulty.standard => selectRandomCell(board: board, random: random),
  Difficulty.advanced => selectBestMove(board: board, player: player),
};
