/**
 * @kind graph
 */

import codeql.ruby.CFG

class MyRelevantNode extends CfgNode {
  string getOrderDisambiguation() { result = "" }
}

import codeql.ruby.controlflow.internal.ControlFlowGraphImpl::TestOutput<MyRelevantNode>
