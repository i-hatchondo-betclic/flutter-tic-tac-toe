# iho_tictactoe_app

A naive Tic Tac Toe, built to exercise our recent training on the **betclic `flutter-front`**
architecture.

**▶ [Play it in the browser](https://<your-github-user>.github.io/iho_tictactoe_app/)** — built and
published by `.github/workflows/deploy-web.yml` on every push to `main`.

The point is not the game. The point is the wiring — and, this time, what happens when a feature
has **no I/O at all**.

## What it does

- **Two players**, hot-seat on one device.
- **Versus the machine**, at two strengths:
  - *standard* — picks a free square at random
  - *advanced* — full minimax; it cannot be beaten
- A **setup screen** to choose the opponent, then the board. Changing the choice starts a fresh game.
- Win and draw detection, a status line, and a new game button.
- Layouts for **portrait and landscape** — the board moves beside its label when the screen is wider
  than it is tall.

## The architecture, briefly

```
apps/iho_tictactoe/                composition root — the ONLY place the layers meet
packages/features/tic_tac_toe/
├── domain/         tic_tac_toe_domain        entities, behaviors, game state — pure Dart
└── presentation/   tic_tac_toe_presentation  UI state, theme, widgets, screens
```

**There is no `data` package, and that is the lesson.** Nothing is persisted, so there is no I/O to
hide behind a repository — and a repository interface with nothing to abstract, a DTO with nothing
to serialize and a mapper with nothing to map are all dead weight. It is the same argument §7's
Rule A makes against a pass-through repository class, one level up.

The dependency rule is unchanged: **presentation points at domain and nothing else**, enforced by
the compiler because they are separate packages.

### Inside the domain

| | |
|---|---|
| `entities/` | immutable freezed values — `GameBoard` carries running line sums, so a win is `abs() == size` without rescanning |
| `behaviors/` | pure functions — `applyMove`, `evaluateBoard`, `switchPlayer`, `listOpenCells`, `selectBestMove` |
| `notifiers/` | the only mutable things: the game session and the chosen opponent |
| `providers.br.dart` | the public surface — read proxies and named mutations; the notifiers are never exported |

`applyMove` returns a **new** board rather than mutating one, which is what makes minimax about
fifty lines: every candidate is explored on a copy, so there is no `undo()` to get wrong and the
live game cannot be corrupted.

### Riverpod contracts

Both halves of the pattern are in use:

- **required** — `ticTacToeRouting` throws until composition binds it
- **optional** — `ticTacToeTheme` and `random` proxy in-package defaults, so the feature renders and
  plays unbound

Presentation publishes no `@riverpod` provider, so its public file is a plain **`providers.dart`**
with no codegen — `bindRoutingProvider` separate from `bindProviders`, because routing is fed from
the navigator and the theme from a brand.

## Tests

70, and none of them need a device:

```
domain/test/unit/src/behaviors/     the rules, as pure functions
domain/test/unit/src/notifiers/     state, turn order, the machine's reply
presentation/test/unit/src/state/   the entity → UI mapping, including the board transposition
presentation/test/unit/src/         both screens, both orientations
```

The one worth reading is `select_best_move_test.dart`: it walks **every** game an opponent can play
against minimax — exhaustive, not sampled, because the machine's reply is deterministic — and
asserts it never loses.

## Commands

Generated files (`*.freezed.dart`, `*.g.dart`) are **not** committed, so the first two commands
are mandatory after cloning.

```bash
flutter pub get                 # resolve the whole workspace
melos run generate              # build_runner across packages that need it
melos run analyze
melos run test
cd apps/iho_tictactoe && flutter run
cd apps/iho_tictactoe && flutter build web --release --base-href "/<repo>/"
```

## Note on the pinned versions

`dependency_overrides` in the root `pubspec.yaml` pin the analyzer/build chain. Flutter 3.44.4 ships
`meta 1.18.0`, which caps `analyzer` below what current `build_runner` and `riverpod_generator` ask
for. `flutter-front` carries the same pins for the same reason. Revisit them when the Flutter SDK
moves.

Building for the iOS simulator also needs `ARCHS[sdk=iphonesimulator*] = arm64` (set in
`ios/Flutter/*.xcconfig`): Xcode 27's `lipo` rejects `-verify_arch arm64 x86_64`, and Flutter
reports that as a missing architecture. Drop it once Flutter stops passing both at once.
