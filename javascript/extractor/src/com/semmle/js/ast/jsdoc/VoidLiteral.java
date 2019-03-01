package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/** The void type. */
public class VoidLiteral extends JSDocTypeExpression {
  public VoidLiteral(SourceLocation loc) {
    super(loc, "VoidLiteral");
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  @Override
  public String pp() {
    return "void";
  }
}
