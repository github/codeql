package com.semmle.ts.ast;

import com.semmle.js.ast.FunctionExpression;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

public class FunctionTypeExpr extends TypeExpression {
  private final FunctionExpression function;
  private final boolean isConstructor;

  public FunctionTypeExpr(SourceLocation loc, FunctionExpression function, boolean isConstructor) {
    super("FunctionTypeExpr", loc);
    this.function = function;
    this.isConstructor = isConstructor;
  }

  public FunctionExpression getFunction() {
    return function;
  }

  public boolean isConstructor() {
    return isConstructor;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
