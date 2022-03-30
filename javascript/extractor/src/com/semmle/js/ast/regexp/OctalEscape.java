package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** An octal character escape sequence. */
public class OctalEscape extends EscapeSequence {
  public OctalEscape(SourceLocation loc, String value, Double codepoint, String raw) {
    super(loc, "OctalEscape", value, codepoint, raw);
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
