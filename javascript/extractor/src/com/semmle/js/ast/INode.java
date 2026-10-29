package com.semmle.js.ast;

/** The common interface implemented by all AST node types. */
public interface INode extends ISourceElement {
  /** Accept a visitor object. */
  public <C, R> R accept(Visitor<C, R> v, C c);

  /** Return the node's type tag. */
  public String getType();
}
