import csharp
import semmle.code.csharp.dataflow.TaintTracking
import semmle.code.csharp.dataflow.ExternalFlow
import ModelGeneratorUtils

class PropagateToSinkConfigurationSpecific extends TaintTracking::Configuration {
  PropagateToSinkConfigurationSpecific() { this = "parameters or fields flowing into sinks" }

  override predicate isSource(DataFlow::Node source) {
    (source.asExpr() instanceof FieldAccess or source instanceof DataFlow::ParameterNode) and
    source.getEnclosingCallable().(Modifiable).isEffectivelyPublic() and
    isRelevantForModels(source.getEnclosingCallable())
  }
}

string asInputArgument(DataFlow::Node source) {
  exists(int pos |
    pos = source.(DataFlow::ParameterNode).getParameter().getPosition() and
    result = "Argument[" + pos + "]"
  )
  or
  source.asExpr() instanceof FieldAccess and
  result = "Argument[Qualifier]"
}
