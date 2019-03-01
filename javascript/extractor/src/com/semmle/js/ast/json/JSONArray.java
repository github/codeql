package com.semmle.js.ast.json;

import com.semmle.js.ast.SourceLocation;
import java.util.List;

/** A JSON array. */
public class JSONArray extends JSONValue {
  private final List<JSONValue> elements;

  public JSONArray(SourceLocation loc, List<JSONValue> elements) {
    super("Array", loc);
    this.elements = elements;
  }

  /** The elements of the array. */
  public List<JSONValue> getElements() {
    return elements;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  @Override
  public String toString() {
    StringBuilder res = new StringBuilder("[");
    String sep = "";
    for (JSONValue element : elements) {
      res.append(sep);
      res.append(element.toString());
      sep = ", ";
    }
    res.append("]");
    return res.toString();
  }
}
