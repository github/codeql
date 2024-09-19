/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

private import csharp as CS
private import semmle.code.csharp.commons.Util as Util
private import semmle.code.csharp.commons.Collections as Collections
private import semmle.code.csharp.commons.QualifiedName as QualifiedName
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch
private import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.frameworks.system.linq.Expressions
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate as TaintTrackingPrivate
import semmle.code.csharp.dataflow.internal.ExternalFlow as ExternalFlow
import semmle.code.csharp.dataflow.internal.ContentDataFlow as ContentDataFlow
import semmle.code.csharp.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
import semmle.code.csharp.dataflow.internal.DataFlowPrivate as DataFlowPrivate
import semmle.code.csharp.dataflow.internal.DataFlowDispatch as DataFlowDispatch

module DataFlow = CS::DataFlow;

module TaintTracking = CS::TaintTracking;

class Type = CS::Type;

class Callable = CS::Callable;

class ContentSet = DataFlow::ContentSet;

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
 * A class of callables that are potentially relevant for generating source or
 * sink models.
 */
class SourceOrSinkTargetApi extends Callable {
  SourceOrSinkTargetApi() { relevant(this) }
}

/**
 * A class of callables that are potentially relevant for generating sink models.
 */
class SinkTargetApi extends SourceOrSinkTargetApi {
  SinkTargetApi() { not hasManualSinkModel(this) }
}

/**
 * A class of callables that are potentially relevant for generating source models.
 */
class SourceTargetApi extends SourceOrSinkTargetApi {
  SourceTargetApi() {
    not hasManualSourceModel(this) and
    // Do not generate source models for overridable callables
    // as virtual dispatch implies that too many methods
    // will be considered sources.
    not this.(Overridable).overridesOrImplements(_)
  }
}

/**
 * A class of callables that are potentially relevant for generating summary or
 * neutral models.
 *
 * In the Standard library and 3rd party libraries it is the callables (or callables that have a
 * super implementation) that can be called from outside the library itself.
 */
class SummaryTargetApi extends Callable {
  private Callable lift;

  SummaryTargetApi() {
    lift = liftedImpl(this) and
    not hasManualSummaryModel(lift)
  }

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
private CS::Type getUnderlyingContType(DataFlow::Content c) {
  result = c.(DataFlow::FieldContent).getField().getType() or
  result = c.(DataFlow::SyntheticFieldContent).getField().getType()
}

/**
 * Gets the underlying type of the content `c`.
 */
CS::Type getUnderlyingContentType(DataFlow::ContentSet c) {
  exists(DataFlow::Content cont |
    c.isSingleton(cont) and
    result = getUnderlyingContType(cont)
  )
  or
  exists(CS::Property p |
    c.isProperty(p) and
    result = p.getType()
  )
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

/**
 * Gets the MaD string representation of the parameter `p`
 * when used in content flow.
 */
string parameterContentAccess(CS::Parameter p) { result = "Argument[" + p.getPosition() + "]" }

class InstanceParameterNode = DataFlowPrivate::InstanceParameterNode;

class ParameterPosition = DataFlowDispatch::ParameterPosition;

private signature string parameterAccessSig(Parameter p);

module ParamReturnNodeAsOutput<parameterAccessSig/1 getParamAccess> {
  bindingset[c]
  string paramReturnNodeAsOutput(CS::Callable c, ParameterPosition pos) {
    result = getParamAccess(c.getParameter(pos.getPosition()))
    or
    pos.isThisParameter() and
    result = qualifierString()
  }
}

/**
 * Gets the MaD string representation of return through parameter at position
 * `pos` of callable `c`.
 */
bindingset[c]
string paramReturnNodeAsOutput(CS::Callable c, ParameterPosition pos) {
  result = ParamReturnNodeAsOutput<parameterAccess/1>::paramReturnNodeAsOutput(c, pos)
}

bindingset[c]
string paramReturnNodeAsContentOutput(Callable c, ParameterPosition pos) {
  result = ParamReturnNodeAsOutput<parameterContentAccess/1>::paramReturnNodeAsOutput(c, pos)
}

/**
 * Gets the enclosing callable of `ret`.
 */
Callable returnNodeEnclosingCallable(DataFlow::Node ret) {
  result = DataFlowImplCommon::getNodeEnclosingCallable(ret).asCallable(_)
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

/**
 * Holds if the the content `c` is a container.
 */
predicate containerContent(DataFlow::ContentSet c) { c.isElement() }

/**
 * Holds if there is a taint step from `node1` to `node2` in content flow.
 */
predicate isAdditionalContentFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  TaintTrackingPrivate::defaultAdditionalTaintStep(nodeFrom, nodeTo, _) and
  not nodeTo.asExpr() instanceof CS::ElementAccess and
  not exists(DataFlow::ContentSet c |
    DataFlowPrivate::readStep(nodeFrom, c, nodeTo) and containerContent(c)
  )
}

bindingset[d]
private string getFullyQualifiedName(Declaration d) {
  exists(string qualifier, string name |
    d.hasFullyQualifiedName(qualifier, name) and
    result = QualifiedName::getQualifiedName(qualifier, name)
  )
}

/**
 * Holds if the content set `c` is a field, property or synthetic field.
 */
predicate isField(ContentSet c) { c.isField(_) or c.isSyntheticField(_) or c.isProperty(_) }

/**
 * Gets the MaD synthetic name string representation for the content set `c`, if any.
 */
string getSyntheticName(DataFlow::ContentSet c) {
  exists(CS::Field f |
    not f.isEffectivelyPublic() and
    c.isField(f) and
    result = getFullyQualifiedName(f)
  )
  or
  exists(CS::Property p |
    not p.isEffectivelyPublic() and
    c.isProperty(p) and
    result = getFullyQualifiedName(p)
  )
  or
  c.isSyntheticField(result)
}

/**
 * Gets the MaD string representation of the content set `c`.
 */
string printContent(DataFlow::ContentSet c) {
  exists(CS::Field f, string name | name = getFullyQualifiedName(f) |
    c.isField(f) and
    f.isEffectivelyPublic() and
    result = "Field[" + name + "]"
  )
  or
  exists(CS::Property p, string name | name = getFullyQualifiedName(p) |
    c.isProperty(p) and
    p.isEffectivelyPublic() and
    result = "Property[" + name + "]"
  )
  or
  result = "SyntheticField[" + getSyntheticName(c) + "]"
  or
  c.isElement() and
  result = "Element"
}
