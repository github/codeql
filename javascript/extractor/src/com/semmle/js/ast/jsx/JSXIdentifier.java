package com.semmle.js.ast.jsx;

import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.SourceLocation;
import com.semmle.js.ast.Visitor;

public class JSXIdentifier extends Identifier implements IJSXName {
  public JSXIdentifier(SourceLocation loc, String name) {
    super(loc, name);
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  @Override
  public String getQualifiedName() {
    return getName();
  }
}
