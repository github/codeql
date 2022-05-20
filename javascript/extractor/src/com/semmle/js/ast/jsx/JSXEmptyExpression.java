package com.semmle.js.ast.jsx;

import com.semmle.js.ast.Node;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

public class JSXEmptyExpression extends Node implements IJSXExpression {
  public JSXEmptyExpression(SourceLocation loc) {
    super("JSXEmptyExpression", loc);
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
