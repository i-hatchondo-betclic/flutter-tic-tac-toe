import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

/// Incoming contracts. Never exported — fed only through `bindProviders`.
///
/// Optional: unbound it is just `Random()`. A test binds a seeded one and the
/// standard opponent becomes reproducible.
@riverpod
Random random(Ref _) => Random();
