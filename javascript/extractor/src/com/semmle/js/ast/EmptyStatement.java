package com.semmle.js.ast;

/** An empty statement <code>;</code>. */
public class EmptyStatement extends Statement {
  public EmptyStatement(SourceLocation loc) {
    super("EmptyStatement", loc);
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
