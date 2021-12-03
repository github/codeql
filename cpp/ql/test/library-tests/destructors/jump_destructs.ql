import cpp

ControlFlowNode getANonLabelSuccessor(ControlFlowNode n) {
  n.getASuccessor() = result and not result instanceof LabelStmt
}

class Jump extends Locatable {
  Jump() {
    this instanceof GotoStmt or
    this instanceof ReturnStmt
  }
}

from Jump j, ControlFlowNode n
where getANonLabelSuccessor+(j) = n
select j.(ControlFlowNode).getControlFlowScope(), j.getLocation().getStartLine(), j.toString(),
  count(n.getAPredecessor*()), // Improves the output's sort order
  n.getLocation().getStartLine(), n.toString()
