package com.semmle.js.ast.json;

/**
 * Visitor interface for {@link JSONValue}.
 *
 * <p>Visit methods take a context argument of type {@link C} and return a result of type {@link R}.
 */
public interface Visitor<C, R> {
  public R visit(JSONObject nd, C c);

  public R visit(JSONArray nd, C c);

  public R visit(JSONLiteral nd, C c);
}
