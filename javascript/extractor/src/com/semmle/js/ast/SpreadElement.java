package com.semmle.js.ast;

/** A spread element <code>...xs</code> in rvalue position. */
public class SpreadElement extends Expression {
  private final Expression argument;

  public SpreadElement(SourceLocation loc, Expression argument) {
    super("SpreadElement", loc);
    this.argument = argument;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The argument expression of this spread element. */
  public Expression getArgument() {
    return argument;
  }
}
