import java

from ControlFlowNode cn
where cn.getFile().getBaseName() = ["Test.java", "Exhaustive.java"]
select cn, cn.getASuccessor()
