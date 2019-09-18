package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/** A type annotation of form <tt>infer R</tt> */
public class InferTypeExpr extends TypeExpression {
  private TypeParameter typeParameter;

  public InferTypeExpr(SourceLocation loc, TypeParameter typeParameter) {
    super("InferTypeExpr", loc);
    this.typeParameter = typeParameter;
  }

  public TypeParameter getTypeParameter() {
    return typeParameter;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
