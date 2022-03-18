import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.ExternalFlow
import ModelGeneratorUtils

class PropagateToSinkConfigurationSpecific extends TaintTracking::Configuration {
  PropagateToSinkConfigurationSpecific() { this = "parameters or fields flowing into sinks" }

  override predicate isSource(DataFlow::Node source) {
    (source.asExpr().(FieldAccess).isOwnFieldAccess() or source instanceof DataFlow::ParameterNode) and
    source.getEnclosingCallable().isPublic() and
    exists(RefType t |
      t = source.getEnclosingCallable().getDeclaringType().getAnAncestor() and
      not t instanceof TypeObject and
      t.isPublic()
    ) and
    isRelevantForModels(source.getEnclosingCallable())
  }
}

string asInputArgument(DataFlow::Node source) {
  exists(int pos |
    source.(DataFlow::ParameterNode).isParameterOf(_, pos) and
    result = "Argument[" + pos + "]"
  )
  or
  source.asExpr() instanceof FieldAccess and
  result = "Argument[-1]"
}
