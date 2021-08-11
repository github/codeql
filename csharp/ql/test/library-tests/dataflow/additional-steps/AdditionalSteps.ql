/**
 * @kind path-problem
 */

import csharp
import dotnet
import DataFlow::PathGraph

class Conf extends DataFlow::Configuration {
  Conf() { this = "AdditionalSteps" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr() instanceof ObjectCreation
    or
    src.asExpr() instanceof Literal
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getTarget().hasName("Sink") and
      mc.getAnArgument() = sink.asExpr()
    )
  }

  override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodCall mc |
      mc.getTarget().hasName("ToString") and
      pred.asExpr() = mc.getQualifier() and
      succ.asExpr() = mc
    )
  }

  override predicate isAdditionalCallTarget(DotNet::Call call, DotNet::Callable target) {
    call.getTarget().hasQualifiedName("AdditionalSteps+A", "M2") and
    target.hasQualifiedName("AdditionalSteps+A", "M1")
    or
    call.getTarget().hasQualifiedName("AdditionalSteps+A", "M4") and
    target.hasQualifiedName("AdditionalSteps+A", "M3")
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, Conf conf
where conf.hasFlowPath(source, sink)
select source, source, sink, "$@", sink, sink.toString()
