/**
 * @kind path-problem
 */

import csharp
import CallSensitivity::PathGraph

module CallSensitivityConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof ObjectCreation }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasName("Sink") and
      mc.getAnArgument() = sink.asExpr()
    )
  }
}

module CallSensitivity = DataFlow::Global<CallSensitivityConfig>;

from CallSensitivity::PathNode source, CallSensitivity::PathNode sink
where CallSensitivity::flowPath(source, sink)
select source, source, sink, "$@", sink, sink.toString()
