/**
 * @kind graph
 * @id elementgraph
 */

import csharp
import semmle.code.csharp.controlflow.ControlFlowGraph

query predicate edges(ControlFlowElement node, ControlFlowElement successor, string attr, string val) {
  exists(ControlFlowEdgeType t |
    successor = node.getAControlFlowNode().getASuccessorByType(t).getElement() |
    attr = "semmle.label" and
    val = t.toString()
  )
}
