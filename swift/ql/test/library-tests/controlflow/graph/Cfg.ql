/**
 * @kind graph
 */

import codeql.swift.controlflow.ControlFlowGraph
import codeql.swift.controlflow.internal.ControlFlowGraphImpl::TestOutput

class MyRelevantNode extends RelevantNode {
  MyRelevantNode() { getScope().getLocation().getFile().getName().matches("%swift/ql/test%") }
}
