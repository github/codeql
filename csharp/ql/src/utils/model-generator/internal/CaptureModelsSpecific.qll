/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

import csharp
private import semmle.code.csharp.dataflow.ExternalFlow as Ef
private import semmle.code.csharp.dataflow.TaintTracking
private import semmle.code.csharp.dataflow.internal.DataFlowImplCommon as Dfic
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import ModelGeneratorUtils

/**
 * Gets the enclosing callable of `ret`.
 */
Callable returnNodeEnclosingCallable(Dfic::ReturnNodeExt ret) {
  result = Dfic::getNodeEnclosingCallable(ret)
}

/**
 * Holds if `node` is an own instance access.
 */
predicate isOwnInstanceAccessNode(ReturnNode node) { node.asExpr() instanceof ThisAccess }

/**
 * Gets the CSV string representation of the qualifier.
 */
string qualifierString() { result = "Argument[Qualifier]" }

/**
 * Language specific parts of the `PropagateToSinkConfiguration`.
 */
class PropagateToSinkConfigurationSpecific extends TaintTracking::Configuration {
  PropagateToSinkConfigurationSpecific() { this = "parameters or fields flowing into sinks" }

  override predicate isSource(DataFlow::Node source) {
    (source.asExpr() instanceof FieldAccess or source instanceof DataFlow::ParameterNode) and
    source.getEnclosingCallable().(Modifiable).isEffectivelyPublic() and
    isRelevantForModels(source.getEnclosingCallable())
  }
}

/**
 * Gets the CSV input string representation of `source`.
 */
string asInputArgument(DataFlow::Node source) {
  exists(int pos |
    pos = source.(DataFlow::ParameterNode).getParameter().getPosition() and
    result = "Argument[" + pos + "]"
  )
  or
  source.asExpr() instanceof FieldAccess and
  result = qualifierString()
}

module DataFlowImplCommon {
  predicate store = Dfic::store/4;

  class ReturnNodeExt = Dfic::ReturnNodeExt;

  class TypedContent = Dfic::TypedContent;
}

module ExternalFlow {
  predicate sourceNode = Ef::sourceNode/2;

  predicate sinkNode = Ef::sinkNode/2;
}
