package com.semmle.js.ast.jsx;

import com.semmle.js.ast.Expression;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

public class JSXNamespacedName extends Expression implements IJSXName {
  private final JSXIdentifier namespace, name;

  public JSXNamespacedName(SourceLocation loc, JSXIdentifier namespace, JSXIdentifier name) {
    super("JSXNamespacedName", loc);
    this.namespace = namespace;
    this.name = name;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  @Override
  public String getQualifiedName() {
    return namespace.getName() + ":" + name.getName();
  }

  public JSXIdentifier getNamespace() {
    return namespace;
  }

  public JSXIdentifier getName() {
    return name;
  }
}
