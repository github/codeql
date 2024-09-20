/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

private import java as J
private import semmle.code.java.dataflow.internal.DataFlowPrivate
private import semmle.code.java.dataflow.internal.DataFlowUtil as DataFlowUtil
private import semmle.code.java.dataflow.internal.ContainerFlow as ContainerFlow
private import semmle.code.java.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.java.dataflow.internal.ModelExclusions
private import semmle.code.java.dataflow.DataFlow as Df
private import semmle.code.java.dataflow.internal.ContentDataFlow as Cdf
private import semmle.code.java.dataflow.SSA as Ssa
private import semmle.code.java.dataflow.TaintTracking as Tt
import semmle.code.java.dataflow.ExternalFlow as ExternalFlow
import semmle.code.java.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
import semmle.code.java.dataflow.internal.DataFlowPrivate as DataFlowPrivate
import semmle.code.java.dataflow.internal.DataFlowDispatch as DataFlowDispatch

module DataFlow = Df::DataFlow;

module ContentDataFlow = Cdf::ContentDataFlow;

module TaintTracking = Tt::TaintTracking;

class Type = J::Type;

class Unit = J::Unit;

class Callable = J::Callable;

class ContentSet = DataFlowUtil::ContentSet;

private predicate isInfrequentlyUsed(J::CompilationUnit cu) {
  cu.getPackage().getName().matches("javax.swing%") or
  cu.getPackage().getName().matches("java.awt%")
}

private predicate relevant(Callable api) {
  api.isPublic() and
  api.getDeclaringType().isPublic() and
  api.fromSource() and
  not isUninterestingForModels(api) and
  not isInfrequentlyUsed(api.getCompilationUnit())
}

private J::Method getARelevantOverride(J::Method m) {
  result = m.getAnOverride() and
  relevant(result) and
  // Other exclusions for overrides.
  not m instanceof J::ToStringMethod
}

/**
 * Gets the super implementation of `m` if it is relevant.
 * If such a super implementations does not exist, returns `m` if it is relevant.
 */
private J::Callable liftedImpl(J::Callable m) {
  (
    result = getARelevantOverride(m)
    or
    result = m and relevant(m)
  ) and
  not exists(getARelevantOverride(result))
}

private predicate hasManualSummaryModel(Callable api) {
  api = any(FlowSummaryImpl::Public::SummarizedCallable sc | sc.applyManualModel()).asCallable() or
  api = any(FlowSummaryImpl::Public::NeutralSummaryCallable sc | sc.hasManualModel()).asCallable()
}

private predicate hasManualSourceModel(Callable api) {
  api = any(ExternalFlow::SourceCallable sc | sc.hasManualModel()) or
  api = any(FlowSummaryImpl::Public::NeutralSourceCallable sc | sc.hasManualModel()).asCallable()
}

private predicate hasManualSinkModel(Callable api) {
  api = any(ExternalFlow::SinkCallable sc | sc.hasManualModel()) or
  api = any(FlowSummaryImpl::Public::NeutralSinkCallable sc | sc.hasManualModel()).asCallable()
}

/**
 * Holds if it is irrelevant to generate models for `api` based on data flow analysis.
 *
 * This serves as an extra filter for the `relevant` predicate.
 */
predicate isUninterestingForDataFlowModels(Callable api) {
  api.getDeclaringType() instanceof J::Interface and not exists(api.getBody())
}

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
  SourceTargetApi() { not hasManualSourceModel(this) }
}

/**
 * Holds if it is irrelevant to generate models for `api` based on type-based analysis.
 *
 * This serves as an extra filter for the `relevant` predicate.
 */
predicate isUninterestingForTypeBasedFlowModels(Callable api) { none() }

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
   */
  Callable lift() { result = lift }

  /**
   * Holds if this callable is relevant in terms of generating models.
   */
  predicate isRelevant() { relevant(this) }
}

private string isExtensible(Callable c) {
  if c.getDeclaringType().isFinal() then result = "false" else result = "true"
}

/**
 * Holds if the callable `c` is in package `package`
 * and is a member of `type`.
 */
private predicate qualifiedName(Callable c, string package, string type) {
  exists(RefType t | t = c.getDeclaringType() |
    package = t.getCompilationUnit().getPackage().getName() and
    type = t.getErasure().(J::RefType).getNestedName()
  )
}

predicate partialModel(
  Callable api, string package, string type, string extensible, string name, string parameters
) {
  qualifiedName(api, package, type) and
  extensible = isExtensible(api) and
  name = api.getName() and
  parameters = ExternalFlow::paramsString(api)
}

predicate isPrimitiveTypeUsedForBulkData(J::Type t) {
  t.hasName(["byte", "char", "Byte", "Character"])
}

/**
 * Holds for type `t` for fields that are relevant as an intermediate
 * read or write step in the data flow analysis.
 */
predicate isRelevantType(J::Type t) {
  not t instanceof J::TypeClass and
  not t instanceof J::EnumType and
  not t instanceof J::PrimitiveType and
  not t instanceof J::BoxedType and
  not t.(J::RefType).getAnAncestor().hasQualifiedName("java.lang", "Number") and
  not t.(J::RefType).getAnAncestor().hasQualifiedName("java.nio.charset", "Charset") and
  (
    not t.(J::Array).getElementType() instanceof J::PrimitiveType or
    isPrimitiveTypeUsedForBulkData(t.(J::Array).getElementType())
  ) and
  (
    not t.(J::Array).getElementType() instanceof J::BoxedType or
    isPrimitiveTypeUsedForBulkData(t.(J::Array).getElementType())
  ) and
  (
    not t.(ContainerFlow::CollectionType).getElementType() instanceof J::BoxedType or
    isPrimitiveTypeUsedForBulkData(t.(ContainerFlow::CollectionType).getElementType())
  )
}

/**
 * Gets the underlying type of the content `c`.
 */
J::Type getUnderlyingContentType(DataFlow::Content c) {
  result = c.(DataFlow::FieldContent).getField().getType() or
  result = c.(DataFlow::SyntheticFieldContent).getField().getType()
}

/**
 * Gets the MaD string representation of the qualifier.
 */
string qualifierString() { result = "Argument[this]" }

/**
 * Gets the MaD string representation of the parameter `p`.
 */
string parameterAccess(J::Parameter p) {
  if
    p.getType() instanceof J::Array and
    not isPrimitiveTypeUsedForBulkData(p.getType().(J::Array).getElementType())
  then result = "Argument[" + p.getPosition() + "].ArrayElement"
  else
    if p.getType() instanceof ContainerFlow::ContainerType
    then result = "Argument[" + p.getPosition() + "].Element"
    else result = "Argument[" + p.getPosition() + "]"
}

/**
 * Gets the MaD string representation of the parameter `p`
 * when used in content flow.
 */
string parameterContentAccess(J::Parameter p) { result = "Argument[" + p.getPosition() + "]" }

class InstanceParameterNode = DataFlow::InstanceParameterNode;

class ParameterPosition = DataFlowDispatch::ParameterPosition;

/**
 * Gets the MaD string representation of return through parameter at position
 * `pos` of callable `c`.
 */
bindingset[c]
string paramReturnNodeAsOutput(Callable c, ParameterPosition pos) {
  result = parameterAccess(c.getParameter(pos))
  or
  result = qualifierString() and pos = -1
}

/**
 * Gets the MaD string representation of return through parameter at position
 * `pos` of callable `c` for content flow.
 */
bindingset[c]
string paramReturnNodeAsContentOutput(Callable c, ParameterPosition pos) {
  result = parameterContentAccess(c.getParameter(pos))
  or
  result = qualifierString() and pos = -1
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
predicate isOwnInstanceAccessNode(ReturnNode node) {
  node.asExpr().(J::ThisAccess).isOwnInstanceAccess()
}

predicate sinkModelSanitizer(DataFlow::Node node) {
  // exclude variable capture jump steps
  exists(Ssa::SsaImplicitInit closure |
    closure.captures(_) and
    node.asExpr() = closure.getAFirstUse()
  )
}

/**
 * Holds if `source` is an api entrypoint relevant for creating sink models.
 */
predicate apiSource(DataFlow::Node source) {
  (
    source.asExpr().(J::FieldAccess).isOwnFieldAccess() or
    source instanceof DataFlow::ParameterNode
  ) and
  exists(J::RefType t |
    t = source.getEnclosingCallable().getDeclaringType().getAnAncestor() and
    not t instanceof J::TypeObject and
    t.isPublic()
  )
}

/**
 * Holds if it is not relevant to generate a source model for `api`, even
 * if flow is detected from a node within `source` to a sink within `api`.
 */
predicate irrelevantSourceSinkApi(Callable source, SourceTargetApi api) { none() }

/**
 * Gets the MaD input string representation of `source`.
 */
string asInputArgumentSpecific(DataFlow::Node source) {
  exists(int pos |
    source.(DataFlow::ParameterNode).isParameterOf(_, pos) and
    if pos >= 0 then result = "Argument[" + pos + "]" else result = qualifierString()
  )
  or
  source.asExpr() instanceof J::FieldAccess and
  result = qualifierString()
}

/**
 * Holds if `kind` is a relevant sink kind for creating sink models.
 */
bindingset[kind]
predicate isRelevantSinkKind(string kind) {
  not kind = "log-injection" and
  not kind.matches("regex-use%") and
  not kind = "file-content-store"
}

/**
 * Holds if `kind` is a relevant source kind for creating source models.
 */
bindingset[kind]
predicate isRelevantSourceKind(string kind) { any() }

predicate containerContent = DataFlowPrivate::containerContent/1;

/**
 * Holds if there is a taint step from `node1` to `node2` in content flow.
 */
predicate isAdditionalContentFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
  TaintTracking::defaultAdditionalTaintStep(node1, node2, _) and
  not exists(DataFlow::Content f |
    DataFlowPrivate::readStep(node1, f, node2) and containerContent(f)
  )
}

/**
 * Holds if the content set `c` is a field or a synthetic field.
 */
predicate isField(ContentSet c) {
  c instanceof DataFlowUtil::FieldContent or
  c instanceof DataFlowUtil::SyntheticFieldContent
}

/**
 * Gets the MaD synthetic name string representation for the content set `c`, if any.
 */
string getSyntheticName(DataFlow::ContentSet c) {
  exists(Field f |
    not f.isPublic() and
    f = c.(DataFlowUtil::FieldContent).getField() and
    result = f.getQualifiedName()
  )
  or
  result = c.(DataFlowUtil::SyntheticFieldContent).getField()
}

/**
 * Gets the MaD string representation of the content set `c`.
 */
string printContent(ContentSet c) {
  exists(Field f | f = c.(DataFlowUtil::FieldContent).getField() and f.isPublic() |
    result = "Field[" + f.getQualifiedName() + "]"
  )
  or
  result = "SyntheticField[" + getSyntheticName(c) + "]"
  or
  c instanceof DataFlowUtil::CollectionContent and result = "Element"
  or
  c instanceof DataFlowUtil::ArrayContent and result = "ArrayElement"
  or
  c instanceof DataFlowUtil::MapValueContent and result = "MapValue"
  or
  c instanceof DataFlowUtil::MapKeyContent and result = "MapKey"
}
