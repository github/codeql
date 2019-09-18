package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A back reference to a named capture group. */
public class NamedBackReference extends RegExpTerm {
  private final String name;
  private final String raw;

  public NamedBackReference(SourceLocation loc, String name, String raw) {
    super(loc, "NamedBackReference");
    this.name = name;
    this.raw = raw;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** The name of the capture group referenced. */
  public String getName() {
    return name;
  }

  /** The source text of the back reference. */
  public String getRaw() {
    return raw;
  }
}
