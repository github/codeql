package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** An any-character wildcard. */
public class Dot extends RegExpTerm {
  public Dot(SourceLocation loc) {
    super(loc, "Dot");
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
