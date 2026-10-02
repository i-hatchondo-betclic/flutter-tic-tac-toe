import 'dart:math';

import 'package:tic_tac_toe_domain/src/behaviors/apply_move.dart';
import 'package:tic_tac_toe_domain/src/behaviors/evaluate_board.dart';
import 'package:tic_tac_toe_domain/src/behaviors/list_open_cells.dart';
import 'package:tic_tac_toe_domain/src/behaviors/switch_player.dart';
import 'package:tic_tac_toe_domain/src/entities/board_status.dart';
import 'package:tic_tac_toe_domain/src/entities/game_board.br.dart';
import 'package:tic_tac_toe_domain/src/entities/player.dart';
import 'package:tic_tac_toe_domain/src/entities/position.br.dart';

/// An opponent that cannot be beaten: full minimax over the remaining squares.
///
/// Every candidate is explored on a copy — `applyMove` returns a new position
/// instead of mutating — so there is no undo to get wrong and the live game is
/// never touched.
Position? selectBestMove({required GameBoard board, required Player player}) {
  final moves = listOpenCells(board);
  if (moves.isEmpty) {
    return null;
  }

  var bestScore = -1000;
  Position? best;

  for (final pos in moves) {
    final score = _score(
      board: applyMove(board: board, pos: pos, player: player),
      pos: pos,
      mover: player,
      maximiser: player,
      depth: 1,
    );
    if (score > bestScore) {
      bestScore = score;
      best = pos;
    }
  }

  return best;
}

/// Value of the position from [maximiser]'s side, after [mover] played [pos].
///
/// Depth is subtracted from a win and added to a loss, so the machine takes the
/// fastest win and the slowest defeat rather than treating them alike.
int _score({
  required GameBoard board,
  required Position pos,
  required Player mover,
  required Player maximiser,
  required int depth,
}) {
  final status = evaluateBoard(board, pos, mover);
  if (status != null) {
    if (status == BoardStatus.draw) {
      return 0;
    }
    return _winner(status) == maximiser ? 10 - depth : depth - 10;
  }

  final next = switchPlayer(mover);
  final isMaximising = next == maximiser;
  var best = isMaximising ? -1000 : 1000;

  for (final candidate in listOpenCells(board)) {
    final score = _score(
      board: applyMove(board: board, pos: candidate, player: next),
      pos: candidate,
      mover: next,
      maximiser: maximiser,
      depth: depth + 1,
    );
    best = isMaximising ? max(best, score) : min(best, score);
  }

  return best;
}

Player _winner(BoardStatus status) => status == BoardStatus.player1Win ? Player.player1 : Player.player2;
