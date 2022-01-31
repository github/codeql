import ql

class Sup extends AstNode {
  abstract predicate step(Expr pred, Expr succ);
}

class Correct extends Sup {
  override predicate step(Expr pred, Expr succ) { none() }
}

class Wrong extends Sup {
  override predicate step(Expr succ, Expr pred) { none() } // <- swapped parameter names
}
