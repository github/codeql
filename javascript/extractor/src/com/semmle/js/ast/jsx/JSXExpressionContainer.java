package com.semmle.js.ast.jsx;

import com.semmle.js.ast.INode;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

public class JSXExpressionContainer extends Node implements IJSXExpression {
  private final INode expression;

  public JSXExpressionContainer(SourceLocation loc, INode expression) {
    super("JSXExpressionContainer", loc);
    this.expression = expression;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  public INode getExpression() {
    return expression;
  }
}
