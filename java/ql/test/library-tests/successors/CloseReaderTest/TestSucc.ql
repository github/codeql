import java
import utils.test.AstCfg

from ControlFlowNode n, ControlFlowNode succ
where
  succ = getAnAstSuccessor(n) and
  n.getLocation().getFile().getExtension() = "java" and
  not n.getLocation().getFile().getStem() = "PopulateRuntimeException"
select n, succ
