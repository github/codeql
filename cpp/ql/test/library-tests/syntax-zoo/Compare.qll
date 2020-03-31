import cpp
import semmle.code.cpp.controlflow.internal.CFG

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

predicate differentEdge(ControlFlowNode n1, ControlFlowNode n2, string msg) {
  successors(n1, n2) and
  not qlCFGSuccessor(n1, n2) and
  msg = "Standard edge, only from extractor"
  or
  not successors(n1, n2) and
  qlCFGSuccessor(n1, n2) and
  msg = "Standard edge, only from QL"
  or
  truecond_base(n1, n2) and
  not qlCFGTrueSuccessor(n1, n2) and
  msg = "True edge, only from extractor"
  or
  not truecond_base(n1, n2) and
  qlCFGTrueSuccessor(n1, n2) and
  msg = "True edge, only from QL"
  or
  falsecond_base(n1, n2) and
  not qlCFGFalseSuccessor(n1, n2) and
  msg = "False edge, only from extractor"
  or
  not falsecond_base(n1, n2) and
  qlCFGFalseSuccessor(n1, n2) and
  msg = "False edge, only from QL"
}

predicate differentScope(Element e) {
  exists(ControlFlowNode n1 |
    getScopeElement(n1) = e and
    differentEdge(n1, _, _)
  )
}

private predicate isInFunction(ControlFlowNode x, Function f) {
  f = x.getControlFlowScope()
  or
  exists(ControlFlowNode y |
    successors(unresolveElement(x), unresolveElement(y))
    or
    successors(unresolveElement(y), unresolveElement(x))
  |
    isInFunction(y, f)
  )
}

Element getScopeElement(ControlFlowNode x) {
  isInFunction(x, result)
  or
  not isInFunction(x, _) and
  result = x.getFile()
}

string getScopeName(ControlFlowNode x) {
  exists(Function scope | scope = getScopeElement(x) |
    differentScope(scope) and
    result =
      scope.getFile().getBaseName().splitAt(".", 0) + "__" +
        scope.getQualifiedName().replaceAll("::", "_")
  )
  or
  exists(File scope | scope = getScopeElement(x) |
    differentScope(scope) and
    result = scope.getBaseName()
  )
}

module QLCFG {
  private predicate isNode(boolean isEdge, ControlFlowNode x, ControlFlowNode y, string label) {
    isEdge = false and x = y and label = x.toString()
  }

  private predicate isSuccessor(boolean isEdge, ControlFlowNode x, ControlFlowNode y, string label) {
    exists(string truelabel, string falselabel |
      isEdge = true and
      qlCFGSuccessor(x, y) and
      (if qlCFGTrueSuccessor(x, y) then truelabel = "T" else truelabel = "") and
      (if qlCFGFalseSuccessor(x, y) then falselabel = "F" else falselabel = "") and
      label = truelabel + falselabel
    )
  }

  predicate qltestGraph(
    Element scopeElement, string scopeString, boolean isEdge, ControlFlowNode x, ControlFlowNode y,
    string label
  ) {
    scopeElement = getScopeElement(x) and
    scopeString = getScopeName(x) + "_ql" and
    (
      isNode(isEdge, x, y, label)
      or
      isSuccessor(isEdge, x, y, label)
    )
  }
}

module ExtractorCFG {
  predicate isNode(boolean isEdge, ControlFlowNode x, ControlFlowNode y, string label) {
    isEdge = false and x = y and label = x.toString()
  }

  predicate isSuccessor(boolean isEdge, ControlFlowNode x, ControlFlowNode y, string label) {
    exists(string truelabel, string falselabel |
      isEdge = true and
      successors(x, y) and
      (if truecond_base(x, y) then truelabel = "T" else truelabel = "") and
      (if falsecond_base(x, y) then falselabel = "F" else falselabel = "") and
      label = truelabel + falselabel
    )
  }

  predicate qltestGraph(
    Element scopeElement, string scopeString, boolean isEdge, ControlFlowNode x, ControlFlowNode y,
    string label
  ) {
    scopeElement = getScopeElement(x) and
    scopeString = getScopeName(x) + "_extractor" and
    (
      isNode(isEdge, x, y, label)
      or
      isSuccessor(isEdge, x, y, label)
    )
  }
}

module AllCFG {
  predicate qltestGraph(
    Element scopeElement, string scopeString, boolean isEdge, ControlFlowNode x, ControlFlowNode y,
    string label
  ) {
    QLCFG::qltestGraph(scopeElement, scopeString, isEdge, x, y, label)
    or
    ExtractorCFG::qltestGraph(scopeElement, scopeString, isEdge, x, y, label)
  }
}
