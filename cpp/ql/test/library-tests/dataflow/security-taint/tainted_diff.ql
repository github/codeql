import semmle.code.cpp.security.TaintTrackingImpl as AST
import semmle.code.cpp.ir.dataflow.DefaultTaintTracking as IR
import cpp

class SourceConfiguration extends IR::TaintedWithPath::TaintTrackingConfiguration {
  override predicate isSink(Element e) { any() }
}

from Expr source, Element tainted, string side
where
  AST::taintedIncludingGlobalVars(source, tainted, _) and
  not IR::TaintedWithPath::taintedWithPath(source, tainted, _, _) and
  not tainted.getLocation().getFile().getExtension() = "h" and
  side = "AST only"
  or
  IR::TaintedWithPath::taintedWithPath(source, tainted, _, _) and
  not AST::taintedIncludingGlobalVars(source, tainted, _) and
  not tainted.getLocation().getFile().getExtension() = "h" and
  side = "IR only"
select source, tainted, side
