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
import semmle.code.csharp.dataflow.ExternalFlow as ExternalFlow
import semmle.code.csharp.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
import semmle.code.csharp.dataflow.internal.DataFlowPrivate as DataFlowPrivate

module DataFlow = CS::DataFlow;

module TaintTracking = CS::TaintTracking;

class Type = CS::Type;

class Unit = DataFlowPrivate::Unit;

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
  api.getDeclaringType().getNamespace().getFullName() != "" and
  not api instanceof CS::ConversionOperator and
  not api instanceof Util::MainMethod and
  not api instanceof CS::Destructor and
  not api instanceof CS::AnonymousFunctionExpr and
  not api.(CS::Constructor).isParameterless()
}

/**
 * Holds if it is relevant to generate models for `api` based on data flow analysis.
 */
predicate isRelevantForDataFlowModels(CS::Callable api) {
  isRelevantForModels(api) and not isHigherOrder(api)
}

/**
 * Holds if it is relevant to generate models for `api` based on its type.
 */
predicate isRelevantForTypeBasedFlowModels = isRelevantForModels/1;

/**
 * A class of callables that are relevant generating summary, source and sinks models for.
 *
 * In the Standard library and 3rd party libraries it the callables that can be called
 * from outside the library itself.
 */
class TargetApiSpecific extends DotNet::Callable {
  TargetApiSpecific() {
    this.fromSource() and
    this.isUnboundDeclaration()
  }
}

predicate asPartialModel = DataFlowPrivate::Csv::asPartialModel/1;

predicate asPartialNeutralModel = DataFlowPrivate::Csv::asPartialNeutralModel/1;

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
 * Gets the CSV string representation of the qualifier.
 */
string qualifierString() { result = "Argument[this]" }

string parameterAccess(CS::Parameter p) {
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
 * Gets the CSV string representation of the the return node `node`.
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

predicate sinkModelSanitizer(DataFlow::Node node) { none() }

/**
 * Holds if `source` is an api entrypoint relevant for creating sink models.
 */
predicate apiSource(DataFlow::Node source) {
  (isRelevantMemberAccess(source) or source instanceof DataFlow::ParameterNode) and
  isRelevantForModels(source.getEnclosingCallable())
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
