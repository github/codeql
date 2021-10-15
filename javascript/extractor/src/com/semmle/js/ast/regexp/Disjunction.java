package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

/** A disjunctive pattern. */
public class Disjunction extends RegExpTerm {
  private final List<RegExpTerm> disjuncts;

  public Disjunction(SourceLocation loc, List<RegExpTerm> disjuncts) {
    super(loc, "Disjunction");
    this.disjuncts = disjuncts;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** The individual elements of the disjunction. */
  public List<RegExpTerm> getDisjuncts() {
    return disjuncts;
  }
}
