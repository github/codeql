import semmle.code.cpp.security.TaintTracking

from Expr source, Element tainted, string globalVar
where
  taintedIncludingGlobalVars(source, tainted, globalVar) and
  not tainted.getLocation().getFile().getExtension() = "h"
select source, tainted, globalVar
