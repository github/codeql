/**
 * @id rust/controlflow/cfg
 */

import rust
import codeql.rust.controlflow.ControlFlowGraph

class MyRelevantNode extends CfgNode {
  string getOrderDisambiguation() { result = "" }
}

import codeql.rust.controlflow.internal.ControlFlowGraphImpl::TestOutput<MyRelevantNode>
