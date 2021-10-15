package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A back reference to a capture group. */
public class BackReference extends RegExpTerm {
  private final Long value;
  private final String raw;

  public BackReference(SourceLocation loc, Double value, String raw) {
    super(loc, "BackReference");
    this.value = value.longValue();
    this.raw = raw;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** The number of the capture group referenced. */
  public Long getValue() {
    return value;
  }

  /** The source text of the back reference. */
  public String getRaw() {
    return raw;
  }
}
