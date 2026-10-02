import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tic_tac_toe_presentation/src/providers_internal.br.dart';
import 'package:tic_tac_toe_presentation/src/routing/tic_tac_toe_routing.dart';
import 'package:tic_tac_toe_presentation/src/theme/tic_tac_toe_theme.br.dart';

part 'providers_di.br.g.dart';

/// Routing provider -- required
@riverpod
TicTacToeRouting ticTacToeRouting(Ref _) => throw UnimplementedError('bindRoutingProvider was never called');

/// Theme provider -- optional
@riverpod
TicTacToeTheme ticTacToeTheme(Ref ref) => ref.watch(defaultTicTacToeThemeProvider);
