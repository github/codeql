package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** An escape sequence representing a single character. */
public abstract class EscapeSequence extends Literal {
  private final String raw;
  private final int codepoint;

  public EscapeSequence(
      SourceLocation loc, String type, String value, Number codepoint, String raw) {
    super(loc, type, value);
    this.codepoint = codepoint.intValue();
    this.raw = raw;
  }

  /** The code point of the represented character. */
  public int getCodepoint() {
    return codepoint;
  }

  /** The source text of the escape sequence. */
  public String getRaw() {
    return raw;
  }
}
