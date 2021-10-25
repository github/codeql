package com.semmle.js.ast;

/**
 * A unary expression such as <code>!x</code> or <code>void(0)</code>.
 *
 * <p>Note that increment and decrement expressions are represented by {@link UpdateExpression}.
 */
public class UnaryExpression extends Expression {
  private final String operator;
  private final Expression argument;
  private final boolean prefix;

  public UnaryExpression(SourceLocation loc, String operator, Expression argument, Boolean prefix) {
    super("UnaryExpression", loc);
    this.operator = operator;
    this.argument = argument;
    this.prefix = prefix == Boolean.TRUE;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The operator of this unary expression. */
  public String getOperator() {
    return operator;
  }

  /** The argument of this unary expression. */
  public Expression getArgument() {
    return argument;
  }

  /** Is the operator of this unary expression a prefix operator? */
  public boolean isPrefix() {
    return prefix;
  }
}
