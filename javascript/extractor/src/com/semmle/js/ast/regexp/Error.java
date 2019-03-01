package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceElement;
import com.semmle.js.ast.SourceLocation;

/** An error encountered while parsing a regular expression. */
public class Error extends SourceElement {
  public static final int UNEXPECTED_EOS = 0;
  public static final int UNEXPECTED_CHARACTER = 1;
  public static final int EXPECTED_DIGIT = 2;
  public static final int EXPECTED_HEX_DIGIT = 3;
  public static final int EXPECTED_CONTROL_LETTER = 4;
  public static final int EXPECTED_CLOSING_PAREN = 5;
  public static final int EXPECTED_CLOSING_BRACE = 6;
  public static final int EXPECTED_EOS = 7;
  public static final int OCTAL_ESCAPE = 8;
  public static final int INVALID_BACKREF = 9;
  public static final int EXPECTED_RBRACKET = 10;
  public static final int EXPECTED_IDENTIFIER = 11;
  public static final int EXPECTED_CLOSING_ANGLE = 12;

  private final int code;

  public Error(SourceLocation loc, Number code) {
    super(loc);
    this.code = code.intValue();
  }

  /** The error code. */
  public int getCode() {
    return code;
  }
}
