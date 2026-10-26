package com.semmle.js.ast.jsx;

import com.semmle.js.ast.Expression;
import com.semmle.js.ast.INode;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;
import java.util.List;

public class JSXElement extends Expression {
  private final JSXOpeningElement openingElement;
  private final List<INode> children;
  private final JSXClosingElement closingElement;

  public JSXElement(
      SourceLocation loc,
      JSXOpeningElement openingElement,
      List<INode> children,
      JSXClosingElement closingElement) {
    super("JSXElement", loc);
    this.openingElement = openingElement;
    this.children = children;
    this.closingElement = closingElement;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  public JSXOpeningElement getOpeningElement() {
    return openingElement;
  }

  public List<INode> getChildren() {
    return children;
  }

  public JSXClosingElement getClosingElement() {
    return closingElement;
  }
}
