package com.semmle.js.ast;

/** Common superclass of all statements. */
public abstract class Statement extends Node {
  public Statement(String type, SourceLocation loc) {
    super(type, loc);
  }
}
