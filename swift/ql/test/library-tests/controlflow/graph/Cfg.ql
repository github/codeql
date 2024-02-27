/**
 * @kind graph
 */

import swift
import codeql.swift.controlflow.ControlFlowGraph

class MyRelevantNode extends ControlFlowNode {
  MyRelevantNode() { this.getScope().getLocation().getFile().getName().matches("%swift/ql/test%") }

  private AstNode asAstNode() { result = this.getAstNode().asAstNode() }

  string getOrderDisambiguation() {
    result = this.asAstNode().getPrimaryQlClasses()
    or
    not exists(this.asAstNode()) and result = ""
  }
}

import codeql.swift.controlflow.internal.ControlFlowGraphImpl::TestOutput<MyRelevantNode>
