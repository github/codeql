package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/** The undefined type. */
public class UndefinedLiteral extends JSDocTypeExpression {
  public UndefinedLiteral(SourceLocation loc) {
    super(loc, "UndefinedLiteral");
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  @Override
  public String pp() {
    return "undefined";
  }
}
