import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_presentation/src/tic_tac_toe_screen.dart';
import 'package:tic_tac_toe_presentation/src/widgets/game_board_view.dart';
import 'package:tic_tac_toe_presentation/src/widgets/game_cell.dart';
import 'package:tic_tac_toe_presentation/src/widgets/player_mark.dart';

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

  group('playing', () {
    testWidgets('tapping an empty square marks it and passes the turn', (tester) async {
      await _pumpAt(tester, _portrait);
      expect(find.byType(PlayerMark), findsNothing);
      expect(find.text('X to play'), findsOneWidget);

      await tester.tap(find.byType(GameCell).first);
      await tester.pumpAndSettle();

      expect(find.byType(PlayerMark), findsOneWidget);
      expect(find.text('O to play'), findsOneWidget);
    });

    testWidgets('a square that is already taken does not move again', (tester) async {
      await _pumpAt(tester, _portrait);
      await tester.tap(find.byType(GameCell).first);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GameCell).first);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(PlayerMark), findsOneWidget);
      expect(find.text('O to play'), findsOneWidget);
    });

    testWidgets('a new game clears the board once there is something to clear', (tester) async {
      await _pumpAt(tester, _portrait);
      expect(tester.widget<TextButton>(find.byType(TextButton)).onPressed, isNull);

      await tester.tap(find.byType(GameCell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('New game'));
      await tester.pumpAndSettle();

      expect(find.byType(PlayerMark), findsNothing);
      expect(find.text('X to play'), findsOneWidget);
    });
  });
}
