package com.semmle.js.ast.jsx;

import com.semmle.js.ast.Node;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;
import java.util.List;

public class JSXOpeningElement extends Node implements JSXBoundaryElement {
  private final IJSXName name;
  private final List<IJSXAttribute> attributes;
  private final boolean selfClosing;

  public JSXOpeningElement(
      SourceLocation loc, IJSXName name, List<IJSXAttribute> attributes, boolean selfClosing) {
    super("JSXOpeningElement", loc);
    this.name = name;
    this.attributes = attributes;
    this.selfClosing = selfClosing;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  @Override
  public IJSXName getName() {
    return name;
  }

  public List<IJSXAttribute> getAttributes() {
    return attributes;
  }

  public boolean isSelfClosing() {
    return selfClosing;
  }
}
