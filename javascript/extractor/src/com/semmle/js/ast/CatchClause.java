package com.semmle.js.ast;

/** A catch clause with or without a guarding expression. */
public class CatchClause extends Statement {
  private final IPattern param;
  private final Expression guard;
  private final BlockStatement body;

  public CatchClause(SourceLocation loc, IPattern param, Expression guard, BlockStatement body) {
    super("CatchClause", loc);
    this.param = param;
    this.guard = guard;
    this.body = body;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The parameter of the catch clause. */
  public IPattern getParam() {
    return param;
  }

  /** Does this catch clause have a guarding expression? */
  public boolean hasGuard() {
    return guard != null;
  }

  /** The guarding expression of the catch clause; may be null. */
  public Expression getGuard() {
    return guard;
  }

  /** The body of the catch clause. */
  public BlockStatement getBody() {
    return body;
  }
}
