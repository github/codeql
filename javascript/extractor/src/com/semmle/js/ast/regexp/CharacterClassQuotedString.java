package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/**
 * A '\q{}' escape sequence in a regular expression, which is a special extension
 * to standard regular expressions.
 */
public class CharacterClassQuotedString extends RegExpTerm {
  private final RegExpTerm term;

  public CharacterClassQuotedString(SourceLocation loc, RegExpTerm term) {
    super(loc, "CharacterClassQuotedString");
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
