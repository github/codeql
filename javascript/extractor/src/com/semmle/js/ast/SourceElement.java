package com.semmle.js.ast;

/** Common superclass of all source elements. */
public class SourceElement implements ISourceElement {
  private final SourceLocation loc;

  public SourceElement(SourceLocation loc) {
    this.loc = loc;
  }

  public boolean hasLoc() {
    return loc != null;
  }

  @Override
  public final SourceLocation getLoc() {
    return loc;
  }
}
