package com.semmle.js.ast.jsx;

import com.semmle.js.ast.Expression;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

public class JSXSpreadAttribute extends Node implements IJSXAttribute {
  private final Expression argument;

  public JSXSpreadAttribute(SourceLocation loc, Expression argument) {
    super("JSXSpreadAttribute", loc);
    this.argument = argument;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  public Expression getArgument() {
    return argument;
  }
}
