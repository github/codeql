import cpp
import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.security.Security
import semmle.code.cpp.ir.dataflow.DefaultTaintTracking as IRDefaultTaintTracking
import semmle.code.cpp.dataflow.DataFlow as ASTDataFlow
import semmle.code.cpp.ir.dataflow.DataFlow as IRDataFlow

// Only perform taint tracking from parameters, global variables or field variables
private class TestSecurityOptions extends SecurityOptions {
  override predicate isUserInput(Expr expr, string cause) {
    (
      exists(Parameter p | p.getAnAccess() = expr) or
      expr.(VariableAccess).getTarget().getParentScope() instanceof GlobalNamespace or
      exists(Field f | f.getAnAccess() = expr)
    ) and
    cause = ""
  }
}

// Mimic the definitions of sources and sinks in DefaultTaintTracking
class DefaultTaintTrackingLookalikeConfig extends TaintTracking::Configuration {
  DefaultTaintTrackingLookalikeConfig() { this = "DefaultTaintTrackingLookalikeConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(FunctionCall fc, int arg |
      userInputArgument(fc, arg) and
      source.asExpr() = fc
    )
    or
    userInputReturned(source.asExpr())
    or
    isUserInput(source.asExpr(), _)
    or
    source.asExpr() instanceof EnvironmentRead
    or
    source.asExpr().(VariableAccess).getTarget().hasName("argv") and
    source.getFunction().hasGlobalName("main")
  }

  override predicate isSink(DataFlow::Node sink) { any() }
}

predicate astFlow(Location sourceLocation, Location sinkLocation) {
  exists(
    ASTDataFlow::DataFlow::Node source, ASTDataFlow::DataFlow::Node sink,
    DefaultTaintTrackingLookalikeConfig cfg
  |
    cfg.hasFlow(source, sink) and
    sourceLocation = source.getLocation() and
    sinkLocation = sink.getLocation()
  )
}

predicate irFlow(Location sourceLocation, Location sinkLocation) {
  exists(IRDataFlow::DataFlow::Node source, Element sink |
    IRDefaultTaintTracking::tainted(source.asExpr(), sink) and
    sourceLocation = source.getLocation() and
    sinkLocation = sink.getLocation()
  )
}

predicate equivalent(Location sink1, Location sink2) {
  sink1 = sink2
  or
  // AST taint analysis will report a flow from 'b' to 'a = b',
  // but IR taint analysis will report a flow from 'b' to the
  // declaration of 'a'
  exists(Element sinkIR, AssignExpr assign |
    sink1 = assign.getLocation() and
    sink2 = sinkIR.getLocation()
  |
    assign.getLValue().(VariableAccess).getTarget() = sinkIR
  )
}

class LocationInFile extends Location {
  LocationInFile() { this.getFile().getBaseName() = "default_taint.cpp" }
}

from LocationInFile source, LocationInFile sink, string note
where
  astFlow(source, sink) and
  not exists(Location otherSink |
    equivalent(sink, otherSink) and
    irFlow(source, otherSink)
  ) and
  note = "AST only"
  or
  irFlow(source, sink) and
  not exists(Location otherSink |
    equivalent(otherSink, sink) and
    astFlow(source, otherSink)
  ) and
  note = "IR only"
select source.toString(), sink.toString(), note
