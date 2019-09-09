import cpp
import DataflowTestCommon as ASTCommon
import IRDataflowTestCommon as IRCommon
import semmle.code.cpp.dataflow.DataFlow as ASTDataFlow
import semmle.code.cpp.ir.dataflow.DataFlow as IRDataFlow

predicate astFlow(Location sourceLocation, Location sinkLocation) {
  exists(
    ASTDataFlow::DataFlow::Node source, ASTDataFlow::DataFlow::Node sink,
    ASTCommon::TestAllocationConfig cfg
  |
    cfg.hasFlow(source, sink) and
    sourceLocation = source.getLocation() and
    sinkLocation = sink.getLocation()
  )
}

predicate irFlow(Location sourceLocation, Location sinkLocation) {
  exists(
    IRDataFlow::DataFlow::Node source, IRDataFlow::DataFlow::Node sink,
    IRCommon::TestAllocationConfig cfg
  |
    cfg.hasFlow(source, sink) and
    sourceLocation = source.getLocation() and
    sinkLocation = sink.getLocation()
  )
}

from Location sourceLocation, Location sinkLocation, string note
where
  astFlow(sourceLocation, sinkLocation) and
  not irFlow(sourceLocation, sinkLocation) and
  note = "AST only"
  or
  irFlow(sourceLocation, sinkLocation) and
  not astFlow(sourceLocation, sinkLocation) and
  note = "IR only"
select sourceLocation.toString(), sinkLocation.toString(), note
