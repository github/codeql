/**
 * @name Print AST
 * @description Outputs a representation of a file's Abstract Syntax Tree. This
 *              query is used by the VS Code extension.
 * @id csharp/print-ast
 * @kind graph
 * @tags ide-contextual-queries/print-ast
 */

import csharp
import semmle.code.csharp.PrintAst
import definitions

/**
 * The source file to generate an AST from.
 */
external string selectedSourceFile();

class PrintAstConfigurationOverride extends PrintAstConfiguration {
  /**
   * Holds if the location matches the selected file in the VS Code extension and
   * the element is `fromSource`.
   */
  override predicate shouldPrint(Element e, Location l) {
    super.shouldPrint(e, l) and
    l.getFile() = getEncodedFile(selectedSourceFile())
  }
}
