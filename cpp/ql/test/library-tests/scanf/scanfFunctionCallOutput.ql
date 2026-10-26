import semmle.code.cpp.commons.Scanf

from ScanfFunctionCall sfc, Expr e, int n
where e = sfc.getOutputArgument(n)
select sfc, e, n
