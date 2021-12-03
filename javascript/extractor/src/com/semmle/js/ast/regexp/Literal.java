package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A regular expression subterm representing a literal string. */
public abstract class Literal extends RegExpTerm {
  private final String value;

  public Literal(SourceLocation loc, String type, String value) {
    super(loc, type);
    this.value = value;
  }

  /** The represented string. */
  public String getValue() {
    return value;
  }
}
