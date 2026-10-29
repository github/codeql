package com.semmle.js.ast;

/** An assignment expression such as <code>x = 23</code> or <code>y += 19</code>. */
public class AssignmentExpression extends ABinaryExpression {
  public AssignmentExpression(
      SourceLocation loc, String operator, Expression left, Expression right) {
    super(loc, "AssignmentExpression", operator, left, right);
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
