package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A control letter escape. */
public class ControlLetter extends EscapeSequence {
  public ControlLetter(SourceLocation loc, String value, Number codepoint, String raw) {
    super(loc, "ControlLetter", value, codepoint, raw);
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }
}
