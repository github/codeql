package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/** An optional type like <code>=number</code>. */
public class OptionalType extends UnaryTypeConstructor {
  public OptionalType(SourceLocation loc, JSDocTypeExpression expression) {
    super(loc, "OptionalType", expression, false, "=");
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
