/**
 * @kind graph
 */

import swift
import codeql.swift.controlflow.ControlFlowGraph
import codeql.swift.controlflow.internal.ControlFlowGraphImpl::TestOutput

class MyRelevantNode extends RelevantNode {
  MyRelevantNode() { this.getScope().getLocation().getFile().getName().matches("%swift/ql/test%") }

  private AstNode asAstNode() { result = this.getNode().asAstNode() }

  override string getOrderDisambiguation() {
    result = this.asAstNode().getPrimaryQlClasses()
    or
    not exists(this.asAstNode()) and result = ""
  }
}
