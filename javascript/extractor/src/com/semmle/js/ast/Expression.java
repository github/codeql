package com.semmle.js.ast;

import com.semmle.ts.ast.ITypedAstNode;

/** Common superclass of all expressions. */
public abstract class Expression extends Node implements ITypedAstNode {
  private int staticTypeId = -1;

  public Expression(String type, SourceLocation loc) {
    super(type, loc);
  }

  /** This expression, but with any surrounding parentheses stripped off. */
  public Expression stripParens() {
    return this;
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
