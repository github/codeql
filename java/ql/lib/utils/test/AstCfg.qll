overlay[local?]
module;

import java

predicate isAstNode(ControlFlowNode n) {
  n.injects(_) or
  n instanceof ControlFlow::EntryNode or
  n instanceof ControlFlow::AnnotatedExitNode or
  n instanceof ControlFlow::ExitNode
}

predicate succToAst(ControlFlowNode n1, ControlFlowNode n2) {
  n2 = n1.getASuccessor() and
  isAstNode(n2)
  or
  exists(ControlFlowNode mid |
    mid = n1.getASuccessor() and
    not isAstNode(mid) and
    succToAst(mid, n2)
  )
}

ControlFlowNode getAnAstSuccessor(ControlFlowNode n) { isAstNode(n) and succToAst(n, result) }
