import semmle.code.cpp.pointsto.PointsTo

private predicate freed(Expr e) {
  e = any(DeallocationExpr de).getFreedExpr()
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

predicate allocMayBeFreed(AllocationExpr alloc) { anythingPointsTo(alloc) }
