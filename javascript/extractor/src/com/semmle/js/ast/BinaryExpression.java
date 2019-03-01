package com.semmle.js.ast;

/** A binary expression such as <code>x + y</code>. */
public class BinaryExpression extends ABinaryExpression {
  public BinaryExpression(SourceLocation loc, String operator, Expression left, Expression right) {
    super(loc, "BinaryExpression", operator, left, right);
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
