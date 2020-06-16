import semmle.code.cpp.ir.dataflow.DefaultTaintTracking

from Expr source, Element tainted
where tainted(source, tainted)
select source, tainted
