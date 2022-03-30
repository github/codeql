import cpp
import semmle.code.cpp.dataflow.DataFlow

class EdgeToExcept extends AdditionalControlFlowEdge {
  EdgeToExcept() {
    mkElement(this) instanceof Call and
    exists(getNearestTryExceptParent(mkElement(this)))
  }

  override ControlFlowNode getAnEdgeTarget() {
    result = getNearestTryExceptParent(mkElement(this)).getExcept()
  }
}

MicrosoftTryExceptStmt getNearestTryExceptParent(Expr e) { result = getANearParent(e) }

private Element getANearParent(Expr e) {
  result = e.getParent()
  or
  exists(Element prev |
    result = prev.(Expr).getParent()
    or
    result = prev.(Stmt).getParent()
  |
    // do not recurse past __try
    not prev instanceof MicrosoftTryStmt and
    prev = getANearParent(e)
  )
}

from DataFlow::Node nodeFrom, DataFlow::Node nodeTo
where DataFlow::localFlowStep(nodeFrom, nodeTo)
select nodeFrom, nodeTo
