package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/**
 * A '\q{}' escape sequence in a regular expression, which is a special extension
 * to standard regular expressions.
 */
public class StringDisjunction extends RegExpTerm {
  private final RegExpTerm term;

  public StringDisjunction(SourceLocation loc, RegExpTerm term) {
    super(loc, "StringDisjunction");
    this.term = term;
  }

  public RegExpTerm getTerm() {
    return term;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
