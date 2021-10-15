package com.semmle.js.ast;

/**
 * A short-circuiting binary expression, i.e., either <code>&amp;&amp;</code> or <code>||</code>.
 */
public class LogicalExpression extends ABinaryExpression {
  public LogicalExpression(SourceLocation loc, String operator, Expression left, Expression right) {
    super(loc, "LogicalExpression", operator, left, right);
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
