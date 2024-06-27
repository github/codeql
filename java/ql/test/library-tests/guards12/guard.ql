import java
import semmle.code.java.controlflow.Guards

query predicate hasBranchEdge(Guard g, BasicBlock bb1, BasicBlock bb2, boolean branch) {
  g.hasBranchEdge(bb1, bb2, branch)
}

from Guard g, BasicBlock bb, boolean branch, Expr e1, Expr e2, boolean pol
where
  g.controls(bb, branch) and
  g.isEquality(e1, e2, pol) and
  not e1 instanceof Literal
select g, e1, e2, pol, branch, bb
