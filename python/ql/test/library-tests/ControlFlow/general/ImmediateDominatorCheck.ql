import python

predicate can_reach_from_entry_without_passing(ControlFlowNode target, ControlFlowNode pass) {
  target != pass and
  target.getScope() = pass.getScope() and
  (
    target.isEntryNode()
    or
    exists(ControlFlowNode pre |
      target.getAPredecessor() = pre and can_reach_from_entry_without_passing(pre, pass)
    )
  )
}

from ControlFlowNode node, ControlFlowNode dom
where
  dom = node.getImmediateDominator() and
  can_reach_from_entry_without_passing(node, dom)
select node.toString(), dom.toString()
