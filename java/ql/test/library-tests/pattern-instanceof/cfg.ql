import java

from ControlFlowNode cn
where cn.getFile().getBaseName() = "Test.java"
select cn, cn.getASuccessor()
