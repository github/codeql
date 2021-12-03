package com.semmle.js.ast;

/**
 * A for-in statement such as
 *
 * <pre>
 * for (var p in src)
 *   dest[p] = src[p];
 * </pre>
 *
 * This also includes legacy for-each statements.
 */
public class ForInStatement extends EnhancedForStatement {
  private final boolean each;

  public ForInStatement(
      SourceLocation loc, Node left, Expression right, Statement body, Boolean each) {
    super("ForInStatement", loc, left, right, body);
    this.each = each == Boolean.TRUE;
  }

  public boolean isEach() {
    return each;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
