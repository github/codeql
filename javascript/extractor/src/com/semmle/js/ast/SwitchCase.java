package com.semmle.js.ast;

import java.util.List;

/** A case in a switch statement; may be a default case. */
public class SwitchCase extends Statement {
  private final Expression test;
  private final List<Statement> consequent;

  public SwitchCase(SourceLocation loc, Expression test, List<Statement> consequent) {
    super("SwitchCase", loc);
    this.test = test;
    this.consequent = consequent;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** Does this case have a test expression? */
  public boolean hasTest() {
    return test != null;
  }

  /** The test expression of this case; is null for default cases. */
  public Expression getTest() {
    return test;
  }

  /** The statements belonging to this case. */
  public List<Statement> getConsequent() {
    return consequent;
  }

  /** Is this a default case? */
  public boolean isDefault() {
    return !hasTest();
  }
}
