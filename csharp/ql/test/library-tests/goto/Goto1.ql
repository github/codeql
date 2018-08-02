/**
 * @kind graph
 * @id nodegraph
 */

import csharp
import semmle.code.csharp.controlflow.ControlFlowGraph

query predicate edges(ControlFlowNode node, ControlFlowNode successor, string attr, string val) {
  exists(ControlFlowEdgeType t |
    successor = node.getASuccessorByType(t) |
    attr = "semmle.label" and
    val = t.toString()
  )
}
