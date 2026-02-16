import java

from Method func, BasicBlock dominator, BasicBlock bb
where
  dominator.immediatelyDominates(bb) and
  dominator.getEnclosingCallable() = func and
  func.getDeclaringType().hasName("Test")
select dominator, bb
