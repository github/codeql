package com.semmle.js.ast;

public class XMLQualifiedIdentifier extends Expression {
  final Expression left, right;
  final boolean computed;

  public XMLQualifiedIdentifier(
      SourceLocation loc, Expression left, Expression right, boolean computed) {
    super("XMLQualifiedIdentifier", loc);
    this.left = left;
    this.right = right;
    this.computed = computed;
  }

  public Expression getLeft() {
    return left;
  }

  public Expression getRight() {
    return right;
  }

  public boolean isComputed() {
    return computed;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
