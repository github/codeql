package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/** A named JSDoc type. */
public class NameExpression extends JSDocTypeExpression {
  private final String name;

  public NameExpression(SourceLocation loc, String name) {
    super(loc, "NameExpression");
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
