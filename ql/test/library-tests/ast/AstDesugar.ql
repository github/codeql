/**
 * @kind graph
 */

import codeql_ruby.printAst

class DesugarPrintAstConfiguration extends PrintAstConfiguration {
  override predicate shouldPrintNode(AstNode n) { isDesugared(n) }
}
