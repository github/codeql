package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A word-boundary assertion <code>\b</code>. */
public class WordBoundary extends RegExpTerm {
  public WordBoundary(SourceLocation loc) {
    super(loc, "WordBoundary");
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
