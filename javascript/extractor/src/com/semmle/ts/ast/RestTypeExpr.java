package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/** A rest type in a tuple type, such as <code>number[]</code> in <code>[string, ...number[]]</code>. */
public class RestTypeExpr extends TypeExpression {
  private final ITypeExpression arrayType;

  public RestTypeExpr(SourceLocation loc, ITypeExpression arrayType) {
    super("RestTypeExpr", loc);
    this.arrayType = arrayType;
  }

  public ITypeExpression getArrayType() {
    return arrayType;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
