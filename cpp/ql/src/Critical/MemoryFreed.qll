import semmle.code.cpp.pointsto.PointsTo

private predicate freed(Expr e) {
  exists(FunctionCall fc, Expr arg |
    freeCall(fc, arg) and
    arg = e
  )
  or
  exists(DeleteExpr de | de.getExpr() = e)
  or
  exists(DeleteArrayExpr de | de.getExpr() = e)
  or
  exists(ExprCall c |
    // cautiously assume that any ExprCall could be a freeCall.
    c.getAnArgument() = e
  )
}

class FreedExpr extends PointsToExpr {
  FreedExpr() { freed(this) }

  override predicate interesting() { freed(this) }
}

predicate allocMayBeFreed(Expr alloc) {
  isAllocationExpr(alloc) and
  anythingPointsTo(alloc)
}
