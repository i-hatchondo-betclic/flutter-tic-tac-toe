import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tic_tac_toe_presentation/src/providers_di.br.dart';
import 'package:tic_tac_toe_presentation/src/routing/tic_tac_toe_routing.dart';
import 'package:tic_tac_toe_presentation/src/theme/tic_tac_toe_theme.br.dart';

/// Plain Dart, no codegen: this layer publishes no `@riverpod` provider, so its
/// public file is `providers.dart` rather than `providers.br.dart` (§8).

/// Routing gets its own function (§9) — it is fed from the app's navigator,
/// which is a different concern from branding.
List<Override> bindRoutingProvider({required ProviderListenable<TicTacToeRouting> routing}) => [
  ticTacToeRoutingProvider.overrideWith((ref) => ref.watch(routing)),
];

/// The theme is optional; omit it and the feature uses its own.
List<Override> bindProviders({ProviderListenable<TicTacToeTheme>? theme}) => [
  if (theme != null) ticTacToeThemeProvider.overrideWith((ref) => ref.watch(theme)),
];
