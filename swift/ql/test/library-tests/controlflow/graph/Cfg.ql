import swift
import codeql.swift.controlflow.ControlFlowGraph

class MyRelevantNode extends ControlFlowNode {
  MyRelevantNode() { this.getScope().getLocation().getFile().getName().contains("swift/ql/test") }
}

import codeql.swift.controlflow.internal.ControlFlowGraphImpl::TestOutput<MyRelevantNode>
