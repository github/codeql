/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

private import csharp as CS
private import semmle.code.csharp.commons.Util as Util
private import semmle.code.csharp.commons.Collections as Collections
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch
private import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.frameworks.system.linq.Expressions
import semmle.code.csharp.dataflow.internal.ExternalFlow as ExternalFlow
import semmle.code.csharp.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
import semmle.code.csharp.dataflow.internal.DataFlowPrivate as DataFlowPrivate
import semmle.code.csharp.dataflow.internal.DataFlowDispatch as DataFlowDispatch

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

private predicate irrelevantAccessor(CS::Accessor a) {
  a.getDeclaration().(CS::Property).isReadWrite()
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
  not api.(CS::Constructor).isParameterless() and
  // Disregard all APIs that have a manual model.
  not api = any(FlowSummaryImpl::Public::SummarizedCallable sc | sc.applyManualModel()) and
  not api = any(FlowSummaryImpl::Public::NeutralSummaryCallable sc | sc.hasManualModel()) and
  // Disregard properties that have both a get and a set accessor,
  // which implicitly means auto implemented properties.
  not irrelevantAccessor(api)
}

/**
 * Holds if it is irrelevant to generate models for `api` based on data flow analysis.
 *
 * This serves as an extra filter for the `relevant` predicate.
 */
predicate isUninterestingForDataFlowModels(CS::Callable api) { isHigherOrder(api) }

/**
 * Holds if it is irrelevant to generate models for `api` based on type-based analysis.
 *
 * This serves as an extra filter for the `relevant` predicate.
 */
predicate isUninterestingForTypeBasedFlowModels(CS::Callable api) { none() }

/**
 * A class of callables that are relevant generating summary, source and sinks models for.
 *
 * In the Standard library and 3rd party libraries it the callables that can be called
 * from outside the library itself.
 */
class TargetApiSpecific extends CS::Callable {
  TargetApiSpecific() {
    this.fromSource() and
    this.isUnboundDeclaration() and
    isRelevantForModels(this)
  }
}

predicate asPartialModel = ExternalFlow::asPartialModel/1;

/** Computes the first 4 columns for neutral CSV rows of `c`. */
predicate asPartialNeutralModel = ExternalFlow::getSignature/1;

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
 * Gets the MaD string representation of the qualifier.
 */
string qualifierString() { result = "Argument[this]" }

string parameterAccess(CS::Parameter p) {
  if Collections::isCollectionType(p.getType())
  then result = "Argument[" + p.getPosition() + "].Element"
  else result = "Argument[" + p.getPosition() + "]"
}

class InstanceParameterNode = DataFlowPrivate::InstanceParameterNode;

class ParameterPosition = DataFlowDispatch::ParameterPosition;

/**
 * Gets the MaD string representation of return through parameter at position
 * `pos` of callable `c`.
 */
bindingset[c]
string paramReturnNodeAsOutput(CS::Callable c, ParameterPosition pos) {
  result = parameterAccess(c.getParameter(pos.getPosition()))
  or
  pos.isThisParameter() and
  result = qualifierString()
}

/**
 * Gets the enclosing callable of `ret`.
 */
CS::Callable returnNodeEnclosingCallable(DataFlow::Node ret) {
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
 * Gets the MaD input string representation of `source`.
 */
string asInputArgumentSpecific(DataFlow::Node source) {
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
