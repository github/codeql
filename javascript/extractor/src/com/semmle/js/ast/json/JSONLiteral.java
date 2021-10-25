package com.semmle.js.ast.json;

import com.semmle.js.ast.SourceLocation;

/** A JSON literal: one of null, true, false, a string, or a number. */
public class JSONLiteral extends JSONValue {
  private final Object value;
  private final String raw;

  public JSONLiteral(SourceLocation loc, Object value) {
    super("Literal", loc);
    this.value = value;
    this.raw = loc.getSource();
  }

  /** The value of the literal. */
  public Object getValue() {
    return value;
  }

  /** The value of the literal as a string. */
  public String getStringValue() {
    return String.valueOf(value);
  }

  /** The source text of the literal. */
  public String getRaw() {
    return raw;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  @Override
  public String toString() {
    return raw;
  }
}
