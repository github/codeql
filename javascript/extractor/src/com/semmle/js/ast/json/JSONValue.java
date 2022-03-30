package com.semmle.js.ast.json;

import com.semmle.js.ast.SourceElement;
import com.semmle.js.ast.SourceLocation;

/** Common superclass for representing JSON values. */
public abstract class JSONValue extends SourceElement {
  private final String type;

  public JSONValue(String type, SourceLocation loc) {
    super(loc);
    this.type = type;
  }

  /** The type of the value. */
  public String getType() {
    return type;
  }

  /** Accept a visitor object. */
  public abstract <C, R> R accept(Visitor<C, R> v, C c);
}
