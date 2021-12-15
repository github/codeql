package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A non-empty repetition quantifier such as <code>a+</code>. */
public class Plus extends Quantifier {
  public Plus(SourceLocation loc, RegExpTerm operand, Boolean greedy) {
    super(loc, "Plus", operand, greedy);
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
