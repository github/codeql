import ql

/**
 * Holds if `aggr` is of one of the following forms:
 * `exists(var | range)` or `any(var | range)` or `any(var | | range)` or `any(type x | .. | x)`
 */
private predicate castAggregate(AstNode aggr, Formula range, VarDecl var, string kind) {
  kind = "exists" and
  exists(Exists ex | aggr = ex |
    ex.getRange() = range and
    not exists(ex.getFormula()) and
    count(ex.getArgument(_)) = 1 and
    ex.getArgument(0) = var
  )
  or
  kind = "any" and
  exists(Any anyy | aggr = anyy |
    not exists(anyy.getRange()) and
    anyy.getExpr(0) = range and
    count(anyy.getExpr(_)) = 1 and
    count(anyy.getArgument(_)) = 1 and
    anyy.getArgument(0) = var
  )
  or
  kind = "any" and
  exists(Any anyy | aggr = anyy |
    range = anyy.getRange() and
    count(anyy.getArgument(_)) = 1 and
    anyy.getArgument(0) = var and
    not exists(anyy.getExpr(0))
  )
  or
  kind = "any" and
  exists(Any anyy | aggr = anyy |
    range = anyy.getRange() and
    count(anyy.getExpr(_)) = 1 and
    count(anyy.getArgument(_)) = 1 and
    anyy.getExpr(_).(VarAccess).getDeclaration() = var and
    anyy.getArgument(0) = var
  )
}

/** Holds if `aggr` is an aggregate that could be replaced with an instanceof expression or an inline cast. */
predicate aggregateCouldBeCast(
  AstNode aggr, ComparisonFormula comp, string kind, VarDecl var, AstNode operand
) {
  castAggregate(aggr, comp, var, kind) and
  comp.getOperator() = "=" and
  count(VarAccess access | access.getDeclaration() = var and access.getParent() != aggr) = 1 and
  comp.getAnOperand().(VarAccess).getDeclaration() = var and
  operand = comp.getAnOperand() and
  not operand.(VarAccess).getDeclaration() = var
}
