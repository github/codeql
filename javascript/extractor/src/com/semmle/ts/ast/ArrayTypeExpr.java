package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/**
 * An array type, such as <tt>number[]</tt>, or in general <tt>T[]</tt> where <tt>T</tt> is a type.
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
