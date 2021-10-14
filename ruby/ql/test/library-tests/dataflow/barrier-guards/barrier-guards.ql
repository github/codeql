import codeql.ruby.dataflow.internal.DataFlowPublic
import codeql.ruby.dataflow.BarrierGuards
import codeql.ruby.controlflow.CfgNodes

from BarrierGuard g, boolean branch, ExprCfgNode expr
where g.checks(expr, branch)
select g, g.getAGuardedNode(), expr, branch
