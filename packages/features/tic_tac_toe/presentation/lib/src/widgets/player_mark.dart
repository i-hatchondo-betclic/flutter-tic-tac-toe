import 'package:flutter/widgets.dart';
import 'package:tic_tac_toe_domain/tic_tac_toe_domain.dart';
import 'package:tic_tac_toe_presentation/src/state/game_ui_state.br.dart';

/// The X or O itself, drawn to fill whatever box it is given.
///
/// Every dimension comes off the shortest side, so the mark scales with its
/// cell rather than carrying numbers that only suit one board size.
class PlayerMark extends StatelessWidget {
  const PlayerMark({required this.player, required this.color, super.key});

  final Player player;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // A painted shape carries no text, so the glyph is what a screen reader
    // announces for this square.
    return Semantics(
      label: player.glyph,
      child: CustomPaint(
        size: Size.infinite,
        painter: _MarkPainter(player: player, color: color),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter({required this.player, required this.color});

  final Player player;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..strokeWidth = size.shortestSide * 0.12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final inset = size.shortestSide * 0.24;

    switch (player) {
      case Player.player1:
        canvas
          ..drawLine(Offset(inset, inset), Offset(size.width - inset, size.height - inset), stroke)
          ..drawLine(Offset(size.width - inset, inset), Offset(inset, size.height - inset), stroke);
      case Player.player2:
        canvas.drawCircle(size.center(Offset.zero), size.shortestSide / 2 - inset, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _MarkPainter oldDelegate) => oldDelegate.player != player || oldDelegate.color != color;
}
