/**
 * @name Print AST
 * @description Outputs a representation of the Abstract Syntax Tree.
 * @id cs/print-ast
 * @kind graph
 */

import csharp
import semmle.code.csharp.PrintAst

/**
 * Temporarily tweak this class or make a copy to control which functions are
 * printed.
 */
class PrintAstConfigurationOverride extends PrintAstConfiguration {
  /**
   * TWEAK THIS PREDICATE AS NEEDED.
   */
  override predicate shouldPrint(Element e, Location l) { super.shouldPrint(e, l) }
}
