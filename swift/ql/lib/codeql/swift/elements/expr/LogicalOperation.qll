private import codeql.swift.elements.expr.Expr
private import codeql.swift.elements.expr.BinaryExpr
private import codeql.swift.elements.expr.PrefixUnaryExpr
private import codeql.swift.elements.expr.internal.DotSyntaxCallExpr
private import codeql.swift.elements.expr.DeclRefExpr

private predicate unaryHasName(PrefixUnaryExpr e, string name) {
  e.getStaticTarget().getName() = name
}

private predicate binaryHasName(BinaryExpr e, string name) { e.getStaticTarget().getName() = name }

final class LogicalAndExpr extends BinaryExpr {
  LogicalAndExpr() { binaryHasName(this, "&&(_:_:)") }
}

final class LogicalOrExpr extends BinaryExpr {
  LogicalOrExpr() { binaryHasName(this, "||(_:_:)") }
}

final class BinaryLogicalOperation extends BinaryExpr {
  BinaryLogicalOperation() {
    this instanceof LogicalAndExpr or
    this instanceof LogicalOrExpr
  }
}

final class NotExpr extends PrefixUnaryExpr {
  NotExpr() { unaryHasName(this, "!(_:)") }
}

final class UnaryLogicalOperation extends PrefixUnaryExpr instanceof NotExpr { }

final class LogicalOperation extends Expr {
  LogicalOperation() {
    this instanceof BinaryLogicalOperation or
    this instanceof UnaryLogicalOperation
  }

  Expr getAnOperand() {
    result = this.(BinaryLogicalOperation).getAnOperand()
    or
    result = this.(UnaryLogicalOperation).getOperand()
  }
}
