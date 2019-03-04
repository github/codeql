package com.semmle.js.ast;

/**
 * A for-of statement such as
 *
 * <pre>
 * for (var elt of array)
 *   sum += elt;
 * </pre>
 */
public class ForOfStatement extends EnhancedForStatement {
  private boolean isAwait;

  public ForOfStatement(SourceLocation loc, Node left, Expression right, Statement body) {
    super("ForOfStatement", loc, left, right, body);
  }

  public void setAwait(boolean isAwait) {
    this.isAwait = isAwait;
  }

  public boolean isAwait() {
    return isAwait;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
