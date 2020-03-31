package com.semmle.js.ast;

/**
 * A meta property access (cf. ECMAScript 2015 Language Specification, Chapter 12.3.8).
 *
 * <p>Currently the only recognised meta properties are <code>new.target</code>, 
 * <code>import.meta</code> and <code> function.sent</code>.
 */
public class MetaProperty extends Expression {
  private final Identifier meta, property;

  public MetaProperty(SourceLocation loc, Identifier meta, Identifier property) {
    super("MetaProperty", loc);
    this.meta = meta;
    this.property = property;
  }

  public Identifier getMeta() {
    return meta;
  }

  public Identifier getProperty() {
    return property;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
