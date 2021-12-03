package com.semmle.js.ast.jsx;

import com.semmle.js.ast.INode;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

public class JSXAttribute extends Node implements IJSXAttribute {
  private final IJSXName name;
  private final INode value;

  public JSXAttribute(SourceLocation loc, IJSXName name, INode value) {
    super("JSXAttribute", loc);
    this.name = name;
    this.value = value;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  public IJSXName getName() {
    return name;
  }

  public INode getValue() {
    return value;
  }
}
