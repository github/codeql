import java
import utils.test.AstCfg

from ControlFlowNode cn
where cn.getLocation().getFile().getBaseName() = ["Test.java", "Exhaustive.java"]
select cn, getAnAstSuccessor(cn)
