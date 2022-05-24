/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

private import java as J
private import semmle.code.java.dataflow.internal.DataFlowNodes
// private import semmle.code.java.dataflow.internal.DataFlowPrivate
private import semmle.code.java.dataflow.internal.ContainerFlow as ContainerFlow
private import semmle.code.java.dataflow.DataFlow as Df
private import semmle.code.java.dataflow.TaintTracking as Tt
private import semmle.code.java.dataflow.internal.TaintTrackingUtil as TaintTrackingUtil
import semmle.code.java.dataflow.ExternalFlow as ExternalFlow
import semmle.code.java.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
import semmle.code.java.dataflow.internal.DataFlowPrivate as DataFlowPrivate
import semmle.code.java.dataflow.internal.ContentDataFlow

module DataFlow = Df::DataFlow;

module TaintTracking = Tt::TaintTracking;

class Type = J::Type;

private J::Method superImpl(J::Method m) {
  result = m.getAnOverride() and
  not exists(result.getAnOverride()) and
  not m instanceof J::ToStringMethod
}

private predicate isInTestFile(J::File file) {
  file.getAbsolutePath().matches("%src/test/%") or
  file.getAbsolutePath().matches("%/guava-tests/%") or
  file.getAbsolutePath().matches("%/guava-testlib/%")
}

private predicate isJdkInternal(J::CompilationUnit cu) {
  cu.getPackage().getName().matches("org.graalvm%") or
  cu.getPackage().getName().matches("com.sun%") or
  cu.getPackage().getName().matches("javax.swing%") or
  cu.getPackage().getName().matches("java.awt%") or
  cu.getPackage().getName().matches("sun%") or
  cu.getPackage().getName().matches("jdk.%") or
  cu.getPackage().getName().matches("java2d.%") or
  cu.getPackage().getName().matches("build.tools.%") or
  cu.getPackage().getName().matches("propertiesparser.%") or
  cu.getPackage().getName().matches("org.jcp.%") or
  cu.getPackage().getName().matches("org.w3c.%") or
  cu.getPackage().getName().matches("org.ietf.jgss.%") or
  cu.getPackage().getName().matches("org.xml.sax%") or
  cu.getPackage().getName() = "compileproperties" or
  cu.getPackage().getName() = "netscape.javascript" or
  cu.getPackage().getName() = ""
}

/**
 * Holds if it is relevant to generate models for `api`.
 */
private predicate isRelevantForModels(J::Callable api) {
  not isInTestFile(api.getCompilationUnit().getFile()) and
  not isJdkInternal(api.getCompilationUnit()) and
  not api instanceof J::MainMethod and
  not api instanceof J::StaticInitializer
}

/**
 * Holds if content `c` is either a field or synthetic field of a relevant type
 * or a container like content.
 */
predicate isRelevantContent(DataFlow::Content c) {
  isRelevantType(c.(DataFlow::FieldContent).getField().getType()) or
  isRelevantType(c.(DataFlow::SyntheticFieldContent).getField().getType()) or
  DataFlowPrivate::containerContent(c)
}

/**
 * A class of Callables that are relevant for generating summary, source and sinks models for.
 *
 * In the Standard library and 3rd party libraries it the Callables that can be called
 * from outside the library itself.
 */
class TargetApiSpecific extends J::Callable {
  TargetApiSpecific() {
    this.isPublic() and
    this.fromSource() and
    (
      this.getDeclaringType().isPublic() or
      superImpl(this).getDeclaringType().isPublic()
    ) and
    isRelevantForModels(this)
  }
}

private string isExtensible(J::RefType ref) {
  if ref.isFinal() then result = "false" else result = "true"
}

private string typeAsModel(J::RefType type) {
  result = type.getCompilationUnit().getPackage().getName() + ";" + type.nestedName()
}

private J::RefType bestTypeForModel(TargetApiSpecific api) {
  if exists(superImpl(api))
  then superImpl(api).fromSource() and result = superImpl(api).getDeclaringType()
  else result = api.getDeclaringType()
}

/**
 * Returns the appropriate type name for the model. Either the type
 * declaring the method or the supertype introducing the method.
 */
private string typeAsSummaryModel(TargetApiSpecific api) {
  result = typeAsModel(bestTypeForModel(api))
}

private predicate partialModel(TargetApiSpecific api, string type, string name, string parameters) {
  type = typeAsSummaryModel(api) and
  name = api.getName() and
  parameters = ExternalFlow::paramsString(api)
}

/**
 * Computes the first 6 columns for CSV rows.
 */
string asPartialModel(TargetApiSpecific api) {
  exists(string type, string name, string parameters |
    partialModel(api, type, name, parameters) and
    result =
      type + ";" //
        + isExtensible(bestTypeForModel(api)) + ";" //
        + name + ";" //
        + parameters + ";" //
        + /* ext + */ ";" //
  )
}

/**
 * Computes the first 4 columns for negative CSV rows.
 */
string asPartialNegativeModel(TargetApiSpecific api) {
  exists(string type, string name, string parameters |
    partialModel(api, type, name, parameters) and
    result =
      type + ";" //
        + name + ";" //
        + parameters + ";" //
  )
}

private predicate isPrimitiveTypeUsedForBulkData(J::Type t) {
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
 * Gets the CSV string representation of the qualifier.
 */
string qualifierString() { result = "Argument[-1]" }

private string parameterAccess(J::Parameter p) { result = "Argument[" + p.getPosition() + "]" }

/**
 * Gets the CSV string representation of the parameter node `p`.
 */
string parameterNodeAsInput(DataFlow::ParameterNode p) {
  result = parameterAccess(p.asParameter())
  or
  result = qualifierString() and p instanceof DataFlow::InstanceParameterNode
}

/**
 * Gets the CSV string represention of the the return node `node`.
 */
string returnNodeAsOutput(DataFlowImplCommon::ReturnNodeExt node) {
  if node.getKind() instanceof DataFlowImplCommon::ValueReturnKind
  then result = "ReturnValue"
  else
    exists(int pos |
      pos = node.getKind().(DataFlowImplCommon::ParamUpdateReturnKind).getPosition()
    |
      result = parameterAccess(node.getEnclosingCallable().getParameter(pos))
      or
      result = qualifierString() and pos = -1
    )
}

/**
 * Gets the enclosing callable of `ret`.
 */
J::Callable returnNodeEnclosingCallable(DataFlowImplCommon::ReturnNodeExt ret) {
  result = DataFlowImplCommon::getNodeEnclosingCallable(ret).asCallable()
}

/**
 * Language specific parts of the `PropagateToSinkConfiguration`.
 */
class PropagateToSinkConfigurationSpecific extends TaintTracking::Configuration {
  PropagateToSinkConfigurationSpecific() { this = "parameters or fields flowing into sinks" }

  override predicate isSource(DataFlow::Node source) {
    (
      source.asExpr().(J::FieldAccess).isOwnFieldAccess() or
      source instanceof DataFlow::ParameterNode
    ) and
    source.getEnclosingCallable().isPublic() and
    exists(J::RefType t |
      t = source.getEnclosingCallable().getDeclaringType().getAnAncestor() and
      not t instanceof J::TypeObject and
      t.isPublic()
    ) and
    isRelevantForModels(source.getEnclosingCallable())
  }
}

/**
 * Gets the CSV input string representation of `source`.
 */
string asInputArgument(DataFlow::Node source) {
  exists(int pos |
    source.(DataFlow::ParameterNode).isParameterOf(_, pos) and
    result = "Argument[" + pos + "]"
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
  not kind = "logging" and
  not kind.matches("regex-use%") and
  not kind = "write-file"
}

/**
 * Holds if `kind` is a relevant source kind for creating source models.
 */
bindingset[kind]
predicate isRelevantSourceKind(string kind) { any() }

string printContent(DataFlow::Content c) {
  exists(J::Field f |
    f = c.(DataFlow::FieldContent).getField() and
    if f.isPublic()
    then result = "Field[" + f.getQualifiedName() + "]"
    else result = "SyntheticField[" + f.getQualifiedName() + "]"
  )
  or
  c instanceof DataFlow::ArrayContent and
  result = "ArrayElement"
  or
  c instanceof DataFlow::MapKeyContent and
  result = "MapKey"
  or
  c instanceof DataFlow::MapValueContent and
  result = "MapValue"
  or
  exists(string f |
    f = c.(DataFlow::SyntheticFieldContent).getField() and
    result = "SyntheticField[" + f + "]"
  )
}

predicate taintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  TaintTrackingUtil::defaultAdditionalTaintStep(nodeFrom, nodeTo) and
  not DataFlowPrivate::readStep(nodeFrom, _, nodeTo)
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
