package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

/** A sequence of regular expression terms. */
public class Sequence extends RegExpTerm {
  private final List<RegExpTerm> elements;

  public Sequence(SourceLocation loc, List<RegExpTerm> elements) {
    super(loc, "Sequence");
    this.elements = elements;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** The individual elements of this sequence. */
  public List<RegExpTerm> getElements() {
    return elements;
  }
}
