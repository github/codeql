package com.semmle.js.ast;

/** A with statement. */
public class WithStatement extends Statement {
  private final Expression object;
  private final Statement body;

  public WithStatement(SourceLocation loc, Expression object, Statement body) {
    super("WithStatement", loc);
    this.object = object;
    this.body = body;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The expression put into the context chain by this with statement. */
  public Expression getObject() {
    return object;
  }

  /** The body of this with statement. */
  public Statement getBody() {
    return body;
  }
}
