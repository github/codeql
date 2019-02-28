package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/** A type expression in parentheses, such as <tt>("foo" | "bar")</tt>. */
public class ParenthesizedTypeExpr extends TypeExpression {
  private final ITypeExpression elementType;

  public ParenthesizedTypeExpr(SourceLocation loc, ITypeExpression elementType) {
    super("ParenthesizedTypeExpr", loc);
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
