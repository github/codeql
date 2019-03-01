package com.semmle.ts.ast;

/**
 * An AST node that is associated with a TypeScript compiler symbol.
 *
 * <p>This can be the symbol for the type defined by this node, of it this is a module top-level,
 * the symbol for that module.
 */
public interface INodeWithSymbol {
  /**
   * Gets a number identifying the symbol associated with this AST node, or <tt>-1</tt> if there is
   * no such symbol.
   */
  int getSymbol();

  void setSymbol(int symbol);
}
