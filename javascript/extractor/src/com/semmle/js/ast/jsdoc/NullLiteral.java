package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/** The null type. */
public class NullLiteral extends JSDocTypeExpression {
  public NullLiteral(SourceLocation loc) {
    super(loc, "NullLiteral");
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  @Override
  public String pp() {
    return "null";
  }
}
