import java
import semmle.code.java.dataflow.SSA

from SsaVariable ssa, SsaSourceVariable v, Expr use
where use = ssa.getAUse() and ssa.getSourceVariable() = v
select v, ssa.getCFGNode(), ssa.toString(), use
