package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A zero-width positive lookahead assertion of the form <code>(?=p)</code>. */
public class ZeroWidthPositiveLookahead extends RegExpTerm {
  private final RegExpTerm operand;

  public ZeroWidthPositiveLookahead(SourceLocation loc, RegExpTerm operand) {
    super(loc, "ZeroWidthPositiveLookahead");
    this.operand = operand;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** The operand of this negative lookahead assertion. */
  public RegExpTerm getOperand() {
    return operand;
  }
}
