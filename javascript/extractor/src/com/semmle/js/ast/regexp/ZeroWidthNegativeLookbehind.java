package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A zero-width negative lookbehind assertion of the form <code>(?&lt;!p)</code>. */
public class ZeroWidthNegativeLookbehind extends RegExpTerm {
  private final RegExpTerm operand;

  public ZeroWidthNegativeLookbehind(SourceLocation loc, RegExpTerm operand) {
    super(loc, "ZeroWidthNegativeLookbehind");
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
