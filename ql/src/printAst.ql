/**
 * @name Print AST
 * @description Produces a representation of a file's Abstract Syntax Tree.
 *              This query is used by the VS Code extension.
 * @id ruby/print-ast
 * @kind graph
 * @tags ide-contextual-queries/print-ast
 */

import codeql_ruby.printAst
import codeql.files.FileSystem

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
File getFileBySourceArchiveName(string name) {
  // The name provided for a file in the source archive by the VS Code extension
  // has some differences from the absolute path in the database:
  // 1. colons are replaced by underscores
  // 2. there's a leading slash, even for Windows paths: "C:/foo/bar" ->
  //    "/C_/foo/bar"
  // 3. double slashes in UNC prefixes are replaced with a single slash
  // We can handle 2 and 3 together by unconditionally adding a leading slash
  // before replacing double slashes.
  name = ("/" + result.getAbsolutePath().replaceAll(":", "_")).replaceAll("//", "/")
}

/**
 * Overrides the configuration to print only nodes in the selected source file.
 */
class Cfg extends PrintAstConfiguration {
  override predicate shouldPrintNode(Generated::AstNode n) {
    n.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
  }
}
