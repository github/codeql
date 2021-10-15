package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A decimal escape sequence. */
public class DecimalEscape extends EscapeSequence {
  public DecimalEscape(SourceLocation loc, String value, Double codepoint, String raw) {
    super(loc, "DecimalEscape", value, codepoint, raw);
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
