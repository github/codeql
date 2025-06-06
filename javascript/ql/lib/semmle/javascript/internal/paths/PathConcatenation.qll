private import javascript

/**
 * A path expression that can be constant-folded by concatenating subexpressions.
 */
abstract class PathConcatenation extends Expr {
  /** Gets the separator to insert between paths */
  string getSeparator() { result = "" }

  /** Gets the `n`th operand to concatenate. */
  abstract Expr getOperand(int n);
}

private class AddExprConcatenation extends PathConcatenation, AddExpr {
  override Expr getOperand(int n) {
    n = 0 and result = this.getLeftOperand()
    or
    n = 1 and result = this.getRightOperand()
  }
}

private class TemplateConcatenation extends PathConcatenation, TemplateLiteral {
  override Expr getOperand(int n) { result = this.getElement(n) }
}

private class JoinCallConcatenation extends PathConcatenation, CallExpr {
  JoinCallConcatenation() {
    // Heuristic recognition of path.join and path.resolve since we can't rely on SourceNode at this stage.
    this.getReceiver().(VarAccess).getName() = "path" and
    this.getCalleeName() = ["join", "resolve"]
  }

  override Expr getOperand(int n) { result = this.getArgument(n) }

  override string getSeparator() { result = "/" }
}
