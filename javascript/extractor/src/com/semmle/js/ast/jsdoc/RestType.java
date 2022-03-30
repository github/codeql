package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/** A rest type expression like <code>...string</code>. */
public class RestType extends UnaryTypeConstructor {
  public RestType(SourceLocation loc, JSDocTypeExpression expression) {
    super(loc, "RestType", expression, true, "...");
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
