package com.semmle.js.ast;

/** A source code element potentially associated with a location. */
public interface ISourceElement {
  /** Get the source location of this element; may be null. */
  public SourceLocation getLoc();
}
