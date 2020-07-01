import semmle.code.cpp.pointsto.PointsTo

private predicate freed(Expr e) {
  e = any(DeallocationExpr de).getFreedExpr()
  or
  exists(ExprCall c |
    // cautiously assume that any `ExprCall` could be a deallocation expression.
    c.getAnArgument() = e
  )
}

/** An expression that might be deallocated. */
class FreedExpr extends PointsToExpr {
  FreedExpr() { freed(this) }

  override predicate interesting() { freed(this) }
}

/**
 * An allocation expression that might be deallocated. For example:
 * ```
 * int* p = new int;
 * ...
 * delete p;
 * ```
 */
predicate allocMayBeFreed(AllocationExpr alloc) { anythingPointsTo(alloc) }
