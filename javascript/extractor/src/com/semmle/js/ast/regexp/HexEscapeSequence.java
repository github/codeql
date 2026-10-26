package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A hexadecimal character escape sequence. */
public class HexEscapeSequence extends EscapeSequence {
  public HexEscapeSequence(SourceLocation loc, String value, Double codepoint, String raw) {
    super(loc, "HexEscapeSequence", value, codepoint, raw);
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
