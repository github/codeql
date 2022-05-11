/**
 * @kind graph
 */

import codeql.ruby.AST
import codeql.ruby.printAst
import codeql.ruby.ast.internal.Synthesis

class DesugarPrintAstConfiguration extends PrintAstConfiguration {
  override predicate shouldPrintNode(AstNode n) {
    isInDesugeredContext(n)
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
