/**
 * @kind graph
 */

import codeql_ruby.AST
import codeql_ruby.printAst
import codeql_ruby.ast.internal.Synthesis

class DesugarPrintAstConfiguration extends PrintAstConfiguration {
  override predicate shouldPrintNode(AstNode n) {
    isDesugared(n)
    or
    exists(n.getDesugared())
  }

  override predicate shouldPrintAstEdge(AstNode parent, string edgeName, AstNode child) {
    super.shouldPrintAstEdge(parent, edgeName, child) and
    desugarLevel(parent) = desugarLevel(child)
    or
    child = parent.getDesugared() and
    edgeName = "getDesugared"
  }
}
