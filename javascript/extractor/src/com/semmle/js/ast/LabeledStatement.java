package com.semmle.js.ast;

/** A labeled statement. */
public class LabeledStatement extends Statement {
  private final Identifier label;
  private final Statement body;

  public LabeledStatement(SourceLocation loc, Identifier label, Statement body) {
    super("LabeledStatement", loc);
    this.label = label;
    this.body = body;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The label of the labeled statement. */
  public Identifier getLabel() {
    return label;
  }

  /** The statement wrapped by this labeled statement. */
  public Statement getBody() {
    return body;
  }
}
