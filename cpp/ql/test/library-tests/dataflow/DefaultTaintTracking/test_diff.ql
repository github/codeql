import cpp
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTrackingImpl as ASTTaintTracking
import semmle.code.cpp.ir.dataflow.DefaultTaintTracking as IRDefaultTaintTracking

predicate astFlow(Expr source, Element sink) { ASTTaintTracking::tainted(source, sink) }

predicate irFlow(Expr source, Element sink) { IRDefaultTaintTracking::tainted(source, sink) }

from Expr source, Element sink, string note
where
  astFlow(source, sink) and
  not irFlow(source, sink) and
  note = "AST only"
  or
  irFlow(source, sink) and
  not astFlow(source, sink) and
  note = "IR only"
select source, sink, note
