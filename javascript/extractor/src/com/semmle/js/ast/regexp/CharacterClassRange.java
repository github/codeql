package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A character range in a character class. */
public class CharacterClassRange extends RegExpTerm {
  private final RegExpTerm left, right;

  public CharacterClassRange(SourceLocation loc, RegExpTerm left, RegExpTerm right) {
    super(loc, "CharacterClassRange");
    this.left = left;
    this.right = right;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** The left hand side of the character range. */
  public RegExpTerm getLeft() {
    return left;
  }

  /** The right hand side of the character range. */
  public RegExpTerm getRight() {
    return right;
  }
}
