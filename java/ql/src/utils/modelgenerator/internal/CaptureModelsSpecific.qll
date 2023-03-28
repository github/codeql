/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

private import java as J
private import semmle.code.java.dataflow.internal.DataFlowPrivate
private import semmle.code.java.dataflow.internal.ContainerFlow as ContainerFlow
private import semmle.code.java.dataflow.DataFlow as Df
private import semmle.code.java.dataflow.SSA as Ssa
private import semmle.code.java.dataflow.TaintTracking as Tt
import semmle.code.java.dataflow.ExternalFlow as ExternalFlow
import semmle.code.java.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
import semmle.code.java.dataflow.internal.DataFlowPrivate as DataFlowPrivate

module DataFlow = Df::DataFlow;

module TaintTracking = Tt::TaintTracking;

class Type = J::Type;

class Unit = J::Unit;

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
  cu.getPackage().getName().matches("sun%") or
  cu.getPackage().getName().matches("jdk%") or
  cu.getPackage().getName().matches("java2d%") or
  cu.getPackage().getName().matches("build.tools%") or
  cu.getPackage().getName().matches("propertiesparser%") or
  cu.getPackage().getName().matches("org.jcp%") or
  cu.getPackage().getName().matches("org.w3c%") or
  cu.getPackage().getName().matches("org.ietf.jgss%") or
  cu.getPackage().getName().matches("org.xml.sax%") or
  cu.getPackage().getName().matches("com.oracle%") or
  cu.getPackage().getName().matches("org.omg%") or
  cu.getPackage().getName().matches("org.relaxng%") or
  cu.getPackage().getName() = "compileproperties" or
  cu.getPackage().getName() = "transparentruler" or
  cu.getPackage().getName() = "genstubs" or
  cu.getPackage().getName() = "netscape.javascript" or
  cu.getPackage().getName() = ""
}

private predicate isInfrequentlyUsed(J::CompilationUnit cu) {
  cu.getPackage().getName().matches("javax.swing%") or
  cu.getPackage().getName().matches("java.awt%")
}

/**
 * Holds if it is relevant to generate models for `api`.
 */
private predicate isRelevantForModels(J::Callable api) {
  not isInTestFile(api.getCompilationUnit().getFile()) and
  not isJdkInternal(api.getCompilationUnit()) and
  not isInfrequentlyUsed(api.getCompilationUnit()) and
  not api instanceof J::MainMethod and
  not api instanceof J::StaticInitializer and
  not exists(J::FunctionalExpr funcExpr | api = funcExpr.asMethod()) and
  not api.(J::Constructor).isParameterless()
}

/**
 * Holds if it is relevant to generate models for `api` based on data flow analysis.
 */
predicate isRelevantForDataFlowModels(J::Callable api) {
  isRelevantForModels(api) and
  (not api.getDeclaringType() instanceof J::Interface or exists(api.getBody()))
}

predicate isRelevantForTypeBasedFlowModels = isRelevantForModels/1;

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
 * Computes the first 6 columns for MaD rows.
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
 * Computes the first 4 columns for neutral MaD rows.
 */
string asPartialNeutralModel(TargetApiSpecific api) {
  exists(string type, string name, string parameters |
    partialModel(api, type, name, parameters) and
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

/**
 * Gets the MaD string represention of the the return node `node`.
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
  source.getEnclosingCallable().isPublic() and
  exists(J::RefType t |
    t = source.getEnclosingCallable().getDeclaringType().getAnAncestor() and
    not t instanceof J::TypeObject and
    t.isPublic()
  ) and
  isRelevantForModels(source.getEnclosingCallable()) and
  exists(asPartialModel(source.getEnclosingCallable()))
}

/**
 * Gets the MaD input string representation of `source`.
 */
string asInputArgumentSpecific(DataFlow::Node source) {
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
