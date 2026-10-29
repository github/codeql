import cpp
import semmle.code.cpp.controlflow.SubBasicBlocks

string subBasicBlockDebugInfo(SubBasicBlock sbb) {
  result =
    sbb.getStart().toString() + " [line " + sbb.getStart().getLocation().getStartLine() + "-" +
      sbb.getEnd().getLocation().getEndLine() + ", " + sbb.getNumberOfNodes() + " nodes, " + "pos " +
      (sbb.getRankInBasicBlock(_) - 1) +
      any(string s | if sbb.firstInBB() then s = " (first in BB)" else s = "") +
      any(string s | if sbb.lastInBB() then s = " (last in BB)" else s = "") + ", " +
      count(sbb.getAPredecessor()) + " predecessors, " + count(sbb.getASuccessor()) + " successors" +
      "]"
}

predicate isNode(boolean isEdge, SubBasicBlock x, SubBasicBlock y, string label) {
  isEdge = false and
  x = y and
  label = subBasicBlockDebugInfo(x)
}

predicate isSuccessor(boolean isEdge, SubBasicBlock x, SubBasicBlock y, string label) {
  exists(string truelabel, string falselabel |
    isEdge = true and
    x.getASuccessor() = y and
    (if x.getATrueSuccessor() = y then truelabel = "T" else truelabel = "") and
    (if x.getAFalseSuccessor() = y then falselabel = "F" else falselabel = "") and
    label = truelabel + falselabel
  )
}
