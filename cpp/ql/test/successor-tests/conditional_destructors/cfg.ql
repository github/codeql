// query-type: graph
import cpp

class DestructorCallEnhanced extends DestructorCall {
  override string toString() {
    if exists(this.getQualifier().(VariableAccess).getTarget().getName())
    then
      result =
        "call to " + this.getQualifier().(VariableAccess).getTarget().getName() + "." +
          this.getTarget().getName()
    else result = super.toString()
  }
}

string scope(ControlFlowNode x) {
  if exists(x.getControlFlowScope().getQualifiedName())
  then result = x.getControlFlowScope().getQualifiedName()
  else result = "<no scope>"
}

predicate isNode(boolean isEdge, ControlFlowNode x, ControlFlowNode y, string label) {
  isEdge = false and x = y and label = x.toString()
}

predicate isSuccessor(boolean isEdge, ControlFlowNode x, ControlFlowNode y, string label) {
  exists(string truelabel, string falselabel |
    isEdge = true and
    x.getASuccessor() = y and
    (if x.getATrueSuccessor() = y then truelabel = "T" else truelabel = "") and
    (if x.getAFalseSuccessor() = y then falselabel = "F" else falselabel = "") and
    label = truelabel + falselabel
  )
}

from boolean isEdge, ControlFlowNode x, ControlFlowNode y, string label
where isNode(isEdge, x, y, label) or isSuccessor(isEdge, x, y, label)
select scope(x), isEdge, x, y, label
