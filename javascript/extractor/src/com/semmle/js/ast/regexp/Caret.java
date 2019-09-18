package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A start-of-line assertion. */
public class Caret extends RegExpTerm {
  public Caret(SourceLocation loc) {
    super(loc, "Caret");
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
