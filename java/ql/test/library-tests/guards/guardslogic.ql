import java
import semmle.code.java.controlflow.Guards

from Guard g, BasicBlock bb, GuardValue gv
where
  g.valueControls(bb, gv) and
  g.getEnclosingCallable().getDeclaringType().hasName("Logic") and
  (exists(gv.asBooleanValue()) or gv.isThrowsException() or gv.getDualValue().isThrowsException())
select g, gv, bb
