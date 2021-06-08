package com.semmle.ts.ast;

import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

/** A type of form <code>T[K]</code> where <code>T</code> and <code>K</code> are types. */
public class IndexedAccessTypeExpr extends TypeExpression {
  private final ITypeExpression objectType;
  private final ITypeExpression indexType;

  public IndexedAccessTypeExpr(
      SourceLocation loc, ITypeExpression objectType, ITypeExpression indexType) {
    super("IndexedAccessTypeExpr", loc);
    this.objectType = objectType;
    this.indexType = indexType;
  }

  public ITypeExpression getObjectType() {
    return objectType;
  }

  public ITypeExpression getIndexType() {
    return indexType;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
