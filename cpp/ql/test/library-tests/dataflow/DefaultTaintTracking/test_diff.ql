import cpp
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTrackingImpl as ASTTaintTracking
import semmle.code.cpp.ir.dataflow.DefaultTaintTracking as IRDefaultTaintTracking

class SourceConfiguration extends IRDefaultTaintTracking::TaintedWithPath::TaintTrackingConfiguration {
  override predicate isSink(Element e) { any() }
}

predicate astFlow(Expr source, Element sink) { ASTTaintTracking::tainted(source, sink) }

predicate irFlow(Expr source, Element sink) {
  IRDefaultTaintTracking::TaintedWithPath::taintedWithPath(source, sink, _, _)
}

from Expr source, Element sink, string note
where
  not sink instanceof Parameter and
  (
    astFlow(source, sink) and
    not irFlow(source, sink) and
    note = "AST only"
    or
    irFlow(source, sink) and
    not astFlow(source, sink) and
    note = "IR only"
  )
select source, sink, note
