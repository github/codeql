import java
import semmle.code.java.controlflow.Guards

from Guard g, BasicBlock bb, GuardValue gv
where
  g.valueControls(bb, gv) and
  g.getEnclosingCallable().getDeclaringType().hasName("Preconditions") and
  (gv.isThrowsException() or gv.getDualValue().isThrowsException())
select g, gv, bb
