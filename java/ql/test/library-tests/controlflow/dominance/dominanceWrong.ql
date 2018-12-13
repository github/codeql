import java
import semmle.code.java.controlflow.Dominance

/**
 * Represents a path from `entry` to `node` that doesn't go through `dom`. If
 * `entry` is the entry node for the CFG then this shows that `dom` does not
 * dominate `node`.
 */
predicate dominanceCounterExample(ControlFlowNode entry, ControlFlowNode dom, ControlFlowNode node) {
  node = entry
  or
  exists(ControlFlowNode mid |
    dominanceCounterExample(entry, dom, mid) and mid != dom and mid.getASuccessor() = node
  )
}

from Callable c, ControlFlowNode dom, ControlFlowNode node
where
  (strictlyDominates(dom, node) or bbStrictlyDominates(dom, node)) and
  dominanceCounterExample(c.getBody().getControlFlowNode(), dom, node)
select c, dom, node
