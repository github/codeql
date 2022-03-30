package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A Unicode property escape such as <code>\p{Number}</code> or <code>\p{Script=Greek}</code>. */
public class UnicodePropertyEscape extends RegExpTerm {
  private final String name, value, raw;

  public UnicodePropertyEscape(SourceLocation loc, String name, String value, String raw) {
    super(loc, "UnicodePropertyEscape");
    this.name = name;
    this.value = value;
    this.raw = raw;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** The name of the property. */
  public String getName() {
    return name;
  }

  /** Does this property have a value? */
  public boolean hasValue() {
    return value != null;
  }

  /** The value of the property if any. */
  public String getValue() {
    return value;
  }

  /** The source text of the Unicode property escape. */
  public String getRaw() {
    return raw;
  }
}
