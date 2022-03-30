package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A range quantifier. */
public class Range extends Quantifier {
  private final Long lowerBound, upperBound;

  public Range(SourceLocation loc, RegExpTerm operand, Boolean greedy, Double lo, Double hi) {
    super(loc, "Range", operand, greedy);
    this.lowerBound = lo.longValue();
    this.upperBound = hi == null ? null : hi.longValue();
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** Get the lower bound of this quantifier. */
  public Long getLowerBound() {
    return lowerBound;
  }

  /** Does this range quantifier have an upper bound? */
  public boolean hasUpperBound() {
    return upperBound != null;
  }

  /** The upper bound of this quantifier; may be null. */
  public Long getUpperBound() {
    return upperBound;
  }
}
