/**
 * @name Print AST
 * @description Outputs a representation of a file's Abstract Syntax Tree. This
 *              query is used by the VS Code extension.
 * @id py/print-ast
 * @kind graph
 * @tags ide-contextual-queries/print-ast
 */

import python
import semmle.python.PrintAst
import analysis.DefinitionTracking

/**
 * The source file to generate an AST from.
 */
external string selectedSourceFile();

class PrintAstConfigurationOverride extends PrintAstConfiguration {
  /**
   * Holds if the location matches the selected file in the VS Code extension and
   * the element is not a synthetic constructor.
   */
  override predicate shouldPrint(AstNode e, Location l) {
    super.shouldPrint(e, l) and
    l.getFile() = getFileBySourceArchiveName(selectedSourceFile())
  }
}
