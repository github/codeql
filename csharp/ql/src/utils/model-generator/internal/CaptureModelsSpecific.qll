/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

private import csharp as CS
private import dotnet
private import semmle.code.csharp.commons.Util as Util
private import semmle.code.csharp.commons.Collections as Collections
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch
private import semmle.code.csharp.frameworks.System as System
private import semmle.code.csharp.frameworks.system.linq.Expressions
private import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate as TaintTrackingPrivate
import semmle.code.csharp.dataflow.ExternalFlow as ExternalFlow
import semmle.code.csharp.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate as DataFlowPrivate
import semmle.code.csharp.dataflow.internal.ContentDataFlow

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
  not isHigherOrder(api) and
  not api instanceof CS::Destructor
}

/**
 * A class of callables that are relevant generating summary, source and sinks models for.
 *
 * In the Standard library and 3rd party libraries it the callables that can be called
 * from outside the library itself.
 */
class TargetApiSpecific extends DotNet::Callable {
  TargetApiSpecific() {
    this.fromSource() and
    this.isUnboundDeclaration() and
    isRelevantForModels(this)
  }
}

predicate asPartialModel = DataFlowPrivate::Csv::asPartialModel/1;

predicate asPartialNegativeModel = DataFlowPrivate::Csv::asPartialNegativeModel/1;

/**
 * Holds if `t` is a type that is generally used for bulk data in collection types.
 * Eg. char[] is roughly equivalent to string and thus a highly
 * relevant type for model generation.
 */
private predicate isPrimitiveTypeUsedForBulkData(CS::Type t) {
  t instanceof CS::ByteType or
  t instanceof CS::CharType
}

/**
 * Holds if the collection type `ct` is irrelevant for model generation.
 * Collection types where the type of the elements are
 * (1) unknown - are considered relevant.
 * (2) known - at least one the child types should be relevant (a non-simple type
 * or a type used for bulk data)
 */
private predicate irrelevantCollectionType(CS::Type ct) {
  Collections::isCollectionType(ct) and
  forex(CS::Type child | child = ct.getAChild() |
    child instanceof CS::SimpleType and
    not isPrimitiveTypeUsedForBulkData(child)
  )
}

/**
 * Holds for type `t` for fields that are relevant as an intermediate
 * read or write step in the data flow analysis.
 * That is, flow through any data-flow node that does not have a relevant type
 * will be excluded.
 */
predicate isRelevantType(CS::Type t) {
  not t instanceof CS::SimpleType and
  not t instanceof CS::Enum and
  not irrelevantCollectionType(t)
}

/**
 * Holds if content `c` is either a field or synthetic field of a relevant type
 * or a container like content.
 */
predicate isRelevantContent(DataFlow::Content c) {
  isRelevantType(c.(DataFlow::FieldContent).getField().getType())
  or
  exists(CS::TrivialProperty p |
    p = c.(DataFlow::PropertyContent).getProperty() and
    isRelevantType(p.getType())
  )
  or
  isRelevantType(c.(DataFlow::SyntheticFieldContent).getField().getType())
  or
  DataFlowPrivate::containerContent(c)
}

/**
 * Gets the CSV string representation of the qualifier.
 */
string qualifierString() { result = "Argument[this]" }

private string parameterAccess(CS::Parameter p) { result = "Argument[" + p.getPosition() + "]" }

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
  result = DataFlowImplCommon::getNodeEnclosingCallable(ret).asCallable()
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

/**
 * Holds if `kind` is a relevant source kind for creating source models.
 */
bindingset[kind]
predicate isRelevantSourceKind(string kind) { not kind = "file" }

string printContent(DataFlow::Content c) {
  exists(CS::Field f |
    f = c.(DataFlow::FieldContent).getField() and
    if f.isEffectivelyPublic()
    then result = "Field[" + f.getQualifiedName() + "]"
    else result = "SyntheticField[" + f.getQualifiedName() + "]"
  )
  or
  exists(CS::Property p |
    p = c.(DataFlow::PropertyContent).getProperty() and
    if p.isEffectivelyPublic()
    then result = "Property[" + p.getQualifiedName() + "]"
    else result = "SyntheticField[" + p.getQualifiedName() + "]"
  )
  or
  c instanceof DataFlow::ElementContent and
  result = "Element"
}

predicate taintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  TaintTrackingPrivate::defaultAdditionalTaintStep(nodeFrom, nodeTo) and
  not nodeTo.asExpr() instanceof CS::ElementAccess and
  not DataFlowPrivate::readStep(nodeFrom, DataFlowPrivate::TElementContent(), nodeTo)
}

int accessPathLimit() { result = 2 }

/**
 * Holds if the step from `node1` to `node2` should be taken into account when
 * capturing flow sources.
 */
predicate isRelevantSourceTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(DataFlow::Content f |
    DataFlowPrivate::readStep(node1, f, node2) and
    if f instanceof DataFlow::FieldContent
    then isRelevantType(f.(DataFlow::FieldContent).getField().getType())
    else
      if f instanceof DataFlow::SyntheticFieldContent
      then isRelevantType(f.(DataFlow::SyntheticFieldContent).getField().getType())
      else any()
  )
  or
  exists(DataFlow::Content f | DataFlowPrivate::storeStep(node1, f, node2) |
    DataFlowPrivate::containerContent(f)
  )
}
