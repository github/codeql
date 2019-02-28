package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A shorthand character class escape such as <code>\w</code> or <code>\S</code>. */
public class CharacterClassEscape extends RegExpTerm {
  private final String classIdentifier, raw;

  public CharacterClassEscape(SourceLocation loc, String classIdentifier, String raw) {
    super(loc, "CharacterClassEscape");
    this.classIdentifier = classIdentifier;
    this.raw = raw;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** The character class identifier. */
  public String getClassIdentifier() {
    return classIdentifier;
  }

  /** The source text of the character class escape. */
  public String getRaw() {
    return raw;
  }
}
