package com.semmle.js.ast;

public class XMLAnyName extends Expression {
  public XMLAnyName(SourceLocation loc) {
    super("XMLAnyName", loc);
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }
}
