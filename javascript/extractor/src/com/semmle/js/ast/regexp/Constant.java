package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A constant character. */
public class Constant extends Literal {
  public Constant(SourceLocation loc, String value) {
    super(loc, "Constant", value);
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
