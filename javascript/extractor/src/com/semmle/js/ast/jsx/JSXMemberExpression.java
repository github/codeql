package com.semmle.js.ast.jsx;

import com.semmle.js.ast.Expression;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

public class JSXMemberExpression extends Expression implements IJSXName {
  private final IJSXName object;
  private final JSXIdentifier property;

  public JSXMemberExpression(SourceLocation loc, IJSXName object, JSXIdentifier property) {
    super("JSXMemberExpression", loc);
    this.object = object;
    this.property = property;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  @Override
  public String getQualifiedName() {
    return object.getQualifiedName() + "." + property.getName();
  }

  public IJSXName getObject() {
    return object;
  }

  public JSXIdentifier getName() {
    return property;
  }
}
