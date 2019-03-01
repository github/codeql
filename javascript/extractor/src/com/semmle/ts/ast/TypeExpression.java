package com.semmle.ts.ast;

import com.semmle.js.ast.Node;
import com.semmle.js.ast.SourceLocation;

/**
 * An AST node that may occur as part of a TypeScript type annotation and is not also an expression.
 */
public abstract class TypeExpression extends Node implements ITypeExpression {
  private int staticTypeId = -1;

  public TypeExpression(String type, SourceLocation loc) {
    super(type, loc);
  }

  @Override
  public int getStaticTypeId() {
    return staticTypeId;
  }

  @Override
  public void setStaticTypeId(int staticTypeId) {
    this.staticTypeId = staticTypeId;
  }
}
