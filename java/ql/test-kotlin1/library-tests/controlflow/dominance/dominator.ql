import java
import utils.test.BasicBlock

from Method func, BasicBlock dominator, BasicBlock bb
where
  dominator.immediatelyDominates(bb) and
  dominator.getEnclosingCallable() = func and
  func.getDeclaringType().hasName("Test")
select getFirstAstNodeOrSynth(dominator), getFirstAstNodeOrSynth(bb)
