package com.semmle.js.ast;

public class BindExpression extends Expression {
  private final Expression object, callee;

  public BindExpression(SourceLocation loc, Expression object, Expression callee) {
    super("BindExpression", loc);
    this.object = object;
    this.callee = callee;
  }

  public boolean hasObject() {
    return object != null;
  }

  public Expression getObject() {
    return object;
  }

  public Expression getCallee() {
    return callee;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
