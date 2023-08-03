/**
 * @name Print AST
 * @description Outputs a representation of the Abstract Syntax Tree.
 * @id cpp/print-ast
 * @kind graph
 */

import cpp
import PrintAST

/**
 * Temporarily tweak this class or make a copy to control which declarations are
 * printed.
 */
class Cfg extends PrintAstConfiguration {
  /**
   * TWEAK THIS PREDICATE AS NEEDED.
   * Holds if the AST for `decl` should be printed.
   */
  override predicate shouldPrintDeclaration(Declaration decl) { any() }
}
