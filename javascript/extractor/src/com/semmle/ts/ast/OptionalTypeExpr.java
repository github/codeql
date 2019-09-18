package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/** An optional type in a tuple type, such as <tt>number?</tt> in <tt>[string, number?]</tt>. */
public class OptionalTypeExpr extends TypeExpression {
  private final ITypeExpression elementType;

  public OptionalTypeExpr(SourceLocation loc, ITypeExpression elementType) {
    super("OptionalTypeExpr", loc);
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
