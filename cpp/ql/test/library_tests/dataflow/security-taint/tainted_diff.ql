import semmle.code.cpp.security.TaintTrackingImpl as AST
import semmle.code.cpp.ir.dataflow.DefaultTaintTracking as IR
import cpp

from Expr source, Element tainted, string side
where
  AST::taintedIncludingGlobalVars(source, tainted, _) and
  not IR::taintedIncludingGlobalVars(source, tainted, _) and
  not tainted.getLocation().getFile().getExtension() = "h" and
  side = "AST only"
  or
  IR::taintedIncludingGlobalVars(source, tainted, _) and
  not AST::taintedIncludingGlobalVars(source, tainted, _) and
  not tainted.getLocation().getFile().getExtension() = "h" and
  side = "IR only"
select source, tainted, side
