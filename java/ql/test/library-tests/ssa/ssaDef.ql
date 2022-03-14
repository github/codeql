import java
import semmle.code.java.dataflow.SSA

from SsaVariable ssa, SsaSourceVariable v, string s
where
  ssa.getSourceVariable() = v and
  (
    s = ssa.toString()
    or
    not exists(ssa.toString()) and s = "error"
  )
select v, ssa.getCfgNode(), s
