import java

from ControlFlowNode cn
where cn.getLocation().getFile().getBaseName() = ["Test.java", "Exhaustive.java"]
select cn, cn.getASuccessor()
