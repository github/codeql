package com.semmle.js.ast.regexp;

/** Visitor interface for {@link RegExpTerm}. */
public interface Visitor {
  public void visit(Caret nd);

  public void visit(Constant nd);

  public void visit(Dollar nd);

  public void visit(Group nd);

  public void visit(NonWordBoundary nd);

  public void visit(Opt nd);

  public void visit(Plus nd);

  public void visit(Range nd);

  public void visit(Sequence nd);

  public void visit(Star nd);

  public void visit(WordBoundary nd);

  public void visit(Disjunction nd);

  public void visit(ZeroWidthPositiveLookahead nd);

  public void visit(ZeroWidthNegativeLookahead nd);

  public void visit(Dot nd);

  public void visit(DecimalEscape nd);

  public void visit(HexEscapeSequence nd);

  public void visit(OctalEscape nd);

  public void visit(UnicodeEscapeSequence nd);

  public void visit(BackReference nd);

  public void visit(ControlEscape nd);

  public void visit(IdentityEscape nd);

  public void visit(ControlLetter nd);

  public void visit(CharacterClassEscape nd);

  public void visit(CharacterClass nd);

  public void visit(CharacterClassRange nd);

  public void visit(NamedBackReference nd);

  public void visit(ZeroWidthPositiveLookbehind nd);

  public void visit(ZeroWidthNegativeLookbehind nd);

  public void visit(UnicodePropertyEscape nd);
}
