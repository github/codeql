import java
import semmle.code.java.controlflow.Guards

from Guard g, BasicBlock bb, boolean branch, VarAccess e1, Expr e2, boolean pol
where
  g.controls(bb, branch) and
  g.isEquality(e1, e2, pol)
select g, e1, e2, pol, branch, bb
