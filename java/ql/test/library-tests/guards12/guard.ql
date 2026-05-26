import java
import semmle.code.java.controlflow.Guards
import utils.test.BasicBlock

query predicate hasBranchEdge(
  Guard g, ControlFlowNode bb1ref, ControlFlowNode bb2ref, GuardValue branch
) {
  exists(BasicBlock bb1, BasicBlock bb2 |
    getFirstAstNodeOrSynth(bb1) = bb1ref and
    getFirstAstNodeOrSynth(bb2) = bb2ref and
    g.hasValueBranchEdge(bb1, bb2, branch)
  )
}

from Guard g, BasicBlock bb, boolean branch, Expr e1, Expr e2, boolean pol
where
  g.controls(bb, branch) and
  g.isEquality(e1, e2, pol) and
  not e1 instanceof Literal
select g, e1, e2, pol, branch, getFirstAstNodeOrSynth(bb)
