import rust
import codeql.rust.controlflow.ControlFlowGraph
import TestUtils

class MyRelevantNode extends CfgNode {
  MyRelevantNode() { toBeTested(this.getScope()) }
}

import codeql.rust.controlflow.internal.ControlFlowGraphImpl::TestOutput<MyRelevantNode>

query predicate breakTarget(BreakExpr be, Expr target) { target = be.getTarget() }

query predicate continueTarget(ContinueExpr ce, Expr target) { target = ce.getTarget() }
