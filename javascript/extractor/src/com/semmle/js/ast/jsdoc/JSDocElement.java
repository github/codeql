package com.semmle.js.ast.jsdoc;

import com.semmle.js.ast.SourceElement;
import com.semmle.js.ast.SourceLocation;

/** Common superclass of all JSDoc AST nodes. */
public abstract class JSDocElement extends SourceElement {
  public JSDocElement(SourceLocation loc) {
    super(loc);
  }

  /** Accept a visitor object. */
  public abstract void accept(Visitor v);
}
