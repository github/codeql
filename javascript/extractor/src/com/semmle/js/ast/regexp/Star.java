package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A possibly empty repetition. */
public class Star extends Quantifier {
  public Star(SourceLocation loc, RegExpTerm operand, Boolean greedy) {
    super(loc, "Star", operand, greedy);
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
