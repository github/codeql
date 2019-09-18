package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/** A nullable dont-care type <code>?</code>. */
public class NullableLiteral extends JSDocTypeExpression {
  public NullableLiteral(SourceLocation loc) {
    super(loc, "NullableLiteral");
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  @Override
  public String pp() {
    return "?";
  }
}
