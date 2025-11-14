import java
import semmle.code.java.dataflow.SSA

from SsaDefinition ssa, SsaSourceVariable v, Expr use
where use = ssa.getARead() and ssa.getSourceVariable() = v
select v, ssa.getControlFlowNode(), ssa.toString(), use
