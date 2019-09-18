package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/** A non-nullable type such as <code>!string</code>. */
public class NonNullableType extends UnaryTypeConstructor {
  public NonNullableType(SourceLocation loc, JSDocTypeExpression expression, Boolean prefix) {
    super(loc, "NonNullableType", expression, prefix, "!");
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
