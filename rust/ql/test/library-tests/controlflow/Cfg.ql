/**
 * @id rust/controlflow/cfg
 */

import rust
import codeql.rust.controlflow.ControlFlowGraph
import TestUtils

class MyRelevantNode extends CfgNode {
  MyRelevantNode() { toBeTested(this.getScope()) }

  string getOrderDisambiguation() { result = "" }
}

import codeql.rust.controlflow.internal.ControlFlowGraphImpl::TestOutput<MyRelevantNode>
