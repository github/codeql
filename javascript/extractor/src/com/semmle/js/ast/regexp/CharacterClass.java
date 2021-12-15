package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

/** A character class. */
public class CharacterClass extends RegExpTerm {
  private final List<RegExpTerm> elements;
  private final boolean inverted;

  public CharacterClass(SourceLocation loc, List<RegExpTerm> elements, Boolean inverted) {
    super(loc, "CharacterClass");
    this.elements = elements;
    this.inverted = inverted == Boolean.TRUE;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** The elements of this character class. */
  public List<RegExpTerm> getElements() {
    return elements;
  }

  /** Is this an inverted character class? */
  public boolean isInverted() {
    return inverted;
  }
}
