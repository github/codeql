package com.semmle.js.ast.jsx;

import com.semmle.js.ast.Node;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

public class JSXClosingElement extends Node implements JSXBoundaryElement {
  private final IJSXName name;

  public JSXClosingElement(SourceLocation loc, IJSXName name) {
    super("JSXClosingElement", loc);
    this.name = name;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  @Override
  public IJSXName getName() {
    return name;
  }
}
