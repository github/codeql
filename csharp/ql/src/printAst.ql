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
   * Holds if the AST for `func` should be printed.
   * Print All functions from the selected file.
   */
  override predicate shouldPrint(Element elem) {
    elem.getFile() = getEncodedFile(selectedSourceFile())
  }

  override predicate selectedFile(File f)
  {
    f = getEncodedFile(selectedSourceFile())
  }
}
