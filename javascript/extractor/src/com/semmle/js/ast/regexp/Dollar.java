package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** An end-of-line assertion. */
public class Dollar extends RegExpTerm {
  public Dollar(SourceLocation loc) {
    super(loc, "Dollar");
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
