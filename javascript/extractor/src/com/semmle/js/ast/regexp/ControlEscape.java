package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A control character escape. */
public class ControlEscape extends EscapeSequence {
  public ControlEscape(SourceLocation loc, String value, Number codepoint, String raw) {
    super(loc, "ControlEscape", value, codepoint, raw);
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
