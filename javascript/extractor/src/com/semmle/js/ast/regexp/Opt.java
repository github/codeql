package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** An optional quantifier such as <code>s?</code>. */
public class Opt extends Quantifier {
  public Opt(SourceLocation loc, RegExpTerm operand, Boolean greedy) {
    super(loc, "Opt", operand, greedy);
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
