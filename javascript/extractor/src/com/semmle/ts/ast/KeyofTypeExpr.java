package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/** A type of form <tt>keyof T</tt> where <tt>T</tt> is a type. */
public class KeyofTypeExpr extends TypeExpression {
  private final ITypeExpression elementType;

  public KeyofTypeExpr(SourceLocation loc, ITypeExpression elementType) {
    super("KeyofTypeExpr", loc);
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
