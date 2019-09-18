package com.semmle.js.ast;

public class XMLFilterExpression extends Expression {
  final Expression left, right;

  public XMLFilterExpression(SourceLocation loc, Expression left, Expression right) {
    super("XMLFilterExpression", loc);
    this.left = left;
    this.right = right;
  }

  public Expression getLeft() {
    return left;
  }

  public Expression getRight() {
    return right;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
