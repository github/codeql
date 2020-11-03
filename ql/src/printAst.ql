/**
 * @name Print AST
 * @description Produces a representation of a file's Abstract Syntax Tree.
 *              This query is used by the VS Code extension.
 * @id ruby/print-ast
 * @kind graph
 * @tags ide-contextual-queries/print-ast
 */

import codeql_ruby.printAst

/**
 * The source file to generate an AST from.
 */
external string selectedSourceFile();

/**
 * Returns an appropriately encoded version of a filename `name`
 * passed by the VS Code extension in order to coincide with the
 * output of `.getFile()` on locatable entities.
 */
cached
File getEncodedFile(string name) { result.getAbsolutePath().replaceAll(":", "_") = name }

/**
 * Overrides the configuration to print only nodes in the selected source file.
 */
class Cfg extends PrintAstConfiguration {
  override predicate shouldPrintNode(AstNode n) {
    n.getLocation().getFile() = getEncodedFile(selectedSourceFile())
  }
}
