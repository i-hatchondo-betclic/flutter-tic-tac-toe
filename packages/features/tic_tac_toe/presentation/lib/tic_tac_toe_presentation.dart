/// Public surface of the Tic Tac Toe presentation layer.
///
/// Exposes the two screens, the routing contract composition must implement,
/// the theme it may override, and the `bind*` functions. Publishes no
/// `@riverpod` provider, which is why its public file is a plain
/// `providers.dart`.
library;

export 'src/game_setup_screen.dart';
export 'src/providers.dart';
export 'src/routing/tic_tac_toe_routing.dart';
export 'src/theme/tic_tac_toe_theme.br.dart';
export 'src/tic_tac_toe_screen.dart';
