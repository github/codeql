import default
import utils.test.AstCfg

from ControlFlowNode n
where n.getEnclosingCallable().getCompilationUnit().fromSource()
select n, getAnAstSuccessor(n)
