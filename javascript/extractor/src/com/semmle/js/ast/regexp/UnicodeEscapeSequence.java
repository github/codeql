package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A Unicode escape sequence. */
public class UnicodeEscapeSequence extends EscapeSequence {
  public UnicodeEscapeSequence(SourceLocation loc, String value, Double codepoint, String raw) {
    super(loc, "UnicodeEscapeSequence", value, codepoint, raw);
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
