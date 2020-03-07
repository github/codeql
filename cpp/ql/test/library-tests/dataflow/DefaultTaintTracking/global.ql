import semmle.code.cpp.ir.dataflow.DefaultTaintTracking

from Expr source, Element tainted, string globalVar
where
  taintedIncludingGlobalVars(source, tainted, globalVar) and
  globalVar != ""
select source, tainted, globalVar
