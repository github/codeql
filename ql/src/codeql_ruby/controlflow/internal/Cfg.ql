/**
 * @kind graph
 */

import codeql_ruby.controlflow.ControlFlowGraph

query predicate nodes(CfgNode n) { any() }

query predicate edges(CfgNode pred, CfgNode succ, string attr, string val) {
  exists(SuccessorType t | succ = pred.getASuccessor(t) |
    attr = "semmle.label" and
    if t instanceof SuccessorTypes::NormalSuccessor then val = "" else val = t.toString()
  )
}
