package com.semmle.js.ast;

/**
 * A <code>super</code> expression, appearing either as the callee of a super constructor call or as
 * the receiver of a super method call.
 */
public class Super extends Expression {
  public Super(SourceLocation loc) {
    super("Super", loc);
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
