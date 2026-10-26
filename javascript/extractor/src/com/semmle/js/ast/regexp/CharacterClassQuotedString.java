package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/**
 * A quoted string escape sequence '\q{}' in a regular expression.
 * This feature is a non-standard extension that requires the 'v' flag.
 * 
 * Example: [\q{abc|def}] creates a character class that matches either the string
 * "abc" or "def". Within the quoted string, only the alternation operator '|' is supported.
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
