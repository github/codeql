import swift
import codeql.swift.controlflow.ControlFlowGraph

class MyRelevantNode extends ControlFlowNode {
  MyRelevantNode() { this.getScope().getLocation().getFile().getName().matches("%swift/ql/test%") }
}

import codeql.swift.controlflow.internal.ControlFlowGraphImpl::TestOutput<MyRelevantNode>
