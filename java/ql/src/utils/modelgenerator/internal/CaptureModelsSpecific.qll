/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

private import java as J
private import semmle.code.java.dataflow.internal.DataFlowPrivate
private import semmle.code.java.dataflow.internal.ContainerFlow as ContainerFlow
private import semmle.code.java.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.java.dataflow.internal.ModelExclusions
private import semmle.code.java.dataflow.DataFlow as Df
private import semmle.code.java.dataflow.SSA as Ssa
private import semmle.code.java.dataflow.TaintTracking as Tt
import semmle.code.java.dataflow.ExternalFlow as ExternalFlow
import semmle.code.java.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
import semmle.code.java.dataflow.internal.DataFlowPrivate as DataFlowPrivate
import semmle.code.java.dataflow.internal.DataFlowDispatch as DataFlowDispatch

module DataFlow = Df::DataFlow;

module TaintTracking = Tt::TaintTracking;

class Type = J::Type;

class Unit = J::Unit;

class Callable = J::Callable;

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

private predicate hasManualModel(Callable api) {
  api = any(FlowSummaryImpl::Public::SummarizedCallable sc | sc.applyManualModel()).asCallable() or
  api = any(FlowSummaryImpl::Public::NeutralSummaryCallable sc | sc.hasManualModel()).asCallable()
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
 * Holds if it is irrelevant to generate models for `api` based on type-based analysis.
 *
 * This serves as an extra filter for the `relevant` predicate.
 */
predicate isUninterestingForTypeBasedFlowModels(Callable api) { none() }

/**
 * A class of callables that are potentially relevant for generating summary, source, sink
 * and neutral models.
 *
 * In the Standard library and 3rd party libraries it is the callables (or callables that have a
 * super implementation) that can be called from outside the library itself.
 */
class TargetApiSpecific extends Callable {
  private Callable lift;

  TargetApiSpecific() {
    lift = liftedImpl(this) and
    not hasManualModel(lift)
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
 * Returns the appropriate type name for the model.
 */
private string typeAsModel(Callable c) {
  exists(RefType type | type = c.getDeclaringType() |
    result =
      type.getCompilationUnit().getPackage().getName() + ";" +
        type.getErasure().(J::RefType).nestedName()
  )
}

private predicate partialModel(
  Callable api, string type, string extensible, string name, string parameters
) {
  type = typeAsModel(api) and
  extensible = isExtensible(api) and
  name = api.getName() and
  parameters = ExternalFlow::paramsString(api)
}

/**
 * Computes the first 6 columns for MaD rows.
 */
string asPartialModel(TargetApiSpecific api) {
  exists(string type, string extensible, string name, string parameters |
    partialModel(api.lift(), type, extensible, name, parameters) and
    result =
      type + ";" //
        + extensible + ";" //
        + name + ";" //
        + parameters + ";" //
        + /* ext + */ ";" //
  )
}

/**
 * Computes the first 4 columns for neutral MaD rows.
 */
string asPartialNeutralModel(TargetApiSpecific api) {
  exists(string type, string name, string parameters |
    partialModel(api, type, _, name, parameters) and
    result =
      type + ";" //
        + name + ";" //
        + parameters + ";" //
  )
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

private class ManualNeutralSinkCallable extends Callable {
  ManualNeutralSinkCallable() {
    this =
      any(FlowSummaryImpl::Public::NeutralCallable nc |
        nc.hasManualModel() and nc.getKind() = "sink"
      ).asCallable()
  }
}

/**
 * Holds if `source` is an api entrypoint relevant for creating sink models.
 */
predicate apiSource(DataFlow::Node source) {
  (
    source.asExpr().(J::FieldAccess).isOwnFieldAccess() or
    source instanceof DataFlow::ParameterNode
  ) and
  exists(Callable enclosing | enclosing = source.getEnclosingCallable() |
    exists(liftedImpl(enclosing)) and
    not enclosing instanceof ManualNeutralSinkCallable and
    exists(J::RefType t |
      t = enclosing.getDeclaringType().getAnAncestor() and
      not t instanceof J::TypeObject and
      t.isPublic()
    )
  )
}

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
