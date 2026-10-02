/// How hard the machine plays.
enum Difficulty {
  /// Picks at random among the free squares.
  standard,

  /// Full minimax — cannot be beaten.
  advanced,
}
