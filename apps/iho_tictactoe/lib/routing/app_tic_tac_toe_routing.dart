import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_presentation/tic_tac_toe_presentation.dart' as ui;

/// Turns the feature's intents into routes.
///
/// The feature says "a game was requested"; deciding that this means pushing a
/// screen — rather than replacing one, or opening a sheet — is the app's call.
class AppTicTacToeRouting implements ui.TicTacToeRouting {
  const AppTicTacToeRouting();

  @override
  void onGameRequested({required BuildContext context}) {
    // The route's completion is not the feature's business — it only asked
    // to go there.
    unawaited(Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ui.TicTacToeScreen())));
  }
}
