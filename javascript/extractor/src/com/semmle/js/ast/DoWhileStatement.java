package com.semmle.js.ast;

/** A do-while statement of the form <code>do { ... } while(...);</code>. */
public class DoWhileStatement extends Loop {
  private final Expression test;

  public DoWhileStatement(SourceLocation loc, Expression test, Statement body) {
    super("DoWhileStatement", loc, body);
    this.test = test;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The test expression of this loop. */
  public Expression getTest() {
    return test;
  }

  @Override
  public Node getContinueTarget() {
    return test;
  }
}
