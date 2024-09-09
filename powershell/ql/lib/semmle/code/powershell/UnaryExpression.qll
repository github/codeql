import powershell

class UnaryExpr extends @unary_expression, Expr {
  override SourceLocation getLocation() { unary_expression_location(this, result) }

  int getKind() { unary_expression(this, _, result, _) }

  Expr getOperand() { unary_expression(this, result, _, _) }
}

class NotExpr extends UnaryExpr {
  NotExpr() { this.getKind() = [36, 51] }

  predicate isExclamationMark() { this.getKind() = 36 }

  predicate isNot() { this.getKind() = 51 }

  final override string toString() {
    this.isExclamationMark() and result = "!..."
    or
    this.isNot() and result = "-not ..."
  }
}

abstract private class AbstractUnaryArithmeticExpr extends UnaryExpr { }

final class UnaryArithmeticExpr = AbstractUnaryArithmeticExpr;

abstract private class AbstractPostfixExpr extends AbstractUnaryArithmeticExpr, UnaryExpr { }

abstract private class AbstractPrefixExpr extends AbstractUnaryArithmeticExpr, UnaryExpr { }

abstract private class AbstractIncrExpr extends AbstractUnaryArithmeticExpr, UnaryExpr { }

abstract private class AbstractDecrExpr extends AbstractUnaryArithmeticExpr, UnaryExpr { }

final class PostfixExpr = AbstractPostfixExpr;

final class PrefixExpr = AbstractPrefixExpr;

final class IncrExpr = AbstractIncrExpr;

final class DecrExpr = AbstractDecrExpr;

class PostfixIncrExpr extends AbstractPostfixExpr, AbstractIncrExpr {
  PostfixIncrExpr() { this.getKind() = 95 }

  final override string toString() { result = "...++" }
}

class PostfixDecrExpr extends AbstractPostfixExpr, AbstractIncrExpr {
  PostfixDecrExpr() { this.getKind() = 96 }

  final override string toString() { result = "...--" }
}

class PrefixDecrExpr extends AbstractPostfixExpr, AbstractIncrExpr {
  PrefixDecrExpr() { this.getKind() = 31 }

  final override string toString() { result = "--..." }
}

class PrefixIncrExpr extends AbstractPostfixExpr, AbstractIncrExpr {
  PrefixIncrExpr() { this.getKind() = 32 }

  final override string toString() { result = "++..." }
}

class NegateExpr extends AbstractUnaryArithmeticExpr {
  NegateExpr() { this.getKind() = 41 }

  final override string toString() { result = "-..." }
}
