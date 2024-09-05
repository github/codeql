import powershell

abstract private class AbstractSplitExpr extends Expr {
  abstract Expr getExpr();

  /** ..., if any. */
  Expr getSeparator() { none() }
}

final class SplitExpr = AbstractSplitExpr;

class UnarySplitExpr extends AbstractSplitExpr, UnaryExpr {
  UnarySplitExpr() { this.getKind() = 75 }

  final override string toString() { result = "-split ..." }

  final override Expr getExpr() { result = this.getOperand() }
}

class BinarySplitExpr extends AbstractSplitExpr, BinaryExpr {
  BinarySplitExpr() { this.getKind() = 75 }

  final override string toString() { result = "... -split ..." }

  final override Expr getExpr() { result = this.getLeft() }

  final override Expr getSeparator() { result = this.getRight() }
}
