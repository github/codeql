/**
 * @name Print AST
 * @description Outputs a representation of a file's Abstract Syntax Tree. This
 *              query is used by the VS Code extension.
 * @id go/print-ast
 * @kind graph
 * @tags ide-contextual-queries/print-ast
 */

import go
import semmle.go.PrintAst
import ideContextual

/**
 * The source file to generate an AST from.
 */
external string selectedSourceFile();

/**
 * Hook to customize the functions printed by this query.
 */
class Cfg extends PrintAstConfiguration {
  override predicate shouldPrintFunction(FuncDef func) {
    func.getFile() = getEncodedFile(selectedSourceFile())
  }
}
