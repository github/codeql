package com.semmle.js.ast;

public class AwaitExpression extends Expression {
  private Expression argument;

  public AwaitExpression(SourceLocation loc, Expression argument) {
    super("AwaitExpression", loc);
    this.argument = argument;
  }

  public Expression getArgument() {
    return argument;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
