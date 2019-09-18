package com.semmle.js.ast;

import java.util.ArrayList;
import java.util.List;

/** An object pattern. */
public class ObjectPattern extends Expression implements DestructuringPattern {
  private final List<Property> rawProperties, properties;
  private final Expression restPattern;

  public ObjectPattern(SourceLocation loc, List<Property> properties) {
    super("ObjectPattern", loc);
    this.rawProperties = properties;
    this.properties = new ArrayList<Property>(properties.size());
    Expression rest = null;
    for (Property prop : properties) {
      Expression val = prop.getValue();
      if (val instanceof RestElement) {
        rest = ((RestElement) val).getArgument();
      } else {
        this.properties.add(prop);
      }
    }
    this.restPattern = rest;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The property patterns in this literal. */
  public List<Property> getProperties() {
    return properties;
  }

  /** Does this object pattern have a rest pattern? */
  public boolean hasRest() {
    return restPattern != null;
  }

  /** The rest pattern of this literal, if any. */
  public Expression getRest() {
    return restPattern;
  }

  /**
   * The raw property patterns in this literal; the rest pattern (if any) is represented as a {@link
   * RestElement}.
   */
  public List<Property> getRawProperties() {
    return rawProperties;
  }
}
