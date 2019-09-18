package com.semmle.js.ast;

/** Common superclass of all AST node types. */
public abstract class Node extends SourceElement implements INode {
  private final String type;

  public Node(String type, SourceLocation loc) {
    super(loc);
    this.type = type;
  }

  public final String getType() {
    return type;
  }
}
