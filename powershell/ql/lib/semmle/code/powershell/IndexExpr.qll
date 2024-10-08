import powershell
private import internal.ExplicitWrite::Private

class IndexExpr extends @index_expression, Expr {
  override string toString() { result = "...[...]" }

  override SourceLocation getLocation() { index_expression_location(this, result) }

  Expr getIndex() { index_expression(this, result, _, _) } // TODO: Change @ast to @expr in the dbscheme

  Expr getBase() { index_expression(this, _, result, _) } // TODO: Change @ast to @expr in the dbscheme

  predicate isNullConditional() { index_expression(this, _, _, true) }
}

private predicate isImplicitIndexWrite(Expr e) { none() }

/** An index expression that is being written to. */
class IndexExprWrite extends IndexExpr {
  IndexExprWrite() { isExplicitWrite(this, _) or isImplicitIndexWrite(this) }

  predicate isExplicit(AssignStmt assign) { isExplicitWrite(this, assign) }

  predicate isImplicit() { isImplicitIndexWrite(this) }
}

/** An index expression that is being read from. */
class IndexExprRead extends IndexExpr {
  IndexExprRead() { not this instanceof IndexExprWrite }
}
