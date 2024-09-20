/**
 * @id rust/controlflow/cfg
 */

import rust
import codeql.rust.controlflow.ControlFlowGraph
import TestUtils

class MyRelevantNode extends CfgNode {
  MyRelevantNode() { toBeTested(this.getScope()) }
}

import codeql.rust.controlflow.internal.ControlFlowGraphImpl::TestOutput<MyRelevantNode>
