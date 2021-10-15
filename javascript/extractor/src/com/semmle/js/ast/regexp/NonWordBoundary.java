package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A non-word boundary assertion <code>\B</code>. */
public class NonWordBoundary extends RegExpTerm {
  public NonWordBoundary(SourceLocation loc) {
    super(loc, "NonWordBoundary");
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
