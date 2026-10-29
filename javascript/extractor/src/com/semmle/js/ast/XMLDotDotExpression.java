package com.semmle.js.ast;

public class XMLDotDotExpression extends Expression {
  final Expression left, right;

  public XMLDotDotExpression(SourceLocation loc, Expression left, Expression right) {
    super("XMLDotDotExpression", loc);
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
