/// Public surface of the Tic Tac Toe domain layer.
///
/// `src/notifiers/` and the behaviors stay package-internal: consumers read the
/// game through `gameSession` and change it through `play`, never by reaching
/// for the notifier itself.
library;

export 'src/entities/board_status.dart';
export 'src/entities/difficulty.dart';
export 'src/entities/game_board.br.dart';
export 'src/entities/game_mode.br.dart';
export 'src/entities/game_session.br.dart';
export 'src/entities/player.dart';
export 'src/entities/position.br.dart';
export 'src/providers.br.dart';
