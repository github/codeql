package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/** An optional type in a tuple type, such as <code>number?</code> in <code>[string, number?]</code>. */
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
