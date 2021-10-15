package com.semmle.js.ast;

/** A while loop. */
public class WhileStatement extends Loop {
  private final Expression test;

  public WhileStatement(SourceLocation loc, Expression test, Statement body) {
    super("WhileStatement", loc, body);
    this.test = test;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The test expression of this while loop. */
  public Expression getTest() {
    return test;
  }

  @Override
  public Node getContinueTarget() {
    return test;
  }
}
