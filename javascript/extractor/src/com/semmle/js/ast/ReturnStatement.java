package com.semmle.js.ast;

/** A return statement. */
public class ReturnStatement extends Statement {
  private final Expression argument;

  public ReturnStatement(SourceLocation loc, Expression argument) {
    super("ReturnStatement", loc);
    this.argument = argument;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** Does this return statement have an argument expression? */
  public boolean hasArgument() {
    return argument != null;
  }

  /** The argument expression of this return statement; may be null. */
  public Expression getArgument() {
    return argument;
  }
}
