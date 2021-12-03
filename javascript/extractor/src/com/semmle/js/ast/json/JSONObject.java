package com.semmle.js.ast.json;

import com.semmle.js.ast.SourceLocation;
import com.semmle.util.data.Pair;
import java.util.List;

/** A JSON object. */
public class JSONObject extends JSONValue {
  private final List<Pair<String, JSONValue>> properties;

  public JSONObject(SourceLocation loc, List<Pair<String, JSONValue>> properties) {
    super("Object", loc);
    this.properties = properties;
  }

  /** The properties of this object. */
  public List<Pair<String, JSONValue>> getProperties() {
    return properties;
  }

  @Override
  public <C, R> R accept(Visitor<C, R> v, C c) {
    return v.visit(this, c);
  }

  @Override
  public String toString() {
    StringBuilder res = new StringBuilder("{");
    String sep = "";
    for (Pair<String, JSONValue> property : properties) {
      res.append(sep);
      res.append(property.fst());
      res.append(": ");
      res.append(property.snd());
      sep = ", ";
    }
    res.append("}");
    return res.toString();
  }
}
