import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_presentation/src/game_setup_screen.dart';

const _portrait = Size(402, 874);
const _landscape = Size(874, 402);

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    const ProviderScope(child: MaterialApp(home: GameSetupScreen())),
  );
}

void main() {
  group('fitting the screen', () {
    testWidgets('upright', (tester) async {
      await _pumpAt(tester, _portrait);

      expect(tester.takeException(), isNull);
    });

    testWidgets('on its side, where the controls would otherwise be clipped', (tester) async {
      await _pumpAt(tester, _landscape);

      expect(tester.takeException(), isNull);
    });
  });

  group('offering the opponents', () {
    testWidgets('two humans to begin with, and no difficulty to choose', (tester) async {
      await _pumpAt(tester, _portrait);

      expect(find.text('2 players'), findsOneWidget);
      expect(find.text('vs machine'), findsOneWidget);
      expect(find.text('advanced'), findsNothing);
    });

    testWidgets('picking the machine reveals how hard it should play', (tester) async {
      await _pumpAt(tester, _portrait);

      await tester.tap(find.text('vs machine'));
      await tester.pumpAndSettle();

      expect(find.text('standard'), findsOneWidget);
      expect(find.text('advanced'), findsOneWidget);
    });
  });
}
