package com.semmle.ts.ast;

/** An AST node with an associated static type. */
public interface ITypedAstNode {
  /**
   * Gets the static type of this node as determined by the TypeScript compiler, or -1 if no type
   * was determined.
   *
   * <p>The ID refers to a type in a table that is extracted on a per-project basis, and the meaning
   * of this type ID is not available at the AST level.
   */
  int getStaticTypeId();

  void setStaticTypeId(int id);
}
