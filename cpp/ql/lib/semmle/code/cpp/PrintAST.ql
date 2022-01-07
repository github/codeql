/**
 * @name Print AST
 * @description Outputs a representation of the Abstract Syntax Tree.
 * @id cpp/print-ast
 * @kind graph
 */

import cpp
import PrintAST

/**
 * Temporarily tweak this class or make a copy to control which functions are
 * printed.
 */
class Cfg extends PrintASTConfiguration {
  /**
   * TWEAK THIS PREDICATE AS NEEDED.
   * Holds if the AST for `func` should be printed.
   */
  override predicate shouldPrintFunction(Function func) { any() }
}
