package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A zero-width negative lookahead assertion of the form <code>(?!p)</code>. */
public class ZeroWidthNegativeLookahead extends RegExpTerm {
  private final RegExpTerm operand;

  public ZeroWidthNegativeLookahead(SourceLocation loc, RegExpTerm operand) {
    super(loc, "ZeroWidthNegativeLookahead");
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
