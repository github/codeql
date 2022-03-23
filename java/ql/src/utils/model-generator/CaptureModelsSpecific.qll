/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

import java
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.internal.DataFlowImplCommon
import semmle.code.java.dataflow.internal.DataFlowNodes
import semmle.code.java.dataflow.internal.DataFlowPrivate
import semmle.code.java.dataflow.InstanceAccess
import ModelGeneratorUtils

/**
 * Gets the enclosing callable of `ret`.
 */
Callable returnNodeEnclosingCallable(ReturnNodeExt ret) {
  result = getNodeEnclosingCallable(ret).asCallable()
}

/**
 * Holds if `node` is an own instance access.
 */
predicate isOwnInstanceAccessNode(ReturnNode node) {
  node.asExpr().(ThisAccess).isOwnInstanceAccess()
}

/**
 * Gets the CSV string representation of the qualifier.
 */
string qualifierString() { result = "Argument[-1]" }

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
