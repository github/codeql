import semmle.code.cpp.pointsto.PointsTo

/** Holds if there exists a call to a function that might close the file specified by `e`. */
predicate closed(Expr e) {
  fcloseCall(_, e) or
  exists(ExprCall c |
    // cautiously assume that any ExprCall could be a call to fclose.
    c.getAnArgument() = e
  )
}

/** An expression for which there exists a function call that might close it. */
class ClosedExpr extends PointsToExpr {
  ClosedExpr() { closed(this) }

  override predicate interesting() { closed(this) }
}

/**
 * Holds if `fc` is a call to a function that opens a file that might be closed. For example:
 * ```
 * FILE* f = fopen("file.txt", "r");
 * ...
 * fclose(f);
 * ```
 */
predicate fopenCallMayBeClosed(FunctionCall fc) { fopenCall(fc) and anythingPointsTo(fc) }
