private import codeql.swift.elements.expr.Expr
private import codeql.swift.elements.expr.BinaryExpr
private import codeql.swift.elements.expr.PrefixUnaryExpr
private import codeql.swift.elements.expr.DotSyntaxCallExpr
private import codeql.swift.elements.expr.DeclRefExpr
private import codeql.swift.elements.decl.ConcreteFuncDecl

private predicate unaryHasName(PrefixUnaryExpr e, string name) {
  e.getStaticTarget().getName() = name
}

private predicate binaryHasName(BinaryExpr e, string name) { e.getStaticTarget().getName() = name }

class LogicalAndExpr extends BinaryExpr {
  LogicalAndExpr() { binaryHasName(this, "&&(_:_:)") }
}

class LogicalOrExpr extends BinaryExpr {
  LogicalOrExpr() { binaryHasName(this, "||(_:_:)") }
}

class BinaryLogicalOperation extends BinaryExpr {
  BinaryLogicalOperation() {
    this instanceof LogicalAndExpr or
    this instanceof LogicalOrExpr
  }
}

class NotExpr extends PrefixUnaryExpr {
  NotExpr() { unaryHasName(this, "!(_:)") }
}

class UnaryLogicalOperation extends PrefixUnaryExpr instanceof NotExpr { }

class LogicalOperation extends Expr {
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
