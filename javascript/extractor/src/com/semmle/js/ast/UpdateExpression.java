package com.semmle.js.ast;

/** An increment or decrement expression. */
public class UpdateExpression extends Expression {
  private final String operator;
  private final Expression argument;
  private final boolean prefix;

  public UpdateExpression(
      SourceLocation loc, String operator, Expression argument, Boolean prefix) {
    super("UpdateExpression", loc);
    this.operator = operator;
    this.argument = argument;
    this.prefix = prefix == Boolean.TRUE;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The operator of this expression. */
  public String getOperator() {
    return operator;
  }

  /** The argument of this expression. */
  public Expression getArgument() {
    return argument;
  }

  /** Is this a prefix increment or decrement expression? */
  public boolean isPrefix() {
    return prefix;
  }
}
