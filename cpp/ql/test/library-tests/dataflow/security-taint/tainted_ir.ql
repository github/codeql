import semmle.code.cpp.ir.dataflow.DefaultTaintTracking

class SourceConfiguration extends TaintedWithPath::TaintTrackingConfiguration {
  override predicate isSink(Element e) { any() }
}

from Expr source, Element tainted
where
  TaintedWithPath::taintedWithPath(source, tainted, _, _) and
  not tainted.getLocation().getFile().getExtension() = "h"
select source, tainted
