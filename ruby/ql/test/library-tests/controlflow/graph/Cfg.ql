/**
 * @kind graph
 */

import codeql.ruby.CFG
import codeql.ruby.controlflow.internal.ControlFlowGraphImpl::TestOutput

class MyRelevantNode extends RelevantNode {
  MyRelevantNode() { exists(this) }
}
