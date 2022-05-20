package com.semmle.js.ast.jsx;

import com.semmle.js.ast.ThisExpression;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

public class JSXThisExpr extends ThisExpression implements IJSXName {
  public JSXThisExpr(SourceLocation loc) {
    super(loc);
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  @Override
  public String getQualifiedName() {
    return "this";
  }
}
