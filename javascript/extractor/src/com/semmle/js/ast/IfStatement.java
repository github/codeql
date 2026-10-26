package com.semmle.js.ast;

/** An if statement. */
public class IfStatement extends Statement {
  private final Expression test;
  private final Statement consequent, alternate;

  public IfStatement(
      SourceLocation loc, Expression test, Statement consequent, Statement alternate) {
    super("IfStatement", loc);
    this.test = test;
    this.consequent = consequent;
    this.alternate = alternate;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The test expression of this if statement. */
  public Expression getTest() {
    return test;
  }

  /** The then-branch of this if statement. */
  public Statement getConsequent() {
    return consequent;
  }

  /** The else-branch of this if statement; may be null. */
  public Statement getAlternate() {
    return alternate;
  }

  /** Does this if statement have an else branch? */
  public boolean hasAlternate() {
    return alternate != null;
  }
}
