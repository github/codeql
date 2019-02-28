package com.semmle.js.ast;

/**
 * A break statement either with a label (<code>break outer;</code>) or without (<code>break;</code>
 * ).
 */
public class BreakStatement extends JumpStatement {
  public BreakStatement(SourceLocation loc, Identifier label) {
    super("BreakStatement", loc, label);
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
