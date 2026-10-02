import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_presentation/src/tic_tac_toe_screen.dart';
import 'package:tic_tac_toe_presentation/src/widgets/game_board_view.dart';

const _portrait = Size(402, 874);
const _landscape = Size(874, 402);

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    const ProviderScope(child: MaterialApp(home: TicTacToeScreen())),
  );
}

void main() {
  group('fitting the screen', () {
    // A RenderFlex overflow throws during layout, which the tester captures —
    // so this is the cheapest guard against the board outgrowing its space.
    testWidgets('upright', (tester) async {
      await _pumpAt(tester, _portrait);

      expect(tester.takeException(), isNull);
    });

    testWidgets('on its side', (tester) async {
      await _pumpAt(tester, _landscape);

      expect(tester.takeException(), isNull);
    });
  });

  group('arranging itself for the space', () {
    testWidgets('upright, the board sits below the label', (tester) async {
      await _pumpAt(tester, _portrait);

      expect(
        tester.getCenter(find.byType(GameBoardView)).dy,
        greaterThan(tester.getCenter(find.text('X to play')).dy),
      );
    });

    testWidgets('on its side, the board sits beside it instead', (tester) async {
      await _pumpAt(tester, _landscape);

      expect(
        tester.getCenter(find.byType(GameBoardView)).dx,
        greaterThan(tester.getCenter(find.text('X to play')).dx),
      );
    });

    testWidgets('the board stays square whichever way up it is', (tester) async {
      await _pumpAt(tester, _landscape);

      final board = tester.getSize(find.byType(GameBoardView));

      expect(board.width, closeTo(board.height, 0.5));
    });
  });
}
