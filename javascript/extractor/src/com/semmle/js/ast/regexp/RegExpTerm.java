package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceElement;
import com.semmle.js.ast.SourceLocation;

/** Common superclass of all regular expression AST nodes. */
public abstract class RegExpTerm extends SourceElement {
  private final String type;

  public RegExpTerm(SourceLocation loc, String type) {
    super(loc);
    this.type = type;
  }

  /** Accept a visitor object. */
  public abstract void accept(Visitor v);

  /** The type of this regular expression AST node. */
  public String getType() {
    return type;
  }
}
