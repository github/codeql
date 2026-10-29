package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A zero-width positive lookbehind assertion of the form <code>(?&lt;=p)</code>. */
public class ZeroWidthPositiveLookbehind extends RegExpTerm {
  private final RegExpTerm operand;

  public ZeroWidthPositiveLookbehind(SourceLocation loc, RegExpTerm operand) {
    super(loc, "ZeroWidthPositiveLookbehind");
    this.operand = operand;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** The operand of this negative lookbehind assertion. */
  public RegExpTerm getOperand() {
    return operand;
  }
}
