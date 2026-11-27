import java
import semmle.code.java.controlflow.Guards
import utils.test.BasicBlock

from Guard g, BasicBlock bb, GuardValue gv
where
  g.valueControls(bb, gv) and
  g.getEnclosingCallable().getDeclaringType().hasName("Logic") and
  (
    exists(gv.asBooleanValue()) or
    gv.isThrowsException() or
    gv.getDualValue().isThrowsException() or
    gv.isMatch() or
    gv.getDualValue().isMatch()
  )
select g, gv, getFirstAstNode(bb)
