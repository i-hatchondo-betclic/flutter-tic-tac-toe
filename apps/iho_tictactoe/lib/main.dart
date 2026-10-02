import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iho_tictactoe/routing/app_tic_tac_toe_routing.dart';
import 'package:tic_tac_toe_presentation/tic_tac_toe_presentation.dart' as ui;

void main() {
  runApp(
    ProviderScope(
      overrides: [
        // Routing is required — the feature throws without it.
        ...ui.bindRoutingProvider(routing: Provider((_) => const AppTicTacToeRouting())),
        // Theme and the machine's randomness are optional: omitted, the feature
        // uses its own defaults. Binding them is how a brand or a test takes over.
      ],
      child: const TicTacToeApp(),
    ),
  );
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: const ui.GameSetupScreen(),
    );
  }
}
