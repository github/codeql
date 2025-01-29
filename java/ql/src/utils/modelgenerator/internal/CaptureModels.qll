/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

private import java as J
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow as ExternalFlow
private import semmle.code.java.dataflow.internal.ContainerFlow as ContainerFlow
private import semmle.code.java.dataflow.internal.DataFlowDispatch
private import semmle.code.java.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
private import semmle.code.java.dataflow.internal.DataFlowImplSpecific
private import semmle.code.java.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.code.java.dataflow.internal.DataFlowUtil as DataFlowUtil
private import semmle.code.java.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.java.dataflow.internal.ModelExclusions
private import semmle.code.java.dataflow.internal.TaintTrackingImplSpecific
private import semmle.code.java.dataflow.SSA as Ssa
private import semmle.code.java.dataflow.TaintTracking
private import codeql.mad.modelgenerator.internal.ModelGeneratorImpl

/**
 * Holds if the type `t` is a primitive type used for bulk data.
 */
predicate isPrimitiveTypeUsedForBulkData(J::Type t) {
  t.hasName(["byte", "char", "Byte", "Character"])
}

module ModelGeneratorInput implements ModelGeneratorInputSig<Location, JavaDataFlow> {
  class Type = J::Type;

  class Parameter = J::Parameter;

  class Callable = J::Callable;

  class NodeExtended extends DataFlow::Node {
    Callable getAsExprEnclosingCallable() { result = this.asExpr().getEnclosingCallable() }
  }

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

  predicate isUninterestingForDataFlowModels(Callable api) {
    api.getDeclaringType() instanceof J::Interface and not exists(api.getBody())
  }

  predicate isUninterestingForHeuristicDataFlowModels(Callable api) { none() }

  class SourceOrSinkTargetApi extends Callable {
    SourceOrSinkTargetApi() { relevant(this) }
  }

  class SinkTargetApi extends SourceOrSinkTargetApi {
    SinkTargetApi() { not hasManualSinkModel(this) }
  }

  class SourceTargetApi extends SourceOrSinkTargetApi {
    SourceTargetApi() { not hasManualSourceModel(this) }
  }

  class SummaryTargetApi extends Callable {
    private Callable lift;

    SummaryTargetApi() {
      lift = liftedImpl(this) and
      not hasManualSummaryModel(lift)
    }

    Callable lift() { result = lift }

    predicate isRelevant() {
      relevant(this) and
      not hasManualSummaryModel(this)
    }
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

  predicate isRelevantType(Type t) {
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

  Type getUnderlyingContentType(DataFlow::ContentSet c) {
    result = c.(DataFlow::FieldContent).getField().getType() or
    result = c.(DataFlow::SyntheticFieldContent).getField().getType()
  }

  string qualifierString() { result = "Argument[this]" }

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

  string parameterContentAccess(J::Parameter p) { result = "Argument[" + p.getPosition() + "]" }

  class InstanceParameterNode = DataFlow::InstanceParameterNode;

  bindingset[c]
  string paramReturnNodeAsOutput(Callable c, ParameterPosition pos) {
    result = parameterAccess(c.getParameter(pos))
    or
    result = qualifierString() and pos = -1
  }

  bindingset[c]
  string paramReturnNodeAsContentOutput(Callable c, ParameterPosition pos) {
    result = parameterContentAccess(c.getParameter(pos))
    or
    result = qualifierString() and pos = -1
  }

  Callable returnNodeEnclosingCallable(DataFlow::Node ret) {
    result = DataFlowImplCommon::getNodeEnclosingCallable(ret).asCallable()
  }

  predicate isOwnInstanceAccessNode(DataFlowPrivate::ReturnNode node) {
    node.asExpr().(J::ThisAccess).isOwnInstanceAccess()
  }

  predicate sinkModelSanitizer(DataFlow::Node node) {
    // exclude variable capture jump steps
    exists(Ssa::SsaImplicitInit closure |
      closure.captures(_) and
      node.asExpr() = closure.getAFirstUse()
    )
  }

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

  predicate irrelevantSourceSinkApi(Callable source, SourceTargetApi api) { none() }

  string getInputArgument(DataFlow::Node source) {
    exists(int pos |
      source.(DataFlow::ParameterNode).isParameterOf(_, pos) and
      if pos >= 0 then result = "Argument[" + pos + "]" else result = qualifierString()
    )
    or
    source.asExpr() instanceof J::FieldAccess and
    result = qualifierString()
  }

  bindingset[kind]
  predicate isRelevantSinkKind(string kind) {
    not kind = "log-injection" and
    not kind.matches("regex-use%") and
    not kind = "file-content-store"
  }

  bindingset[kind]
  predicate isRelevantSourceKind(string kind) { any() }

  predicate containerContent = DataFlowPrivate::containerContent/1;

  predicate isAdditionalContentFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    TaintTracking::defaultAdditionalTaintStep(node1, node2, _) and
    not exists(DataFlow::Content f |
      DataFlowPrivate::readStep(node1, f, node2) and containerContent(f)
    )
  }

  predicate isField(DataFlow::ContentSet c) {
    c instanceof DataFlowUtil::FieldContent or
    c instanceof DataFlowUtil::SyntheticFieldContent
  }

  predicate isCallback(DataFlow::ContentSet c) { none() }

  string getSyntheticName(DataFlow::ContentSet c) {
    exists(Field f |
      not f.isPublic() and
      f = c.(DataFlowUtil::FieldContent).getField() and
      result = f.getQualifiedName()
    )
    or
    result = c.(DataFlowUtil::SyntheticFieldContent).getField()
  }

  string printContent(DataFlow::ContentSet c) {
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

  string partialModelRow(Callable api, int i) {
    i = 0 and qualifiedName(api, result, _) // package
    or
    i = 1 and qualifiedName(api, _, result) // type
    or
    i = 2 and result = isExtensible(api) // extensible
    or
    i = 3 and result = api.getName() // name
    or
    i = 4 and result = ExternalFlow::paramsString(api) // parameters
    or
    i = 5 and result = "" and exists(api) // ext
  }

  string partialNeutralModelRow(Callable api, int i) {
    i = 0 and qualifiedName(api, result, _) // package
    or
    i = 1 and qualifiedName(api, _, result) // type
    or
    i = 2 and result = api.getName() // name
    or
    i = 3 and result = ExternalFlow::paramsString(api) // parameters
  }

  predicate sourceNode = ExternalFlow::sourceNode/2;

  predicate sinkNode = ExternalFlow::sinkNode/2;
}

import MakeModelGenerator<Location, JavaDataFlow, JavaTaintTracking, ModelGeneratorInput>
