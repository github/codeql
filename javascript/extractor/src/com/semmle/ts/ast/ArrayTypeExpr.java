package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/**
 * An array type, such as <code>number[]</code>, or in general <code>T[]</code> where <code>T</code> is a type.
 */
public class ArrayTypeExpr extends TypeExpression {
  private final ITypeExpression elementType;

  public ArrayTypeExpr(SourceLocation loc, ITypeExpression elementType) {
    super("ArrayTypeExpr", loc);
    this.elementType = elementType;
  }

  public ITypeExpression getElementType() {
    return elementType;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
