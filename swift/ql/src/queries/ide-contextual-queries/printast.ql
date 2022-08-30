/**
 * @name Print AST
 * @description Outputs a representation of a file's Abstract Syntax Tree. This
 *              query is used by the VS Code extension.
 * @id swift/print-ast
 * @kind graph
 * @tags ide-contextual-queries/print-ast
 */

import swift
import codeql.swift.printast.PrintAst
import IDEContextual

/**
 * The source file to generate an AST from.
 */
external string selectedSourceFile();

class PrintAstConfigurationOverride extends PrintAstConfiguration {
  /**
   * Holds if the location matches the selected file in the VS Code extension and
   * the element is `fromSource`.
   */
  override predicate shouldPrint(Locatable e) {
    super.shouldPrint(e) and
    e.getFile() = getFileBySourceArchiveName(selectedSourceFile())
  }
}
