package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A quantifier, that is, one of {@link Opt}, {@link Plus}, {@link Star} or {@link Range}. */
public abstract class Quantifier extends RegExpTerm {
  private final RegExpTerm operand;
  private final boolean greedy;

  public Quantifier(SourceLocation loc, String type, RegExpTerm operand, Boolean greedy) {
    super(loc, type);
    this.operand = operand;
    this.greedy = greedy == Boolean.TRUE;
  }

  /** The quantified term. */
  public RegExpTerm getOperand() {
    return operand;
  }

  /** Is this a greedy quantifier? */
  public boolean isGreedy() {
    return greedy;
  }
}
