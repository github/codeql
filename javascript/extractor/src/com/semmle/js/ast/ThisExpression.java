package com.semmle.js.ast;

/** A <code>this</code> expression. */
public class ThisExpression extends Expression {
  public ThisExpression(SourceLocation loc) {
    super("ThisExpression", loc);
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
