import java
import semmle.code.java.dataflow.SSA

from SsaPhiDefinition ssa, SsaSourceVariable v, SsaDefinition phiInput
where ssa.getAnInput() = phiInput and ssa.getSourceVariable() = v
select v, ssa.getControlFlowNode(), phiInput.getControlFlowNode()
