import java
import semmle.code.java.dataflow.SSA

from SsaPhiNode ssa, SsaSourceVariable v, SsaVariable phiInput
where ssa.getAPhiInput() = phiInput and ssa.getSourceVariable() = v
select v, ssa.getCFGNode(), phiInput.getCFGNode()
