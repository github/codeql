import cpp

from VariableAccess a, BlockExpr b
where a.getEnclosingFunction() = b.getFunction()
select b, a, a.getTarget(), a.getEnclosingFunction()
