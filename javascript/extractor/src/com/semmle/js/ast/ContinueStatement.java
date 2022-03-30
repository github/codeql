package com.semmle.js.ast;

/**
 * A continue statement either with a label (<code>continue outer;</code>) or without (<code>
 * continue;</code>).
 */
public class ContinueStatement extends JumpStatement {
  public ContinueStatement(SourceLocation loc, Identifier label) {
    super("ContinueStatement", loc, label);
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
