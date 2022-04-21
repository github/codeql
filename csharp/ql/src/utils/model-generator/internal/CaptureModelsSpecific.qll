/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

private import csharp as CS
private import semmle.code.csharp.commons.Util as Util
private import semmle.code.csharp.commons.Collections as Collections
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch
private import semmle.code.csharp.frameworks.System as System
private import semmle.code.csharp.frameworks.system.linq.Expressions
import semmle.code.csharp.dataflow.ExternalFlow as ExternalFlow
import semmle.code.csharp.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
import semmle.code.csharp.dataflow.internal.DataFlowPrivate as DataFlowPrivate

module DataFlow = CS::DataFlow;

module TaintTracking = CS::TaintTracking;

class Type = CS::Type;

/**
 * Holds if any of the parameters of `api` are `System.Func<>`.
 */
private predicate isHigherOrder(CS::Callable api) {
  exists(Type t | t = api.getAParameter().getType().getUnboundDeclaration() |
    t instanceof SystemLinqExpressions::DelegateExtType
  )
}

/**
 * Holds if it is relevant to generate models for `api`.
 */
private predicate isRelevantForModels(CS::Callable api) {
  [api.(CS::Modifiable), api.(CS::Accessor).getDeclaration()].isEffectivelyPublic() and
  api.getDeclaringType().getNamespace().getQualifiedName() != "" and
  not api instanceof CS::ConversionOperator and
  not api instanceof Util::MainMethod and
  not isHigherOrder(api)
}

/**
 * A class of callables that are relevant generating summary, source and sinks models for.
 *
 * In the Standard library and 3rd party libraries it the callables that can be called
 * from outside the library itself.
 */
class TargetApiSpecific extends DataFlowCallable {
  TargetApiSpecific() {
    this.fromSource() and
    isRelevantForModels(this)
  }
}

predicate asPartialModel = DataFlowPrivate::Csv::asPartialModel/1;

/**
 * Holds for type `t` for fields that are relevant as an intermediate
 * read or write step in the data flow analysis.
 * That is, flow through any data-flow node that does not have a relevant type
 * will be excluded.
 */
predicate isRelevantType(CS::Type t) {
  not t instanceof CS::SimpleType and
  not t instanceof CS::Enum
}

/**
 * Gets the CSV string representation of the qualifier.
 */
string qualifierString() { result = "Argument[Qualifier]" }

private string parameterAccess(CS::Parameter p) {
  if Collections::isCollectionType(p.getType())
  then result = "Argument[" + p.getPosition() + "].Element"
  else result = "Argument[" + p.getPosition() + "]"
}

/**
 * Gets the CSV string representation of the parameter node `p`.
 */
string parameterNodeAsInput(DataFlow::ParameterNode p) {
  result = parameterAccess(p.asParameter())
  or
  result = qualifierString() and p instanceof DataFlowPrivate::InstanceParameterNode
}

pragma[nomagic]
private CS::Parameter getParameter(DataFlowImplCommon::ReturnNodeExt node, ParameterPosition pos) {
  result = node.getEnclosingCallable().getParameter(pos.getPosition())
}

/**
 * Gets the CSV string represention of the the return node `node`.
 */
string returnNodeAsOutput(DataFlowImplCommon::ReturnNodeExt node) {
  if node.getKind() instanceof DataFlowImplCommon::ValueReturnKind
  then result = "ReturnValue"
  else
    exists(ParameterPosition pos |
      pos = node.getKind().(DataFlowImplCommon::ParamUpdateReturnKind).getPosition()
    |
      result = parameterAccess(getParameter(node, pos))
      or
      pos.isThisParameter() and
      result = qualifierString()
    )
}

/**
 * Gets the enclosing callable of `ret`.
 */
CS::Callable returnNodeEnclosingCallable(DataFlowImplCommon::ReturnNodeExt ret) {
  result = DataFlowImplCommon::getNodeEnclosingCallable(ret)
}

/**
 * Holds if `node` is an own instance access.
 */
predicate isOwnInstanceAccessNode(DataFlowPrivate::ReturnNode node) {
  node.asExpr() instanceof CS::ThisAccess
}

private predicate isRelevantMemberAccess(DataFlow::Node node) {
  exists(CS::MemberAccess access | access = node.asExpr() |
    access.hasThisQualifier() and
    access.getTarget().isEffectivelyPublic() and
    (
      access instanceof CS::FieldAccess
      or
      access.getTarget().(CS::Property).getSetter().isPublic()
    )
  )
}

/**
 * Language specific parts of the `PropagateToSinkConfiguration`.
 */
class PropagateToSinkConfigurationSpecific extends CS::TaintTracking::Configuration {
  PropagateToSinkConfigurationSpecific() { this = "parameters or fields flowing into sinks" }

  override predicate isSource(DataFlow::Node source) {
    (isRelevantMemberAccess(source) or source instanceof DataFlow::ParameterNode) and
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
  source.asExpr() instanceof DataFlowPrivate::FieldOrPropertyAccess and
  result = qualifierString()
}

/**
 * Holds if `kind` is a relevant sink kind for creating sink models.
 */
bindingset[kind]
predicate isRelevantSinkKind(string kind) { any() }
