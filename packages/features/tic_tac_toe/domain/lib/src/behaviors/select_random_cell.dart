import 'dart:math';

import 'package:tic_tac_toe_domain/src/behaviors/list_open_cells.dart';
import 'package:tic_tac_toe_domain/src/entities/game_board.br.dart';
import 'package:tic_tac_toe_domain/src/entities/position.br.dart';

/// Picks a free square at random.
///
/// [random] is passed in rather than created here so a test can seed it and get
/// the same game twice.
Position? selectRandomCell({required GameBoard board, required Random random}) {
  final cells = listOpenCells(board);
  return cells.isEmpty ? null : cells[random.nextInt(cells.length)];
}
