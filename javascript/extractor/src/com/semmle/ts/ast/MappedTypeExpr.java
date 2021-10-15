package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/**
 * A type of form <code>{ [K in C]: T }</code>, where <code>T</code> is a type that may refer to <code>K</code>.
 *
 * <p>As with the TypeScript AST, the <code>K in C</code> part is represented as a type parameter with
 * <code>C</code> as its upper bound.
 */
public class MappedTypeExpr extends TypeExpression {
  private final TypeParameter typeParameter;
  private final ITypeExpression elementType;

  public MappedTypeExpr(
      SourceLocation loc, TypeParameter typeParameter, ITypeExpression elementType) {
    super("MappedTypeExpr", loc);
    this.typeParameter = typeParameter;
    this.elementType = elementType;
  }

  public TypeParameter getTypeParameter() {
    return typeParameter;
  }

  public ITypeExpression getElementType() {
    return elementType;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
