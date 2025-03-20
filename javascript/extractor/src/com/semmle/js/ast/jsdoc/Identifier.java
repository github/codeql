package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/** An identifier in a JSDoc type. */
public class Identifier extends JSDocTypeExpression {
  private final String name;

  public Identifier(SourceLocation loc, String name) {
    super(loc, "Identifier");
    this.name = name;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** The type name. */
  public String getName() {
    return name;
  }

  @Override
  public String pp() {
    return name;
  }
}
