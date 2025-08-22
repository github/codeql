import java

from ControlFlowNode cn
where cn.getLocation().getFile().getBaseName() = "Test.java"
select cn, cn.getASuccessor()
