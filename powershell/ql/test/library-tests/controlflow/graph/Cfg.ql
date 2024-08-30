/**
 * @kind graph
 */

import semmle.code.powershell.Cfg

class TestRelevantNode extends CfgNode {
  string getOrderDisambiguation() { result = "" }
}

import semmle.code.powershell.controlflow.internal.ControlFlowGraphImpl::TestOutput<TestRelevantNode>
