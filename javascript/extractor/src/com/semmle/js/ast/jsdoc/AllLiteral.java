package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/** A dont-care type expression <code>*</code>. */
public class AllLiteral extends JSDocTypeExpression {
  public AllLiteral(SourceLocation loc) {
    super(loc, "AllLiteral");
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  @Override
  public String pp() {
    return "*";
  }
}
