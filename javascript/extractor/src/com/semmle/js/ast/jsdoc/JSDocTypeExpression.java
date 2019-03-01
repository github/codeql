package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceLocation;

/** Common superclass of all JSDoc type expressions. */
public abstract class JSDocTypeExpression extends JSDocElement {
  private final String type;

  public JSDocTypeExpression(SourceLocation loc, String type) {
    super(loc);
    this.type = type;
  }

  /** The type of the expression. */
  public final String getType() {
    return type;
  }

  /** A pretty-printed representation of the type. */
  public abstract String pp();
}
