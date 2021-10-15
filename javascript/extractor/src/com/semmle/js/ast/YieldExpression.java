package com.semmle.js.ast;

/** A yield expression. */
public class YieldExpression extends Expression {
  private final Expression argument;
  private final boolean delegating;

  public YieldExpression(SourceLocation loc, Expression argument, Boolean delegating) {
    super("YieldExpression", loc);
    this.argument = argument;
    this.delegating = delegating == Boolean.TRUE;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The argument of this yield expression. */
  public Expression getArgument() {
    return argument;
  }

  /** Is this a delegating yield expression? */
  public boolean isDelegating() {
    return delegating;
  }
}
