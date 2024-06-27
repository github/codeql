/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

private import csharp as CS
private import semmle.code.csharp.commons.Util as Util
private import semmle.code.csharp.commons.Collections as Collections
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch
private import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.frameworks.system.linq.Expressions
private import semmle.code.csharp.frameworks.System
import semmle.code.csharp.dataflow.internal.ExternalFlow as ExternalFlow
import semmle.code.csharp.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
import semmle.code.csharp.dataflow.internal.DataFlowPrivate as DataFlowPrivate
import semmle.code.csharp.dataflow.internal.DataFlowDispatch as DataFlowDispatch

module DataFlow = CS::DataFlow;

module TaintTracking = CS::TaintTracking;

class Type = CS::Type;

class Callable = CS::Callable;

/**
 * Holds if any of the parameters of `api` are `System.Func<>`.
 */
private predicate isHigherOrder(Callable api) {
  exists(Type t | t = api.getAParameter().getType().getUnboundDeclaration() |
    t instanceof SystemLinqExpressions::DelegateExtType
  )
}

private predicate irrelevantAccessor(CS::Accessor a) {
  a.getDeclaration().(CS::Property).isReadWrite()
}

private predicate isUninterestingForModels(Callable api) {
  api.getDeclaringType().getNamespace().getFullName() = ""
  or
  api instanceof CS::ConversionOperator
  or
  api instanceof Util::MainMethod
  or
  api instanceof CS::Destructor
  or
  api instanceof CS::AnonymousFunctionExpr
  or
  api.(CS::Constructor).isParameterless()
  or
  exists(Type decl | decl = api.getDeclaringType() |
    decl instanceof SystemObjectClass or
    decl instanceof SystemValueTypeClass
  )
  or
  // Disregard properties that have both a get and a set accessor,
  // which implicitly means auto implemented properties.
  irrelevantAccessor(api)
}

private predicate relevant(Callable api) {
  [api.(CS::Modifiable), api.(CS::Accessor).getDeclaration()].isEffectivelyPublic() and
  api.fromSource() and
  api.isUnboundDeclaration() and
  not isUninterestingForModels(api)
}

private Callable getARelevantOverrideeOrImplementee(Overridable m) {
  m.overridesOrImplements(result) and relevant(result)
}

/**
 * Gets the super implementation of `api` if it is relevant.
 * If such a super implementation does not exist, returns `api` if it is relevant.
 */
private Callable liftedImpl(Callable api) {
  (
    result = getARelevantOverrideeOrImplementee(api)
    or
    result = api and relevant(api)
  ) and
  not exists(getARelevantOverrideeOrImplementee(result))
}

private predicate hasManualSummaryModel(Callable api) {
  api = any(FlowSummaryImpl::Public::SummarizedCallable sc | sc.applyManualModel()) or
  api = any(FlowSummaryImpl::Public::NeutralSummaryCallable sc | sc.hasManualModel())
}

private predicate hasManualSourceModel(Callable api) {
  api = any(ExternalFlow::SourceCallable sc | sc.hasManualModel()) or
  api = any(FlowSummaryImpl::Public::NeutralSourceCallable sc | sc.hasManualModel())
}

private predicate hasManualSinkModel(Callable api) {
  api = any(ExternalFlow::SinkCallable sc | sc.hasManualModel()) or
  api = any(FlowSummaryImpl::Public::NeutralSinkCallable sc | sc.hasManualModel())
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
 * A class of callables that are potentially relevant for generating summary and
 * neutral models.
 */
class SummaryTargetApi extends TargetApiBase {
  SummaryTargetApi() { not hasManualSummaryModel(this.lift()) }
}

/**
 * A class of callables that are potentially relevant for generating sink models.
 */
class SinkTargetApi extends TargetApiBase {
  SinkTargetApi() { not hasManualSinkModel(this.lift()) }
}

/**
 * A class of callables that are potentially relevant for generating source models.
 */
class SourceTargetApi extends TargetApiBase {
  SourceTargetApi() { not hasManualSourceModel(this.lift()) }
}

/**
 * A class of callables that are potentially relevant for generating summary, source, sink
 * and neutral models.
 *
 * In the Standard library and 3rd party libraries it is the callables (or callables that have a
 * super implementation) that can be called from outside the library itself.
 */
class TargetApiBase extends Callable {
  private Callable lift;

  TargetApiBase() { lift = liftedImpl(this) }

  /**
   * Gets the callable that a model will be lifted to.
   *
   * The lifted callable is relevant in terms of model
   * generation (this is ensured by `liftedImpl`).
   */
  Callable lift() { result = lift }

  /**
   * Holds if `this` is relevant in terms of model generation.
   */
  predicate isRelevant() { relevant(this) }
}

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
  not t instanceof SystemDateTimeStruct and
  not t instanceof SystemTypeClass and
  not irrelevantCollectionType(t)
}

/**
 * Gets the underlying type of the content `c`.
 */
CS::Type getUnderlyingContentType(DataFlow::Content c) {
  result = c.(DataFlow::FieldContent).getField().getType() or
  result = c.(DataFlow::SyntheticFieldContent).getField().getType() or
  result = c.(DataFlow::PropertyContent).getProperty().getType()
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
Callable returnNodeEnclosingCallable(DataFlow::Node ret) {
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
  isRelevantMemberAccess(source) or source instanceof DataFlow::ParameterNode
}

private predicate uniquelyCalls(DataFlowCallable dc1, DataFlowCallable dc2) {
  exists(DataFlowCall call |
    dc1 = call.getEnclosingCallable() and
    dc2 = unique(DataFlowCallable dc0 | dc0 = viableCallable(call) | dc0)
  )
}

bindingset[dc1, dc2]
private predicate uniquelyCallsPlus(DataFlowCallable dc1, DataFlowCallable dc2) =
  fastTC(uniquelyCalls/2)(dc1, dc2)

/**
 * Holds if it is not relevant to generate a source model for `api`, even
 * if flow is detected from a node within `source` to a sink within `api`.
 */
bindingset[sourceEnclosing, api]
predicate irrelevantSourceSinkApi(Callable sourceEnclosing, SourceTargetApi api) {
  not exists(DataFlowCallable dc1, DataFlowCallable dc2 | uniquelyCallsPlus(dc1, dc2) or dc1 = dc2 |
    dc1.getUnderlyingCallable() = api and
    dc2.getUnderlyingCallable() = sourceEnclosing
  )
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
predicate isRelevantSourceKind(string kind) { any() }
