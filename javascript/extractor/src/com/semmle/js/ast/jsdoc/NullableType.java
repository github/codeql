package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/** A nullable like <code>string?</code>. */
public class NullableType extends UnaryTypeConstructor {
  public NullableType(SourceLocation loc, JSDocTypeExpression expression, Boolean prefix) {
    super(loc, "NullableType", expression, prefix, "?");
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
