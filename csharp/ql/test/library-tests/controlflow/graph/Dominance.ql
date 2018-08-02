import csharp
import semmle.code.csharp.controlflow.ControlFlowGraph

from ControlFlowNode dom, ControlFlowNode node, string s
where
  dom.strictlyDominates(node) and dom.getASuccessor() = node and s = "pre"
  or
  dom.strictlyPostDominates(node) and dom.getAPredecessor() = node and s = "post"
select s, dom, node
