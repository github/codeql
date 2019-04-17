import semmle.code.cpp.pointsto.PointsTo

predicate closed(Expr e) {
  fcloseCall(_, e) or
  exists(ExprCall c |
    // cautiously assume that any ExprCall could be a call to fclose.
    c.getAnArgument() = e
  )
}

class ClosedExpr extends PointsToExpr {
  ClosedExpr() { closed(this) }

  override predicate interesting() { closed(this) }
}

predicate fopenCallMayBeClosed(FunctionCall fc) { fopenCall(fc) and anythingPointsTo(fc) }
