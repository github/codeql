import cpp
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTracking as ASTTaintTracking
import semmle.code.cpp.ir.dataflow.DefaultTaintTracking as IRDefaultTaintTracking

predicate astFlow(Location sourceLocation, Location sinkLocation) {
  exists(Expr source, Element sink |
    ASTTaintTracking::tainted(source, sink) and
    sourceLocation = source.getLocation() and
    sinkLocation = sink.getLocation()
  )
}

predicate irFlow(Location sourceLocation, Location sinkLocation) {
  exists(Expr source, Element sink |
    IRDefaultTaintTracking::tainted(source, sink) and
    sourceLocation = source.getLocation() and
    sinkLocation = sink.getLocation()
  )
}

from Location source, Location sink, string note
where
  astFlow(source, sink) and
  not irFlow(source, sink) and
  note = "AST only"
  or
  irFlow(source, sink) and
  not astFlow(source, sink) and
  note = "IR only"
select source.toString(), sink.toString(), note
