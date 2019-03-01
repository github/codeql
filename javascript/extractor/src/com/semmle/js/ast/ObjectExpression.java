package com.semmle.js.ast;

import java.util.List;

/** An object literal. */
public class ObjectExpression extends Expression {
  private final List<Property> properties;

  public ObjectExpression(SourceLocation loc, List<Property> properties) {
    super("ObjectExpression", loc);
    this.properties = properties;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The properties in this literal. */
  public List<Property> getProperties() {
    return properties;
  }
}
