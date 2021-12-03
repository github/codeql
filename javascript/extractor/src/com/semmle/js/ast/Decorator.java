package com.semmle.js.ast;

public class Decorator extends Expression {
  private final Expression expression;

  public Decorator(SourceLocation loc, Expression expression) {
    super("Decorator", loc);
    this.expression = expression;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  public Expression getExpression() {
    return expression;
  }
}
