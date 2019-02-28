package com.semmle.js.ast;

/** A <code>throw</code> statement. */
public class ThrowStatement extends Statement {
  private final Expression argument;

  public ThrowStatement(SourceLocation loc, Expression argument) {
    super("ThrowStatement", loc);
    this.argument = argument;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The thrown expression. */
  public Expression getArgument() {
    return argument;
  }
}
