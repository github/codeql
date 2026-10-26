/**
 * @name Print AST
 * @description Produces a representation of a file's Abstract Syntax Tree.
 *              This query is used by the VS Code extension.
 * @id actions/print-ast
 * @kind graph
 * @tags ide-contextual-queries/print-ast
 */

private import codeql.actions.ideContextual.IDEContextual
import codeql.actions.ideContextual.printAst
private import codeql.actions.Ast

/**
 * The source file to generate an AST from.
 */
external string selectedSourceFile();

/**
 * A configuration that only prints nodes in the selected source file.
 */
class Cfg extends PrintAstConfiguration {
  override predicate shouldPrintNode(PrintAstNode n) {
    super.shouldPrintNode(n) and
    n instanceof PrintRegularAstNode and
    n.getLocation().getFile() = getFileBySourceArchiveName(selectedSourceFile())
  }
}
