package com.semmle.js.ast;

import java.util.List;

/** A switch statement. */
public class SwitchStatement extends Statement {
  private final Expression discriminant;
  private final List<SwitchCase> cases;

  public SwitchStatement(SourceLocation loc, Expression discriminant, List<SwitchCase> cases) {
    super("SwitchStatement", loc);
    this.discriminant = discriminant;
    this.cases = cases;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The expression whose value is examined. */
  public Expression getDiscriminant() {
    return discriminant;
  }

  /** The cases in this switch statement. */
  public List<SwitchCase> getCases() {
    return cases;
  }
}
