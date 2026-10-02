import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tic_tac_toe_domain/tic_tac_toe_domain.dart';
import 'package:tic_tac_toe_presentation/src/state/game_ui_state.br.dart';
import 'package:tic_tac_toe_presentation/src/theme/tic_tac_toe_theme.br.dart';

part 'providers_internal.br.g.dart';

/// The look the feature ships with, so it renders correctly when composition
/// binds nothing. A brand replaces it through `bindProviders(theme:)`.
@riverpod
TicTacToeTheme defaultTicTacToeTheme(Ref _) => const TicTacToeTheme(
  background: Color(0xFFF5F7F9),
  cell: Colors.white,
  player1Mark: Color(0xFF0F7B8A),
  player2Mark: Color(0xFFB03A5B),
  statusStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
);

/// The screen's state, derived from the game.
///
/// A plain provider rather than a notifier: nothing here is edited by the user,
/// it is only a projection of `gameSession`.
@riverpod
GameUiState gameUiState(Ref ref) => ref.watch(gameSessionProvider).toUiState();
