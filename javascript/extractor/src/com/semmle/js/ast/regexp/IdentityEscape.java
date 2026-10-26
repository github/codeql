package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** An identity escape sequence. */
public class IdentityEscape extends EscapeSequence {
  public IdentityEscape(SourceLocation loc, String value, Number codepoint, String raw) {
    super(loc, "IdentityEscape", value, codepoint, raw);
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
